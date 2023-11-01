import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/domain/repository/bluetooth_device_entity.dart';
import 'package:equatable/equatable.dart';

abstract class BluetoothBlocState extends Equatable {
  int get id;

  @override
  List<Object?> get props => [id];
}
extension $ on BluetoothBlocState{

  bool get isOff=>this==BluetoothOff();
  bool get isOn => this==BluetoothOn(currentDevice: BluetoothDeviceEntity.orEmpty());
  bool get isTurningOn => this==BluetoothTurningOn();
  bool get isError => this == BluetoothError(errorMessage: '',code: 0);
}

class BluetoothOff extends BluetoothBlocState {
  final currentDevice = BluetoothDeviceEntity.orEmpty();
  @override
  int get id => 0;
}

class BluetoothTurningOn extends BluetoothBlocState {
  final currentDevice = BluetoothDeviceEntity.orEmpty();
  @override
  int get id => 1;
}

class BluetoothOn extends BluetoothBlocState {
  final BluetoothDeviceEntity currentDevice;
  BluetoothOn({required this.currentDevice});
  @override
  int get id => 2;
}

class BluetoothError extends BluetoothBlocState {
  final currentDevice = BluetoothDeviceEntity.orEmpty();

  final String errorMessage;
  final int code;

  BluetoothError({required this.errorMessage,required this.code});

  /// to make the error unique
  @override
  int get id => 3;
}
