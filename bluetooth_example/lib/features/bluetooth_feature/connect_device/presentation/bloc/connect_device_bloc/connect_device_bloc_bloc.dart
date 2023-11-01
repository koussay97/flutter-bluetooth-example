import 'package:bloc/bloc.dart';

import 'connect_device_bloc_event.dart';
import 'connect_device_bloc_state.dart';

class ConnectDeviceBlocBloc extends Bloc<ConnectDeviceBlocEvent, ConnectDeviceBlocState> {
  ConnectDeviceBlocBloc() : super(ConnectDeviceBlocState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<ConnectDeviceBlocState> emit) async {
    emit(state.clone());
  }
}
