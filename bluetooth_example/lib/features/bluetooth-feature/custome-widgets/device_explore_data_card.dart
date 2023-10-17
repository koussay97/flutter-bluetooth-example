


import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';

class DeviceExploreDataCard extends StatelessWidget {
  final int type;
  final double height;
  final BluetoothDiscoveryResult device;
  const DeviceExploreDataCard({Key? key,required this.type,required this.device, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Brand.appPadding(context: context)*0.5,
        vertical: Brand.appPadding(context: context)*0.1,
      ),
      height: height,
      width: double.infinity,

      decoration: BoxDecoration(
        color: type==0?Brand.darkBlue:Brand.paleGreyBlue,
        borderRadius: BorderRadius.circular(Brand.appPadding(context: context)*0.5),

      ),
      child: type==0?Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ExploreCardContent(blocWidth: height*1.5,data: device.device.name,title: 'NAME'),
            const VerticalDivider(color: Colors.white,width: 0,thickness: 1.0,),
            ExploreCardContent(blocWidth: height*1.5,data: device.device.address,title: 'ADDRESS'),
            const VerticalDivider(color: Colors.white,width: 0,thickness: 1.0,),
            ExploreCardContent(blocWidth: height*0.5,data: device.rssi.toString(),title: 'SIG'),

          ]):
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ExploreCardContent(blocWidth: height*1,data: device.device.bondState.stringValue,title: 'STATE'),
          const VerticalDivider(color: Colors.white,width: 0,thickness: 1.0,),
          ExploreCardContent(blocWidth: height*1.5,data: device.device.isConnected.toString(),title: 'CONNECTED'),
          const VerticalDivider(color: Colors.white,width: 0,thickness: 1.0,),
          ExploreCardContent(blocWidth: height*1,data: device.device.type.stringValue,title: 'TYPE'),

        ],)
      ,
    );
  }
}

class ExploreCardContent extends StatelessWidget {
  final String title;
  final String? data;
  final double blocWidth;
  const ExploreCardContent({Key? key,required this.blocWidth, required this.data, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: blocWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.fade,
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: Brand.h3Size(context),
                fontWeight: Brand.h1Weight,
              ),
            ),
          ),
          Expanded(
            child:Text(
              '$data',
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.fade,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: Brand.textSize(context)*0.8,
                fontWeight: Brand.h3Weight,
              ),
            ),
          ),

        ],
      ),
    );
  }
}