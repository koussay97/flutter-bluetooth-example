import 'dart:async';

import 'package:bluetooth_example/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class BluetoothPermissionChecker {
  static Future<Either<PermissionFailure, bool>>
      isAllowedToOpenBluetooth() async {
    final checkResults = await Future.wait([
      Permission.bluetooth.status.isGranted,
      Permission.bluetoothConnect.status.isGranted,

    ]);

    final permissionBLState = checkResults[0];
    final permissionBLConnect = checkResults[1];

    if (permissionBLState && permissionBLConnect) {
      return Future.value(const Right(true));
    }

    return Future.value(const Left(PermissionFailure(
        message: 'we request permission to open bluetooth ', code: 0)));
  }

  static Future<Either<PermissionFailure, bool>>
      isAllowedToShowDeviceData() async {
    /*
    * rules:
    * - bluetooth must be opened
    * - permissions must be granted ( Permission.bluetoothConnect, Permission.bluetoothScan)
    * */
    final checkResults = await Future.wait([
      Permission.bluetoothConnect.status.isGranted,
      Permission.bluetoothScan.status.isGranted,
      FlutterBluetoothSerial.instance.isEnabled
    ]);

    final bool permissionBLConnect = checkResults[0] ?? false;
    final bool permissionBLScan = checkResults[1] ?? false;
    final bool bluetoothServiceConnected = checkResults[2] ?? false;

    if (permissionBLScan && permissionBLConnect) {
      if (!bluetoothServiceConnected) {
        return Future.value(const Right(false));
      }
      return Future.value(const Right(true));
    }

    return Future.value(const Left(PermissionFailure(
        message: 'we request permission to scan devices', code: 0)));
  }

  static Future<Either<PermissionFailure, bool>>
      isAllowedToBeDiscoverable() async {
    /*
    * rules:
    * - bluetooth must be opened
    * - permissions must be granted ( Permission.bluetoothScan, Permission.bluetoothAdvertise)
    * */

    final checkResults = await Future.wait([
      Permission.bluetoothConnect.status.isGranted,
      Permission.bluetoothScan.status.isGranted,
      Permission.bluetoothAdvertise.status.isGranted,
      FlutterBluetoothSerial.instance.isEnabled
    ]);

    final bool permissionBLConnect = checkResults[0] ?? false;
    final bool permissionBLScan = checkResults[1] ?? false;
    final permissionBLDiscoverable = checkResults[2] ?? false;
    final bool bluetoothServiceConnected = checkResults[3] ?? false;

    if (permissionBLScan && permissionBLDiscoverable && permissionBLConnect) {
      if (!bluetoothServiceConnected) {
        return Future.value(const Right(false));
      }
      return Future.value(const Right(true));
    }
    return Future.value(const Left(PermissionFailure(
        message: 'we request permission to scan devices', code: 0)));
  }

  static Future<Either<PermissionFailure, bool>>
      isAllowedToScanForDevices() async {
    /*
    * rules:
    * - bluetooth must be opened
    * - permissions must be granted ( Permission.bluetoothScan, Permission.bluetoothConnect)
    * */
    final checkResults = await Future.wait([
      Permission.bluetoothConnect.status.isGranted,
      Permission.bluetoothScan.status.isGranted,
      FlutterBluetoothSerial.instance.isEnabled
    ]);

    final bool permissionBLConnect = checkResults[0] ?? false;
    final bool permissionBLScan = checkResults[1] ?? false;
    final bool bluetoothServiceConnected = checkResults[2] ?? false;

    if (permissionBLScan && permissionBLConnect) {
      if (!bluetoothServiceConnected) {
        return Future.value(const Right(false));
      }
      return Future.value(const Right(true));
    }
    return Future.value(const Left(PermissionFailure(
        message: 'we request permission to scan devices', code: 0)));
  }

  static Future<Either<Failure, bool>> isAllowedToReceiveAndSendData(
      {required String deviceAddress}) async {
    /*
    * rules:
    * - bluetooth must be opened
    * - permissions must be granted ( Permission.bluetoothScan, Permission.bluetoothConnect)
    * - device must have established connection
    * */

    final checkResults = await Future.wait([
      Permission.bluetoothConnect.status.isGranted,
      Permission.bluetoothScan.status.isGranted,
      FlutterBluetoothSerial.instance.isEnabled
    ]);

    final bool permissionBLConnect = checkResults[0] ?? false;
    final bool permissionBLScan = checkResults[1] ?? false;
    final bool bluetoothServiceConnected = checkResults[2] ?? false;

    if (permissionBLScan && permissionBLConnect) {
      if (!bluetoothServiceConnected) {
        return Future.value(const Right(false));
      }

      final interDeviceConnection = await FlutterBluetoothSerial.instance
          .getBondStateForAddress(deviceAddress)
          .then((value) {
        if (!value.isBonded) {
          return Future.value(const Left(
              ConnectionFailure(message: 'lost connection', code: 1)));
        }
        return Future.value(const Right(true));
      });
    }

    return Future.value(const Left(PermissionFailure(
        message: 'we request permission to scan devices', code: 0)));
  }
}



