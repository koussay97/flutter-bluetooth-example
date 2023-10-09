

import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/features/bluetooth-feature/bloototh_view_model.dart';
import 'package:bluetooth_example/features/bluetooth-feature/custome-widgets/bluetooth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class HeaderWidget extends StatelessWidget {
  /*BluetoothDevice? device;
  bool? enabled;
  final Function(bool) onToggleBtn;*/

  HeaderWidget({Key? key, /*this.device, required this.onToggleBtn, this.enabled*/})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BluetoothDevice device = context.select<BluetoothViewModel,BluetoothDevice>((value) => value.currentDevice,);
    final bool enabled = context.select<BluetoothViewModel,bool>((value) => value.enableBluetooth,);
    final double deviceWidth= MediaQuery.of(context).size.width;
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
                  onChanged: (val){
                    context.read<BluetoothViewModel>().toggleBtn().then((value) {
                      value.fold((l) {
                        requestPermission(context: context,deviceWidth: deviceWidth);
                      }, (r) => null);

                    });
                  },
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
                          
                          Expanded(
                            child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textWidthBasis: TextWidthBasis.longestLine,
                                softWrap: false,
                                device.name??'UNKNOWN',
                                style: GoogleFonts.poppins(
                                  fontSize: Brand.h4Size(context),
                                  fontWeight: Brand.h4Weight,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: Brand.appPadding(context: context) * 0.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Address :',
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              textWidthBasis: TextWidthBasis.parent,
                              style: GoogleFonts.poppins(
                                fontSize: Brand.h4Size(context),
                                fontWeight: Brand.h4Weight,
                                color: Colors.white,
                              )),
                          Expanded(
                            child: Text(device.address,

                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textWidthBasis: TextWidthBasis.longestLine,
                                softWrap: true,
                                style: GoogleFonts.poppins(
                                  fontSize: Brand.h4Size(context),
                                  fontWeight: Brand.h4Weight,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Brand.appPadding(context: context) * 0.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('is Paired :',
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              textWidthBasis: TextWidthBasis.longestLine,
                              style: GoogleFonts.poppins(
                                fontSize: Brand.h4Size(context),
                                fontWeight: Brand.h4Weight,
                                color: Colors.white,
                              )),
                          Text('${device.isConnected??false}',
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
                      const StartDiscoveryBtn(),
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