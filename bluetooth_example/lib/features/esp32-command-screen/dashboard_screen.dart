import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final device =
        ModalRoute.of(context)?.settings.arguments as BluetoothDiscoveryResult;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          centerTitle: true,
          title: Text(
            'welcome to ESP32',
            style: GoogleFonts.poppins(color: Colors.white),
          )),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ' device details${device.device.address}',
            style: GoogleFonts.poppins(
                fontSize: Brand.h3Size(context), color: Brand.darkGreyBlue),
          ),
          Text(
            ' device details${device.device.name}',
            style: GoogleFonts.poppins(
                fontSize: Brand.h3Size(context), color: Brand.darkGreyBlue),
          ),
          Text(
            ' device details${device.device.isConnected}',
            style: GoogleFonts.poppins(
                fontSize: Brand.h3Size(context), color: Brand.darkGreyBlue),
          ),
          Text(
            ' device details${device.device.isBonded}',
            style: GoogleFonts.poppins(
                fontSize: Brand.h3Size(context), color: Brand.darkGreyBlue),
          ),
        ],
      )),
    );
  }
}
