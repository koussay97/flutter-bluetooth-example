import 'dart:async';

import 'package:bluetooth_example/core/errors/failures.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/domain/repository/bluetooth_device_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract interface class BluetoothStateRepository {
  Future<Either<Failure, bool>> openBluetooth();
  Future<Either<Failure, BluetoothDeviceEntity>> getDeviceData();

  Future<Either<Failure, bool>> closeBluetooth();

  Future<Either<Failure, bool>> isBluetoothConnected();

  Future<Either<Failure, Stream<BluetoothState>?>>
      getBluetoothCurrentState();
}

//BluetoothDevice a =BluetoothDevice(address: '',bondState: '',isConnected: ,name: ,type: '');
