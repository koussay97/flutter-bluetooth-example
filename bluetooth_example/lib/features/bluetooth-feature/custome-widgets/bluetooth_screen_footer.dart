import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/features/bluetooth-feature/bloototh_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'bluetooth_widgets.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final currentIndex =
        context.select<BluetoothViewModel, int?>((value) => value.currentIndex);
    final state =
    context.select<BluetoothViewModel, SystemState>((value) => value.currentState);

    //final discoveryList = watcher.listOfDevicesDiscovered;
    final discoveryList = [];

    if (discoveryList.isEmpty) {
      return BluetoothStateEmptyScreen(cardHeight: deviceWidth,cardWidth: deviceWidth,state: state,);
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
            onTappedExplore: () {},
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
            onTappedConnect: () {},
            isCardSelected: index == currentIndex,
            width: deviceWidth,
            height: deviceWidth * 0.23,
            device: discoveryList[index],
          );
        });
  }
}

