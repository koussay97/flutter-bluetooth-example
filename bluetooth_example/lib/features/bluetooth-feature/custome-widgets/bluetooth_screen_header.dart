

import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderWidget extends StatelessWidget {
  BluetoothDevice? device;
  bool? enabled;
  final Function(bool) onToggleBtn;

  HeaderWidget({Key? key, this.device, required this.onToggleBtn, this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Brand.appPadding(context: context), ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                enabled ?? false
                    ? 'Thank you for enabling, now you can proceed'
                    : 'Please enable your bluetooth to use our app',
                style: GoogleFonts.poppins(
                  fontSize: Brand.textSize(context),
                  fontWeight: Brand.textWeight,
                  color: Brand.darkBlue,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                      enabled ?? false
                          ? 'Disable Bluetooth'
                          : 'Enable Bluetooth',
                      style: GoogleFonts.poppins(
                        fontSize: Brand.h4Size(context),
                        fontWeight: Brand.h4Weight,
                        color: Brand.blackGrey,
                      )),
                  value: enabled ?? false,
                  onChanged: onToggleBtn,
                ),
              ),
              Card(
                color: Brand.darkGreyBlue,
                elevation: 10,
                child: SizedBox(
                  //height: 100,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Brand.appPadding(context: context) * 0.5,
                        vertical: Brand.appPadding(context: context) * 0.5),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('My Device :',
                              style: GoogleFonts.poppins(
                                fontSize: Brand.h4Size(context),
                                fontWeight: Brand.h4Weight,
                                color: Colors.white,
                              )),
                          Text(device?.name??'UNKNOWN',
                              style: GoogleFonts.poppins(
                                fontSize: Brand.h4Size(context),
                                fontWeight: Brand.h4Weight,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      SizedBox(
                          height: Brand.appPadding(context: context) * 0.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Address :',
                              style: GoogleFonts.poppins(
                                fontSize: Brand.h4Size(context),
                                fontWeight: Brand.h4Weight,
                                color: Colors.white,
                              )),
                          Text(device?.address??"UNKNOWN",
                              style: GoogleFonts.poppins(
                                fontSize: Brand.h4Size(context),
                                fontWeight: Brand.h4Weight,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: Brand.appPadding(context: context) * 0.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Visible :',
                              style: GoogleFonts.poppins(
                                fontSize: Brand.h4Size(context),
                                fontWeight: Brand.h4Weight,
                                color: Colors.white,
                              )),
                          Text('${device?.isConnected??false}',
                              style: GoogleFonts.poppins(
                                fontSize: Brand.h4Size(context),
                                fontWeight: Brand.h4Weight,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}