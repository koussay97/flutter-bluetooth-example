import 'dart:async';

import 'package:bluetooth_example/core/errors/failures.dart';
import 'package:bluetooth_example/core/utils/bleutooth_repository_implementation.dart';
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

  BluetoothRepositoryIMPL repositoryIMPL;
  late SystemState currentState;

  BluetoothDevice currentDevice = const BluetoothDevice(
      name: 'UNKNOWN', address: 'UNKNOWN', isConnected: false);
  bool loading = false;

  BluetoothViewModel({required this.repositoryIMPL}) {
    enableBluetooth = false;
    discoveryEnabled = false;
    currentState = SystemState.initial;
    _init.call();
    notifyListeners();
  }

  /// this function will enable bluetooth
  /// firstly the toggle btn will work, then we call the repository function
  /// and try enabling the bluetooth, if it fails we will fall back to the
  /// false value
  Future<Either<Failure, bool>> toggleBtn() async {
    enableBluetooth = !enableBluetooth;
    notifyListeners();
    if(enableBluetooth){
      return await repositoryIMPL.openBluetooth(on: true).then((result) {
        result.fold((l) {
          enableBluetooth = false;
          notifyListeners();
        }, (r) {});

        return result;
      });
    }else{
      return await repositoryIMPL.openBluetooth(on: false).then((result) {
        result.fold((l) {
          enableBluetooth = true;
          notifyListeners();
        }, (r) {});
        return result;
      });

    }

  }

  /// test stream for testing purposes
  Stream<BluetoothDiscoveryResult> devicesStream() async* {
    for (int i = 0; i <= 6; i++) {
      yield BluetoothDiscoveryResult(
          device: BluetoothDevice(
              address: "${i * i + 15}",
              isConnected: false,
              name: 'Test Device',
              bondState: BluetoothBondState.none),
          rssi: 20);
      await Future.delayed(Duration(seconds: i));
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
        await getCurrentDeviceData().then((res) {
          res.fold((l) {
            debugPrint('error from init : getCurrentDeviceData() : res.left ${l.message}');
          }, (r) {
            currentState = SystemState.secondState;
            notifyListeners();
          });
          return res;
        });
      }
    } else {
      currentState = SystemState.initial;
      notifyListeners();
    }
  }

  Future<Either<Failure, BluetoothDevice>> getCurrentDeviceData() async {
    return await repositoryIMPL.getDeviceData().then((result) {
      result.fold((l) {
        currentDevice = const BluetoothDevice(
            name: 'UNKNOWN', address: 'UNKNOWN', isConnected: false);

        debugPrint('error from getCurrentDeviceData() : left ${l.message}');

        }, (r) {
        currentDevice = r;
        notifyListeners();
      });
      return result;
    });
  }
/* Future<void> _setDeviceData() async {
    /// (bluetooth is on + permission is grated)  && toggle btn is on
    /// currentState == CustomBluetoothState.secondState
    debugPrint('currentState ${currentState.toString()}');
    debugPrint('toggle val $toggleValue');
    if (currentState == CustomBluetoothState.secondState && toggleValue) {
      await Future.wait([
        FlutterBluetoothSerial.instance.name,
        FlutterBluetoothSerial.instance.address,
        FlutterBluetoothSerial.instance.isDiscoverable
      ]).then((value) {
        debugPrint(value.toString());
        currentDevice.name = (value[0] as String?) ?? 'U';
        currentDevice.address = (value[1] as String?) ?? 'U';
        currentDevice.isDiscoverable = (value[2] as bool?) ?? false;
        notifyListeners();
      });
    } else {
      currentDevice.name = 'Unknown';
      currentDevice.address = 'Unknown';
      currentDevice.isDiscoverable = false;
      notifyListeners();
    }
    debugPrint(currentDevice.toString());
  }*/

/*  Future<void> tryEnableBluetooth() async {
    await Future.wait(
            [Permission.bluetooth.status, Permission.bluetoothConnect.status])
        .then((value) {
      if (value[0].isGranted && value[1].isGranted) {
        toggleValue = !toggleValue;

        if (toggleValue) {
          currentState = CustomBluetoothState.secondState;
        } else {
          currentState = CustomBluetoothState.intermediate1;
        }
      }
      toggleValue = false;
      currentState = CustomBluetoothState.initial;
      _setDeviceData();
      notifyListeners();
    });
  }*/
}
