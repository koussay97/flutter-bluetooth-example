import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/core/routing/pop_screen_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermission(
    {required BuildContext context, required double deviceWidth}) async {
  showPopup(
      context: context,
      title: 'we require bluetooth permission',
      ctaWidget: MaterialButton(
          color: Brand.brightTeal,
          height: deviceWidth * 0.1,
          child: Text('Grant Permission',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: Brand.h3Weight,
                fontSize: Brand.h3Size(context),
              )),
          onPressed: () async {
            /* final bl = await Permission.bluetooth.request();
            final blScan = await Permission.bluetoothScan.request();
            final blConnect = await Permission.bluetoothConnect.request();
            final blLocation = await Permission.locationWhenInUse.request();
            final blLocation2 = await Permission.location.request();
           */
            final results = await [
              Permission.bluetoothAdvertise,
              Permission.bluetoothConnect,
              Permission.bluetooth,
              Permission.bluetoothScan,
              Permission.locationWhenInUse,
              Permission.location
            ].request();
            if (results[Permission.bluetooth] == PermissionStatus.granted &&
                results[Permission.bluetoothScan] == PermissionStatus.granted &&
                results[Permission.bluetoothConnect] ==
                    PermissionStatus.granted &&
                results[Permission.locationWhenInUse] ==
                    PermissionStatus.granted &&
                results[Permission.location] == PermissionStatus.granted &&
                results[Permission.bluetoothAdvertise] ==
                    PermissionStatus.granted)
            /*if (bl.isGranted &&
                blScan.isGranted &&
                blConnect.isGranted &&
                blLocation.isGranted &&
                blLocation2.isGranted)*/ {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 10),
                content: Text('permissions status:: $results'),
              ));
            }
            /*await [
              Permission.bluetoothConnect,
              Permission.bluetoothScan,
              Permission.locationWhenInUse,
              Permission.bluetooth
            ].toList().request().then((value) async {
              debugPrint('permission request results from popup $value');
              if (value[Permission.bluetoothConnect]!.isGranted &&
                  value[Permission.bluetoothScan]!.isGranted &&
                  value[Permission.bluetooth]!.isGranted &&
                  value[Permission.locationWhenInUse]!.isGranted) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pop();
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                   duration: Duration(seconds: 10),
                   content: Text('permissions status:: $value'),));
                //SystemNavigator.pop(animated: true);
              }
            });*/
          }),
      centerIcon: Icon(Icons.bluetooth,
          color: Brand.brightTeal, size: Brand.appPadding(context: context)),
      innerPadding: Brand.appPadding(context: context),
      text: 'we require the current permissions to operate,'
          ' bluetooth connect permission && bluetooth base permission ');
}
