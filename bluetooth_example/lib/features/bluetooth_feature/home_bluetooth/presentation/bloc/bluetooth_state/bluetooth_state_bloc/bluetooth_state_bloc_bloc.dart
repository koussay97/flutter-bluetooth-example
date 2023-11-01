import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/domain/repository/bluetooth_state_base_repository.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/domain/repository/location_baserepository.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/presentation/bloc/bluetooth_state/bluetooth_state_bloc/bloc_helpers.dart';

import 'bluetooth_state_bloc_event.dart';
import 'bluetooth_state_bloc_state.dart';

class BluetoothStateBloc
    extends Bloc<BluetoothStateBlocEvent, BluetoothBlocState> {
  final BluetoothStateRepository blRepository;
  final LocationBaseRepository locRepository;
  late final StreamSubscription<BluetoothBlocState>? subscription;
  BluetoothStateBloc({required this.blRepository, required this.locRepository})
      : super(BluetoothOff()) {

    on<InitBluetoothEvent>((event, emit) async => await BlocHelper.init(
        blRepository: blRepository,
        emit: emit,
        event: event,
        locRepository: locRepository).then((value)async {
      await intSubscription();
    }));
    on<TurnOnBluetoothEvent>((event, emit) async => await BlocHelper.turnOn(
        blRepository: blRepository,
        locRepository: locRepository,
        event: event,
        emit: emit).then((value)async {
      await intSubscription();
    }));
    on<TurnOffBluetoothEvent>((event, emit) async => await BlocHelper.turnOff(
        blRepository: blRepository,
        locRepository: locRepository,
        event: event,
        emit: emit));
  }

Future<void> intSubscription()async{
    if(subscription!=null){
      subscription!.cancel();
    }else{
      // this subscription is coming from the Android os,
      // we need to fire events manually so that our app gets notified when the user
      // toggles bluetooth from outside
      final result= await  BlocHelper.listenToPackage(blRepository: blRepository);
      result.fold((l) => null, (r) {
        if(r!=null){
          subscription=r.listen((event) {
            if(event is BluetoothOff){
              add(TurnOffBluetoothEvent());
            }
            if(event is BluetoothOn){
              add(TurnOnBluetoothEvent());
            }
          });
        }
      });
    }
}
@override
  Future<void> close() {
    subscription?.cancel();
    subscription=null;
    return super.close();
  }
}
