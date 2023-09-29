import 'dart:async';

import 'package:bluetooth_example/core/errors/failures.dart';
import 'package:bluetooth_example/core/utils/bleutooth_repository_implementation.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

/*enum CustomBluetoothState {
  initial, // only show toggle btn
  intermediate1, // Bluetooth permissions grated but its not enabled
  secondState, // bluetooth is enabled => show device data ?
  intermediate2, // discovery failed show message
  finalState, // discovery Successful => show list of devices
}*/

class BluetoothViewModel extends ChangeNotifier {
  bool toggleValue = false;
  BluetoothRepositoryIMPL repositoryIMPL;
  //CustomBluetoothState? currentState;

  BluetoothDevice currentDevice =
  const BluetoothDevice(name: 'UNKNOWN', address: 'UNKNOWN',isConnected: false);
  bool loading = false;

  BluetoothViewModel({required this.repositoryIMPL}) {
    toggleValue = false;
    _init.call();
    notifyListeners();
  }

  Future<Either<Failure,bool>> toggleBtn()async{

    return await repositoryIMPL.openBluetooth().then((result) {

      result.fold((l) {
        toggleValue=false;
        notifyListeners();
      },
              (r) {
                toggleValue=!toggleValue;
                notifyListeners();
              });

      return result;
    });

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

  Future<void> _init() async {
    // check if we have bluetooth enabled + check if permission is granted

    // final permissionBLState = await Permission.bluetooth.status;
    // final permissionBLConnect = await Permission.bluetoothConnect.status;
    // final permissionBLDiscoverable = await Permission.bluetoothAdvertise.status;
    // final permissionBLScan = await Permission.bluetoothScan.status;

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

/*class DeviceDataDto {
  String name;
  String address;
  bool isDiscoverable;

  DeviceDataDto(
      {required this.name,
      required this.address,
      required this.isDiscoverable});

  @override
  toString() =>
      'name : $name , address : $address , isDiscoverable : $isDiscoverable';
}*/
