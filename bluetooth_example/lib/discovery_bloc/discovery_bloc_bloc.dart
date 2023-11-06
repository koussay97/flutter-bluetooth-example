import 'package:bloc/bloc.dart';
import 'discovery_bloc_event.dart';
import 'discovery_bloc_state.dart';

class DiscoveryBlocBloc extends Bloc<DiscoveryBlocEvent, DiscoveryBlocState> {
  DiscoveryBlocBloc() : super(DiscoveryBlocState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<DiscoveryBlocState> emit) async {
    emit(state.clone());
  }
}
