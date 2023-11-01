import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/core/routing/route_names.dart';
import 'package:bluetooth_example/features/bluetooth_feature/bloototh_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

import 'bluetooth_widgets.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final currentIndex =
        context.select<BluetoothViewModel, int?>((value) => value.currentIndex);
    final state = context
        .select<BluetoothViewModel, SystemState>((value) => value.currentState);

    final discoveryList =
        context.watch<BluetoothViewModel>().listOfDevicesDiscovered;
   print('current list from provider ${discoveryList.length}');
    /// keep this for testing
    /* final discoveryList = [
      BluetoothDiscoveryResult(device: const BluetoothDevice(address: 'aezraz',type: BluetoothDeviceType.dual,name: 'dfssdf',))
    ];*/

    if (discoveryList.isEmpty) {
      return BluetoothStateEmptyScreen(
        cardHeight: deviceWidth,
        cardWidth: deviceWidth,
        state: state,
      );
    }
    return ListView.builder(
        itemCount: discoveryList.length,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          horizontal: Brand.appPadding(context: context) * 0.5,
          vertical: Brand.appPadding(context: context) * 0.3,
        ),
        itemBuilder: (context, index) {
          return DeviceCard(
            onTappedExplore: () {
              Navigator.pushNamed(context, RouteAccessors.exploreName,
                  arguments: discoveryList[index]);
            },
            onTappedView: () {
              if (index == currentIndex) {
                context
                    .read<BluetoothViewModel>()
                    .setCurrentTapIndex(index: null);
              } else {
                context
                    .read<BluetoothViewModel>()
                    .setCurrentTapIndex(index: index);
              }
            },
            onTappedConnect: () {
              // we should check if the device
              // is bounded or not and call the appropriate function
            },
            isCardSelected: index == currentIndex,
            width: deviceWidth,
            height: deviceWidth * 0.23,
            device: discoveryList[index],
          );
        });
  }
}
