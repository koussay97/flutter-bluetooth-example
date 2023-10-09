import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';

class DeviceExploreScreen extends StatelessWidget {
  const DeviceExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final device =
        ModalRoute.of(context)?.settings.arguments as BluetoothDiscoveryResult;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Brand.darkGreyBlue,
        centerTitle: true,
        actionsIconTheme: const IconThemeData(color: Colors.white),
        primary: true,
        title: Text(
          'welcome to ${device.device.name}',
          style: GoogleFonts.poppins(
            fontSize: Brand.h2Size(context),
            fontWeight: Brand.h2Weight,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Brand.appPadding(context: context),
              vertical: Brand.appPadding(context: context)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This device is within your reach :',
                style: GoogleFonts.poppins(
                  color: Brand.darkBlue,
                  fontSize: Brand.h3Size(context),
                  fontWeight: Brand.h3Weight,
                ),
              ),
              SizedBox(
                height: deviceWidth * 0.05,
              ),
              Text(
                'From this panel, you van view the device interface and connect to it or disconnect.'
                    ' This screen is intended to give you more in-depth insight about each scanned device.',
                style: GoogleFonts.poppins(
                  color: Brand.lightGrey,
                  fontSize: Brand.textSize(context),
                  fontWeight: Brand.textWeight,
                ),
              ),
              SizedBox(
                height: deviceWidth * 0.1,
              ),
              DeviceExploreDataCard(device: device,height: deviceWidth * 0.2,type: 0),
              SizedBox(
                height: deviceWidth * 0.1,
              ),
              DeviceExploreDataCard(device: device,height: deviceWidth * 0.2,type: 1),
              SizedBox(
                height: deviceWidth * 0.1,
              ),
              Text(
                    'Click the Button to attempt connection or bound the two devices ',
                style: GoogleFonts.poppins(
                  color: Brand.blackGrey,
                  fontSize: Brand.textSize(context),
                  fontWeight: Brand.textWeight,
                ),
              ),
              SizedBox(
                height: deviceWidth * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    shape: BeveledRectangleBorder(
                        //side: BorderSide.merge(Border.symmetric(), b),
                        borderRadius: BorderRadius.circular(2)),
                    color: Brand.darkTeal,
                      child: Text('Connect',  style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: Brand.h3Size(context),
                        fontWeight: Brand.h3Weight,
                      ),),
                      onPressed: (){}),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
            ExploreCardContent(data: device.device.name,title: 'NAME'),
            const VerticalDivider(color: Colors.white,width: 0,thickness: 1.0,),
            ExploreCardContent(data: device.device.address,title: 'ADDRESS'),
            const VerticalDivider(color: Colors.white,width: 0,thickness: 1.0,),
            ExploreCardContent(data: device.rssi.toString(),title: 'SIGNAL'),

          ]):
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ExploreCardContent(data: device.device.bondState.stringValue,title: 'STATE'),
          const VerticalDivider(color: Colors.white,width: 0,thickness: 1.0,),
          ExploreCardContent(data: device.device.isConnected.toString(),title: 'CONNECTED'),
          const VerticalDivider(color: Colors.white,width: 0,thickness: 1.0,),
          ExploreCardContent(data: device.device.type.stringValue,title: 'TYPE'),

        ],)
      ,
    );
  }
}
class ExploreCardContent extends StatelessWidget {
  final String title;
  final String? data;
  const ExploreCardContent({Key? key, required this.data, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: Brand.h3Size(context),
            fontWeight: Brand.h1Weight,
          ),
        ),
        Text(
          '$data',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: Brand.textSize(context),
            fontWeight: Brand.h3Weight,
          ),
        ),
      ],
    );
  }
}
