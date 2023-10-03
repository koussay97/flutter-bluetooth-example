import 'package:bluetooth_example/core/routing/route_generator.dart';
import 'package:bluetooth_example/core/routing/route_names.dart';
import 'package:bluetooth_example/core/utils/bleutooth_repository_implementation.dart';
import 'package:bluetooth_example/features/bluetooth-feature/bloototh_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider<BluetoothViewModel>(create: (_)=>BluetoothViewModel(repositoryIMPL: BluetoothRepositoryIMPL()))
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: RouteGenerator.onGenerateRoute,
      initialRoute: RouteAccessors.splashName,
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
