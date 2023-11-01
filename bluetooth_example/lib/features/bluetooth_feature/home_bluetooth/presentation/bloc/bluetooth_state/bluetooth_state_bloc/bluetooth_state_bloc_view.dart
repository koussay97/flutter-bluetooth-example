import 'package:bluetooth_example/features/bluetooth_feature/connect_device/presentation/bloc/connect_device_bloc/connect_device_bloc_event.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/data/repository_impl/bluetooth_state_repository_impl.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/data/repository_impl/location_repository_impl.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/presentation/bloc/bluetooth_state/bluetooth_state_bloc/bluetooth_state_bloc_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bluetooth_state_bloc_bloc.dart';

class BluetoothStateBlocPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BluetoothStateBloc(
          locRepository: LocationRepositoryIMPL(),
          blRepository: BluetoothStateRepositoryIMPL())
        ..add(InitBluetoothEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<BluetoothStateBloc>(context);

    return Container();
  }
}
