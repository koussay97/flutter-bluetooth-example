import 'package:bluetooth_example/core/routing/route_generator.dart';
import 'package:bluetooth_example/core/routing/route_names.dart';
import 'package:bluetooth_example/core/utils/bleutooth_repository_implementation.dart';
import 'package:bluetooth_example/core/utils/location_repository_implementation.dart';
import 'package:bluetooth_example/core/utils/scroll_behavior.dart';
import 'package:bluetooth_example/features/bluetooth_feature/bloototh_view_model.dart';

import 'package:bluetooth_example/features/esp32-command-screen/page_scroll_view_model.dart';
import 'package:bluetooth_example/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MultiProvider(
      providers: [
       ChangeNotifierProvider<PageScrollViewModel>(create: (_){
         final vm = PageScrollViewModel();
         vm.init();
         return vm;
       }),
        ChangeNotifierProvider<BluetoothViewModel>(create: (_)=>BluetoothViewModel(
            locationRepositoryIMPL: LocationRepositoryIMPL(),
            repositoryIMPL: BluetoothRepositoryIMPL()))
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      scrollBehavior: MyBehavior(),
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
