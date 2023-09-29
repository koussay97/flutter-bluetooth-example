
import 'package:bluetooth_example/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract interface class BluetoothRepository {
  Future<Either<Failure, bool>> openBluetooth();

  Future<Either<Failure, BluetoothDevice>> getDeviceData();

  Future<Either<Failure, int>> setDiscoverable(
      {required int durationInSeconds});

  Future<Either<Failure, Stream<BluetoothDiscoveryResult>>> scanDevices();

  Future<Either<Failure, bool>> pairDevice({required String deviceAddress});

  Future<Either<Failure, bool>> unpairDevice({required String deviceAddress});

  Future<Either<Failure, List<BluetoothDevice>>> getTheListOfPairedDevices();

  Future<Either<Failure, void>> sendData(
      {required String address, required Map<String, dynamic> data});

  Future<Either<Failure, Map<String, dynamic>>> readData(
      {required String address});

  Future<Either<Failure, void>> closeConnection();
}