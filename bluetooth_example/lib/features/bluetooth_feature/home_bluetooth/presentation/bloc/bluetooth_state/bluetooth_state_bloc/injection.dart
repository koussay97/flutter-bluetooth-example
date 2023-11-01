import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/data/repository_impl/bluetooth_state_repository_impl.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/data/repository_impl/location_repository_impl.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/domain/repository/bluetooth_state_base_repository.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/domain/repository/location_baserepository.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/presentation/bloc/bluetooth_state/bluetooth_state_bloc/bluetooth_state_bloc.dart';
import 'package:get_it/get_it.dart';

Future<void> initHomeBluetooth({required GetIt sl}) async {
  sl.registerLazySingleton<BluetoothStateRepository>(
      () => BluetoothStateRepositoryIMPL());
  sl.registerLazySingleton<LocationBaseRepository>(
      () => LocationRepositoryIMPL());
  sl.registerFactory<BluetoothStateBloc>(() =>
      BluetoothStateBloc(blRepository: sl.call(), locRepository: sl.call())
        ..add(InitBluetoothEvent()));
}
