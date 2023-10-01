
import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:flutter/material.dart';

import 'custome-widgets/bluetooth_widgets.dart';

/// rules
/// - initial state : toggle of bluetooth
/// - intermediate state :
/// => if we have BLTooth permission display device data
/// => else show permission popup
/// - bluetooth enabled state :
/// we must see the device data + search device btn
/// - discovery state : we must see the list of close devices :
/// => if no device found, we show message : no device found
/// => show list of devices ::
///   => when clicked on a device list item ======> navigate to esp32 screen

class BluetoothScreen extends StatelessWidget {
  const BluetoothScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        //body: Text('abs'),
        appBar: PreferredSize(
            preferredSize: Size(deviceWidth, deviceWidth * 0.14),
            child: CustomAppBar(deviceWidth: deviceWidth)),
        body: Center(
          child:   Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Brand.appPadding(context: context),
            ),
             HeaderWidget(),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Brand.appPadding(context: context),
                  vertical: Brand.appPadding(context: context)*0.5),
              child: const Divider(height: 2),
            ),


            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Brand.appPadding(context: context),
                  ),
                  child: const FooterWidget()),
            ),
          ],
        ),
        ),
      ),
    );
  }
}




/// -
/// common screen layout :
/// initial state layout ::
/// intermediate 1 : layout
/// second: layout
/// intermediate 2 :
/// final layout :
///
