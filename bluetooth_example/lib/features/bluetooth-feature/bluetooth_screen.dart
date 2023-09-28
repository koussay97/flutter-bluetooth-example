import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/core/routing/pop_screen_util.dart';
import 'package:bluetooth_example/features/bluetooth-feature/bloototh_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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
          child: Consumer<BluetoothViewModel>(
            builder: (BuildContext context, BluetoothViewModel instance,
                Widget? child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HeaderWidget(
                    device: instance.currentDevice,
                    onToggleBtn: (val) async {
                      await instance.tryEnableBluetooth().then((value) {
                        if (instance.currentState ==
                                CustomBluetoothState.initial ||
                            instance.currentState ==
                                CustomBluetoothState.intermediate1) {
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
                      });
                    },
                    enabled: instance.toggleValue,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Brand.appPadding(context: context)),
                    child: const Divider(height: 2),
                  ),
                ],
              );
            },
            //child: ,
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
class HeaderWidget extends StatelessWidget {
  DeviceDataDto? device;
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
              horizontal: Brand.appPadding(context: context)),
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
                          Text(device!.name,
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
                          Text(device!.address,
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
                          Text('${device!.isDiscoverable}',
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
