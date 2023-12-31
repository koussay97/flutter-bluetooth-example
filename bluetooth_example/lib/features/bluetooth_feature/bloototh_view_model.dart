import 'dart:async';

import 'package:bluetooth_example/core/errors/failures.dart';
import 'package:bluetooth_example/core/utils/bleutooth_repository_implementation.dart';
import 'package:bluetooth_example/core/utils/location_repository_implementation.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

enum SystemState {
  initial, // only show toggle btn
  intermediate1, // Bluetooth permissions grated but its not enabled
  secondState, // bluetooth is enabled => show device data ?
  intermediate2, // discovery failed show message
  finalState, // discovery Successful => show list of devices
}

class BluetoothViewModel extends ChangeNotifier {
  bool enableBluetooth = false;
  bool discoveryEnabled = false;
  int? currentIndex;

  List<BluetoothDiscoveryResult> listOfDevicesDiscovered =
      List<BluetoothDiscoveryResult>.empty(growable: true);

  List<BluetoothConnection> listOfDevicesConnected =
  List<BluetoothConnection>.empty(growable: true);


  StreamSubscription<BluetoothDiscoveryResult>? discoverySubscription;
  BluetoothRepositoryIMPL repositoryIMPL;
  LocationRepositoryIMPL locationRepositoryIMPL;
  late SystemState currentState;

  BluetoothDevice currentDevice = const BluetoothDevice(
      name: 'UNKNOWN', address: 'UNKNOWN', isConnected: false);
  bool loading = false;

  BluetoothViewModel({required this.repositoryIMPL, required this.locationRepositoryIMPL}) {
    enableBluetooth = false;
    discoveryEnabled = false;
    currentIndex=null;
    listOfDevicesDiscovered =
        List<BluetoothDiscoveryResult>.empty(growable: true);
    if (discoverySubscription != null) {
      discoverySubscription?.cancel();
      discoverySubscription = null;
    }
    currentState = SystemState.initial;
    _init.call();
    notifyListeners();
  }

void setCurrentTapIndex({required int? index}){
    currentIndex=index;
    notifyListeners();
}
  /// this function will enable bluetooth
  /// firstly the toggle btn will work, then we call the repository function
  /// and try enabling the bluetooth, if it fails we will fall back to the
  /// false value
  Future<Either<Failure, bool>> toggleBtn() async {
    enableBluetooth = !enableBluetooth;
    notifyListeners();
    if (enableBluetooth) {
      return await repositoryIMPL.openBluetooth(on: true).then((result) {
        result.fold((l) {
          enableBluetooth = false;
          if(l is PermissionFailure){
            currentState=SystemState.initial;
          }else{
            currentState=SystemState.intermediate1;
          }
          notifyListeners();
        }, (r) async {
          await getCurrentDeviceData();
          await locationRepositoryIMPL.turnOnLocation().then((value){
            print('result from location :::: ${value}');

          });
          notifyListeners();
        });

        return result;
      });
    } else {
      return await repositoryIMPL.openBluetooth(on: false).then((result) {
        result.fold((l) {
          enableBluetooth = true;
          notifyListeners();
        }, (r) async {
          await stopDiscovery();
          currentState=SystemState.intermediate1;
          notifyListeners();
        });
        return result;
      });
    }
  }



  /// check if we (initially)!! have bluetooth enabled + check if permission is granted
  /// if we (initially) have permission and bluetooth is disabled we will set
  /// [currentState] to [SystemState.intermediate1] and device data will not change
  /// else if initially we are all set we set the [currentState] to
  /// [SystemState.secondState] and [currentDevice] to the [BluetoothDevice] that
  /// comes from the [BluetoothRepositoryIMPL] function [repositoryIMPL.getDeviceData]
  /// note that we are not returning anything because initialization should
  /// not return anything, we will request permissions on user interaction
  Future<void> _init() async {
    debugPrint('called init');
    final results = await Future.wait([
      Permission.bluetooth.status.isGranted,
      Permission.bluetoothConnect.status.isGranted,
      FlutterBluetoothSerial.instance.isEnabled,
    ]);

    debugPrint('check results for init$results');

    final bool permissionBLState = results[0] ?? false;
    final bool permissionBLConnect = results[1] ?? false;
    final bool bluetoothActive = results[2] ?? false;
    if (permissionBLConnect && permissionBLState) {
      currentState = SystemState.intermediate1;
      notifyListeners();
      if (bluetoothActive) {
        enableBluetooth=true;
        await locationRepositoryIMPL.turnOnLocation();
        notifyListeners();
        await getCurrentDeviceData().then((res) {
          res.fold((l) {
            debugPrint(
                'error from init : getCurrentDeviceData() : res.left ${l.message}');
          }, (r) {
            currentState = SystemState.secondState;
            notifyListeners();
          });
          return res;
        });
      }
    } else {
      enableBluetooth=false;
      currentState = SystemState.initial;
      notifyListeners();
    }
  }

  Future<Either<Failure, BluetoothDevice>> getCurrentDeviceData() async {
    return await repositoryIMPL.getDeviceData().then((result) {
      result.fold((l) {
        currentDevice = const BluetoothDevice(
            name: 'UNKNOWN', address: 'UNKNOWN', isConnected: false);
      }, (r) {
        currentDevice = r;
        currentState=SystemState.secondState;

        notifyListeners();
      });
      return result;
    });
  }

  Future<Either<Failure, void>> stopDiscovery() async {
    print('called stop scan ++++');
    return repositoryIMPL.stopScanningDevices().then((value) {
      value.fold((l) {
        print('failed to stop discovery !! from vm ');
        print(l.message);
      }, (r) {
        currentState = SystemState.secondState;
        discoverySubscription?.pause();
        discoveryEnabled = false;
        listOfDevicesDiscovered=[];
        notifyListeners();
      });
      return value;
    });
  }

  Future<Either<Failure, Stream<BluetoothDiscoveryResult>>>
      startDiscovery() async {

    return await repositoryIMPL.scanDevices().then((value) {
      print('called start discovery');
      value.fold((l) {
        print('start discovery failure ${l.message}');
        if (discoverySubscription != null) {
          discoveryEnabled = false;
          discoverySubscription?.cancel();
          currentState = SystemState.intermediate2;
          discoverySubscription = null;
          notifyListeners();
        }
      }, (r) {
       // print('start discovery success ');

        discoveryEnabled = true;
        currentState = SystemState.finalState;
        if (discoverySubscription != null) {
          print('resume discovery +++ ');
          discoverySubscription?.resume();
          notifyListeners();
        }
        discoverySubscription = r.listen(
                (event) {
              print('incoming device ${event.device.type}');
              final existingIndex = listOfDevicesDiscovered.indexWhere(
                      (element) =>
                  element.device.address == event.device.address);
              if (existingIndex >= 0) {
                listOfDevicesDiscovered[existingIndex] = event;
                notifyListeners();
              } else {
                listOfDevicesDiscovered.add(event);
                notifyListeners();
              }
            },
            onError: (e) {
              discoveryEnabled = false;
              notifyListeners();
            },
            cancelOnError: true,
            onDone: () {
              discoveryEnabled = false;
              discoverySubscription?.cancel();
              notifyListeners();
            });
        notifyListeners();
      });
      return value;
    });
  }

  Future<Either<Failure,bool>>pairDevice({required String deviceAddress})async{
    final result = await repositoryIMPL.pairDevice(deviceAddress: deviceAddress);
    return result;
  }
  BluetoothConnection? currentConnection;

  Future<Either<Failure,BluetoothConnection>>connectDevice({required String deviceAddress})async{
    final device = listOfDevicesDiscovered.firstWhere((element) => element.device.address==deviceAddress);

    if(device.device.isConnected){
      return Right(currentConnection!);
    }
    return await repositoryIMPL.connectToDevice(deviceAddress: deviceAddress).then((result) {
      result.fold((l) {}, (r) {
       // if there is an old connection, we need to ;
        if (currentConnection?.isConnected??false){
          currentConnection?.close();
          currentConnection?.dispose();
          notifyListeners();
        }else{

          currentConnection = r;
          notifyListeners();
        }
      });
      return result;
    });

  }
  @override
  void dispose() {
    currentConnection?.close();
    currentConnection?.dispose();
    discoverySubscription?.cancel();
    discoverySubscription = null;
    super.dispose();
  }
}
