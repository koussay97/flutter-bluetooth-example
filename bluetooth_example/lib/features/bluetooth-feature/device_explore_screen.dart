import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/core/routing/pop_screen_util.dart';
import 'package:bluetooth_example/core/routing/route_names.dart';
import 'package:bluetooth_example/features/bluetooth-feature/bloototh_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import 'custome-widgets/bluetooth_widgets.dart';

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
              DeviceExploreDataCard(
                  device: device, height: deviceWidth * 0.2, type: 0),
              SizedBox(
                height: deviceWidth * 0.1,
              ),
              DeviceExploreDataCard(
                  device: device, height: deviceWidth * 0.2, type: 1),
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
              //Spacer(),
              SizedBox(
                height: deviceWidth * 0.25,
              ),
              Center(
                  child: ActionButton(
                      onTap: () {
                        if(device.device.isBonded){
                          context.read<BluetoothViewModel>().connectDevice(deviceAddress: device.device.address).then((value) {
                            value.fold((l) {
                              showPopup(
                                  context: context,
                                  title: 'Failed to Connect',
                                  ctaWidget: MaterialButton(
                                      color: Brand.darkTeal,
                                    padding: EdgeInsets.all(Brand.appPadding(context: context)*0.5),
                                      child: Text('Close', style: GoogleFonts.poppins(
                                        fontSize: Brand.h3Size(context),
                                        fontWeight: Brand.h3Weight,
                                        color: Colors.white,
                                      ),),
                                      onPressed: (){Navigator.pop(context);}),
                                  centerIcon: const Icon(BoxIcons.bx_bluetooth,color: Brand.darkTeal,),
                                  innerPadding: Brand.appPadding(context: context)*0.5,
                                  text: 'your attempt to connect to device : ${device.device.name} failed, please try again');
                             // Navigator.pushNamed(context, RouteAccessors.dashboardName,arguments: device.device);
                            }, (r) {
                              Navigator.pushNamed(context, RouteAccessors.dashboardName,arguments: device.device);
                            });
                          });
                        }else{
                          context.read<BluetoothViewModel>().pairDevice(deviceAddress: device.device.address).then((value) {

                            value.fold((l) {
                              showPopup(
                                  context: context,
                                  title: 'Pairing failed',
                                  ctaWidget: MaterialButton(
                                      color: Brand.darkTeal,
                                      padding: EdgeInsets.all(Brand.appPadding(context: context)),
                                      child: Text('Close', style: GoogleFonts.poppins(
                                        fontSize: Brand.h3Size(context),
                                        fontWeight: Brand.h3Weight,
                                        color: Colors.white,
                                      ),),
                                      onPressed: (){Navigator.pop(context);}),
                                  centerIcon: const Icon(BoxIcons.bx_bluetooth,color: Brand.darkTeal,),
                                  innerPadding: Brand.appPadding(context: context)*0.5,
                                  text: 'your attempt to pair with device : ${device.device.name} failed, please try again');

                            }, (r) {
                              showPopup(
                                  context: context,
                                  title: 'Pairing is Successful',
                                  ctaWidget: MaterialButton(
                                    color: Brand.darkTeal,
                                      padding: EdgeInsets.all(Brand.appPadding(context: context)),
                                      child: Text('Close', style: GoogleFonts.poppins(
                                        fontSize: Brand.h3Size(context),
                                        fontWeight: Brand.h3Weight,
                                        color: Colors.white,
                                      ),),
                                      onPressed: (){Navigator.pop(context);}),
                                  centerIcon: const Icon(BoxIcons.bx_bluetooth,color: Brand.darkTeal,),
                                  innerPadding: Brand.appPadding(context: context)*0.5,
                                  text: 'your are now paired to device : ${device.device.name} ');
                            });
                          });
                        }

                      }, isConnectable: device.device.isBonded)),
              SizedBox(
                height: deviceWidth * 0.05,
              ),
              Center(
                child: Text(
                  'This device is currently ${device.device.bondState.stringValue}',
                  style: GoogleFonts.poppins(
                    color: Brand.blackGrey,
                    fontSize: Brand.textSize(context),
                    fontWeight: Brand.textWeight,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isConnectable;

  const ActionButton(
      {Key? key, required this.onTap, required this.isConnectable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return MaterialButton(
        color: isConnectable ? Brand.darkTeal : Brand.darkGreyBlue,
        elevation: 0,
        minWidth: deviceWidth,
        padding: EdgeInsets.symmetric(
          vertical: Brand.appPadding(context: context) * 0.5,
        ),
        onPressed: onTap,
        child: Text(
          isConnectable ? 'Connect' : 'Pair',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: Brand.h3Size(context),
            fontWeight: Brand.h3Weight,
          ),
        ));
  }
}
