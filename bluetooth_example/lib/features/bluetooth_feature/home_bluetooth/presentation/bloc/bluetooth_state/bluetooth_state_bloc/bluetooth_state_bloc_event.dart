import 'package:equatable/equatable.dart';

abstract class BluetoothStateBlocEvent extends Equatable{

  int get id;
  @override
  List<Object> get props => [id];
}

class InitBluetoothEvent extends BluetoothStateBlocEvent {
  @override
  int get id =>0;
}
class TurnOnBluetoothEvent extends BluetoothStateBlocEvent{
  @override
  int get id => 1;

}
class TurnOffBluetoothEvent extends BluetoothStateBlocEvent{
  @override
  int get id => 2;
}