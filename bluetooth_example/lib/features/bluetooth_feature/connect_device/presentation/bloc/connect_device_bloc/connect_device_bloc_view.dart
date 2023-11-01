import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'connect_device_bloc_bloc.dart';
import 'connect_device_bloc_event.dart';
import 'connect_device_bloc_state.dart';

class ConnectDeviceBlocPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ConnectDeviceBlocBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<ConnectDeviceBlocBloc>(context);

    return Container();
  }
}

