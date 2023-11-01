import 'package:equatable/equatable.dart';

class BluetoothDeviceEntity extends Equatable {
  final String address;
  final String name;
  final bool isConnected;

  const BluetoothDeviceEntity(
      {required this.address, required this.name, required this.isConnected});

 factory BluetoothDeviceEntity.orEmpty(
      {String? address, String? name, bool? isConnected}) {
    return BluetoothDeviceEntity(
        name: name ?? 'UNKNOWN',
        isConnected: isConnected ?? false,
        address: address ?? 'UNKNOWN');
  }

  @override
  List<Object?> get props => [address];
}
