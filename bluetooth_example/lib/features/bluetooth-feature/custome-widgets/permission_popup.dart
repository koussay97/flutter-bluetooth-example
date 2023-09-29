import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/core/routing/pop_screen_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';


Future <void> requestPermission ({required BuildContext context, required double deviceWidth})async{
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
            await Future.wait([
              Permission.bluetoothConnect.request(),
              Permission.bluetoothScan.request()
            ]).then((value) async {
              if (await Permission
                  .bluetoothConnect.isGranted &&
                  await Permission
                      .bluetoothScan.isGranted) {
                Navigator.of(context).pop();
              }
            });
          }),
      centerIcon: Icon(Icons.bluetooth,
          color: Brand.brightTeal,
          size: Brand.appPadding(context: context)),
      innerPadding: Brand.appPadding(context: context),
      text:
      'we require the current permissions to operate,'
          ' bluetooth connect permission && bluetooth base permission ');
}
