import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'discovery_bloc_bloc.dart';
import 'discovery_bloc_event.dart';
import 'discovery_bloc_state.dart';

class DiscoveryBlocPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => DiscoveryBlocBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<DiscoveryBlocBloc>(context);

    return Container();
  }
}

