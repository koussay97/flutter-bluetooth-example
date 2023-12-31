import 'package:bluetooth_example/core/routing/route_names.dart';
import 'package:bluetooth_example/features/authentication/splash_screen.dart';

import 'package:bluetooth_example/features/bluetooth_feature/bluetooth_screen.dart';
import 'package:bluetooth_example/features/bluetooth_feature/device_explore_screen.dart';
import 'package:bluetooth_example/features/esp32-command-screen/dashboard_screen.dart';
import 'package:flutter/material.dart';

abstract class RouteGenerator {
  static Route<dynamic> onGenerateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case RouteAccessors.dashboardName:
        return MaterialPageRoute(
            settings: settings, builder: (context) => const DashboardScreen());

      case RouteAccessors.bluetoothName:
        return MaterialPageRoute(
            settings: settings, builder: (context) => const BluetoothScreen());

      case RouteAccessors.exploreName:
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => const DeviceExploreScreen());

      default:
        return MaterialPageRoute(
            settings: settings, builder: (context) => SplashScreen());
    }
  }
}
