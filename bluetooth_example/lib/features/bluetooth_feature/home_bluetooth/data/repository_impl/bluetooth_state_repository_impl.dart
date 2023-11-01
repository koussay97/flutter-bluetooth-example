import 'dart:async';
import 'dart:ui';

import 'package:bluetooth_example/core/errors/failures.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/data/repository_impl/helper.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/data/repository_impl/home_bluetooth_permission_checker.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/domain/repository/bluetooth_device_entity.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/domain/repository/bluetooth_state_base_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

/// implement Flutter bluetooth serial package functions if we have permissions
/// if we don't we need to return an error

class BluetoothStateRepositoryIMPL implements BluetoothStateRepository {
  @override
  Future<Either<Failure, bool>> closeBluetooth() async {
    return await Helper.highOrderFunction<bool>(
        callBack: () async =>
            await FlutterBluetoothSerial.instance.requestDisable(),
        fallbackValue: false);
  }

  @override
  Future<Either<Failure, Stream<BluetoothState>?>>
      getBluetoothCurrentState() async {
    return await Helper.highOrderFunction<Stream<BluetoothState>?>(
        callBack: () async => FlutterBluetoothSerial.instance.onStateChanged(),
        fallbackValue: null);
  }

  @override
  Future<Either<Failure, bool>> openBluetooth() async {
    return await Helper.highOrderFunction<bool>(
        callBack: () async =>
            await FlutterBluetoothSerial.instance.requestEnable(),
        fallbackValue: false);
  }

  @override
  Future<Either<Failure, bool>> isBluetoothConnected() async {
    return await Helper.highOrderFunction<bool>(
        callBack: () async => await FlutterBluetoothSerial.instance.isEnabled,
        fallbackValue: false);
  }

  @override
  Future<Either<Failure, BluetoothDeviceEntity>> getDeviceData() async {
    return await Helper.highOrderFunction<BluetoothDeviceEntity>(
        callBack: () async => await _constructDevice(),
        fallbackValue: BluetoothDeviceEntity.orEmpty());
  }

  Future<BluetoothDeviceEntity> _constructDevice() async {
    final data = await Future.wait([
      FlutterBluetoothSerial.instance.address,
      FlutterBluetoothSerial.instance.name,
      FlutterBluetoothSerial.instance.state,
    ]);
    return BluetoothDeviceEntity.orEmpty(
      address: (data[0] as String?),
      name: (data[1] as String?),
      isConnected: (data[2] as BluetoothState) == BluetoothState.STATE_ON ||
          (data[2] as BluetoothState) == BluetoothState.STATE_BLE_ON,
    );
  }
}
