import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';

import 'package:bluetooth_example/features/bluetooth_feature/bloototh_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BluetoothStateEmptyScreen extends StatelessWidget {
  final SystemState state;
  final double cardWidth;
  final double cardHeight;

  const BluetoothStateEmptyScreen(
      {Key? key,
      required this.state,
      required this.cardHeight,
      required this.cardWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Brand.appPadding(context: context) * 0.5),
      child: Container(
        height: cardHeight,
        width: cardWidth,
        padding: EdgeInsets.symmetric(
            vertical: Brand.appPadding(context: context) * 0.5,
            horizontal: Brand.appPadding(context: context) * 0.5),
        decoration: BoxDecoration(
          boxShadow: [Brand.cardShadow],
          borderRadius: BorderRadius.circular(cardWidth * 0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            getCorrespondingIcon(state: state, size: cardWidth * 0.1),
            Expanded(
              child: Text(
                getCorrespondingTitle(state: state),
                style: GoogleFonts.poppins(
                  color: Brand.blackGrey,
                  fontSize: Brand.h2Size(context),
                  fontWeight: Brand.h2Weight,
                ),
              ),
            ),
            Expanded(
                child: Text(
              getCorrespondingDetails(state: state),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: Brand.textSize(context),
                fontWeight: Brand.h4Weight,
              ),
            )),
          ],
        ),
      ),
    );
  }
}

Widget getCorrespondingIcon(
    {required SystemState state, required double size}) {
  switch (state) {
    case SystemState.initial || SystemState.intermediate1:
      return Icon(
        Icons.bluetooth_connected_rounded,
        color: Brand.lightGrey,
        size: size,
      );
    case SystemState.secondState:
      return Icon(
        Icons.bluetooth_audio_outlined,
        color: Brand.paleGreyBlue,
        size: size,
      );
    case SystemState.intermediate2:
      return Icon(
        Icons.bluetooth_disabled_sharp,
        color: Colors.redAccent,
        size: size,
      );
    default:
      return Icon(
        Icons.important_devices,
        color: Brand.brightGreyBlue,
        size: size,
      );
  }
}

String getCorrespondingTitle({required SystemState state}) {
  switch (state) {
    case SystemState.initial || SystemState.intermediate1:
      return 'Bluetooth is Off';
    case SystemState.secondState:
      return 'Ready to Start Scanning';
    case SystemState.intermediate2:
      return 'Your Scan Failed';
    default:
      return 'No Devices Found';
  }
}

String getCorrespondingDetails({required SystemState state}) {
  switch (state) {
    case SystemState.initial || SystemState.intermediate1:
      return 'Your bluetooth is currently off, you need to turn it on to start scanning for devices,';
    case SystemState.secondState:
      return 'Click the start discovery button to scan for devices';
    case SystemState.intermediate2:
      return 'Something went wrong while scanning, can you turn off bluetooth and try again';
    default:
      return 'There are no nearby devices available, make sure to get close enough';
  }
}
