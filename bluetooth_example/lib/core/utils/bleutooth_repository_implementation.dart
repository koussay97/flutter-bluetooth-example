import 'package:bluetooth_example/core/errors/failures.dart';
import 'package:bluetooth_example/core/utils/bleutooth_repository.dart';
import 'package:bluetooth_example/core/utils/permissin_manager.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothRepositoryIMPL implements BluetoothRepository {
  @override
  Future<Either<Failure, bool>> openBluetooth({required on}) async {
    final check = await BluetoothPermissionChecker.isAllowedToOpenBluetooth();

    return check.fold((l) => Left(l), (r) async {
      try {

         bool? result;
       if(on){
          result= await FlutterBluetoothSerial.instance.requestEnable();
       }else{
         result = await FlutterBluetoothSerial.instance.requestDisable();
       }
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


        final result = bleInstance.startDiscovery().asBroadcastStream();


        return Right(result);
      } catch (e) {
        return Left(PermissionFailure(message: e.toString(), code: 0));
      }
    });
  }

  @override
  Future<Either<Failure, bool>> pairDevice(
      {required String deviceAddress}) async {
    final check = await BluetoothPermissionChecker.isAllowedToBeDiscoverable();

    return  check.fold((l) => Left(l), (r) async {
      try{
        if (!r) {
          return const Left(
              ConnectionFailure(message: 'bluetooth is off', code: 0));
        }
        final pairingResult = await FlutterBluetoothSerial.instance
            .bondDeviceAtAddress(deviceAddress);

        return Right(pairingResult??false);
      }catch(e){
        return Left(PermissionFailure(message: e.toString(), code: 0));
      }

    });
  }

  @override
  Future<Either<Failure, bool>> unpairDevice({required String deviceAddress}) {
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
