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

abstract interface class BluetoothRepository {
  Future<Either<Failure, bool>> openBluetooth();

  Future<Either<Failure, BluetoothDevice>> getDeviceData();

  Future<Either<Failure, int>> setDiscoverable(
      {required int durationInSeconds});

  Future<Either<Failure, Stream<BluetoothDiscoveryResult>>> scanDevices();

  Future<Either<Failure, bool>> pairDevice();

  Future<Either<Failure, bool>> unpairDevice();

  Future<Either<Failure, List<BluetoothDevice>>> getTheListOfPairedDevices();

  Future<Either<Failure, void>> sendData(
      {required String address, required Map<String, dynamic> data});

  Future<Either<Failure, Map<String, dynamic>>> readData(
      {required String address});

  Future<Either<Failure, void>> closeConnection();
}

class BluetoothRepositoryIMPL implements BluetoothRepository {
  @override
  Future<Either<Failure, bool>> openBluetooth() async {
    final check = await BluetoothPermissionChecker.isAllowedToOpenBluetooth();

    return check.fold((l) => Left(l), (r) async {
      try {
        /*  if (!r) {
          return const Left(
              ConnectionFailure(message: 'bluetooth is off', code: 0));
        }*/

        final result = await FlutterBluetoothSerial.instance.requestEnable();
        return Right(result ?? false);
      } catch (e) {
        return Left(PermissionFailure(message: e.toString(), code: 0));
      }
    });
  }

  @override
  Future<Either<Failure, BluetoothDevice>> getDeviceData() async {
    final check = await BluetoothPermissionChecker.isAllowedToShowDeviceData();

    return check.fold((l) => left(l), (r) async {
      try {
        if (!r) {
          return const Left(
              ConnectionFailure(message: 'bluetooth is off', code: 0));
        }

        final result = await Future.wait([
          FlutterBluetoothSerial.instance.name,
          FlutterBluetoothSerial.instance.address,
          FlutterBluetoothSerial.instance.state
        ]);
        return Right(BluetoothDevice(
          address: result[0] as String? ?? 'UNKNOWN',
          name: result[0] as String? ?? 'UNKNOWN',
          type: BluetoothDeviceType.dual,
        ));
      } catch (e) {
        return Left(PermissionFailure(message: e.toString(), code: 0));
      }
    });
  }

  @override
  Future<Either<Failure, int>> setDiscoverable(
      {required int durationInSeconds}) async {
    final check = await BluetoothPermissionChecker.isAllowedToBeDiscoverable();
    return check.fold((l) => Left(l), (r) async {
      try {
        if (!r) {
          return const Left(
              ConnectionFailure(message: 'bluetooth is off', code: 0));
        }
        final result = await FlutterBluetoothSerial.instance
            .requestDiscoverable(durationInSeconds);

        /// this will return the duration limit for the set discovery
        return Right(result ?? 0);
      } catch (e) {
        return Left(PermissionFailure(message: e.toString(), code: 0));
      }
    });
  }

  /// this is where we will update the list of the available devices to connect to
  /// - if the device [BluetoothDiscoveryResult] exists in the [devices] list,
  ///    => we will update it
  /// - if the device does not exist, we add it
  /// - if RSSI is weak, we remove the device
  ///
  ///
  ///

  @override
  Future<Either<Failure, Stream<BluetoothDiscoveryResult>>>
      scanDevices() async {
    final bleInstance = FlutterBluetoothSerial.instance;
    final check = await BluetoothPermissionChecker.isAllowedToScanForDevices();
    return check.fold((l) => Left(l), (r) async {
      try {
        if (!r) {
          return const Left(
              ConnectionFailure(message: 'bluetooth is off', code: 0));
        }

        /// this is the list of available bluetooth devices with the signal strength

        /* final Set<BluetoothDiscoveryResult> devices = {};
        final a = BluetoothDiscoveryResult(
            device: const BluetoothDevice(
              name:'name',
              address: 'aaa',
              bondState: BluetoothBondState.bonded,
              isConnected: false,
              type: BluetoothDeviceType.le,
            ),
            rssi: 0);
         */

        final result = bleInstance.startDiscovery().asBroadcastStream();
            /*.listen(
            hel,
            cancelOnError: true,
            onDone: () {

            },
            onError: (a) {});*/

        /* result.drain();

        final result2 =
            bleInstance.startDiscovery().listen((event) {});
        result2.onData((data) { });
        result2.onError((e){
          bleInstance.cancelDiscovery();
        });
        result2.onDone(() { });
        result2.cancel();
       */

        return Right(result);
      } catch (e) {
        return Left(PermissionFailure(message: e.toString(), code: 0));
      }
    });
  }

  @override
  Future<Either<Failure, bool>> pairDevice() {
    // TODO: implement pairDevice
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> unpairDevice() {
    // TODO: implement unpairDevice
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<BluetoothDevice>>> getTheListOfPairedDevices() {
    // TODO: implement getTheListOfPairedDevices
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> readData(
      {required String address}) {
    // TODO: implement readData
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> sendData(
      {required String address, required Map<String, dynamic> data}) {
    // TODO: implement sendData
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> closeConnection() {
    // TODO: implement closeConnection
    throw UnimplementedError();
  }
}
