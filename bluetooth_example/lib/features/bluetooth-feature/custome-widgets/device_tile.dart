import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';

class DeviceCard extends StatelessWidget {
  final double height;
  final double width;
  final bool isCardSelected;
  final BluetoothDiscoveryResult device;
  final VoidCallback onTappedView;
  final VoidCallback onTappedExplore;
  final VoidCallback onTappedConnect;

  const DeviceCard(
      {Key? key,
      required this.onTappedExplore,
      required this.isCardSelected,
      required this.onTappedConnect,
      required this.onTappedView,
      required this.width,
      required this.height,
      required this.device})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      fit: StackFit.passthrough,
      children: [
        InkWell(
          radius: Brand.appPadding(context: context) * 0.3,
          onTap: onTappedView,
          child: AnimatedContainer(
            curve: Curves.elasticInOut,
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Brand.paleGreyBlue.withOpacity(0.3),
                      offset: Offset.zero,
                      spreadRadius: 5,
                      blurRadius: 5)
                ],
                borderRadius: BorderRadius.circular(
                    Brand.appPadding(context: context) * 0.3)),
            margin: EdgeInsets.only(
                bottom: Brand.appPadding(context: context) * 0.5),
            padding: EdgeInsets.symmetric(
                vertical: Brand.appPadding(context: context) * 0.5,
                horizontal: Brand.appPadding(context: context) * 0.5),
            width: width,
            height: isCardSelected ? height * 2 : height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: height * 0.4,
                  width: height * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(height),
                      boxShadow: [
                        BoxShadow(
                          color: Brand.paleGreyBlue.withOpacity(0.5),
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: Offset.zero,
                        )
                      ]),
                  child: LeadingIcon(
                      type: device.device.type,
                      iconColor: Brand.darkTeal,
                      iconSize: height * 0.2),
                ),
                //Container(),
                SizedBox(
                  width: height * 0.1,
                  child: const VerticalDivider(
                      color: Brand.darkGreyBlue, width: 1),
                ),
                SizedBox(
                  width: width * 0.4,
                  height: isCardSelected ? height * 2 : height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      DeviceDataTitle(
                          expands: isCardSelected,
                          prefix: 'name: ',
                          data: device.device.name ?? 'Unknown'),
                      //Spacer(flex: 0),
                      DeviceDataTitle(
                          expands: isCardSelected,
                          prefix: 'address: ',
                          data: device.device.address),
                      //Spacer(flex: 2),
                      Flexible(
                        fit: FlexFit.loose,
                        flex: isCardSelected ? 1 : 0,
                        child: Visibility(
                            visible: isCardSelected,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                /// here we check if the device is already bounded or not
                                /// if bounded we show disconnect btn
                                /// else we show connect btn
                                TileButton(
                                    connectType: device.device.isBonded ? 1 : 0,
                                    onTap: onTappedConnect,
                                    size: height * 0.2),
                                /// the index 2 by default would show the explore btn
                                TileButton(
                                    connectType: 2,
                                    onTap: onTappedExplore,
                                    size: height * 0.2),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          //width * 0.1 - (Brand.appPadding(context: context) * 0.6),
          right: 0,
          child: Container(
            alignment: Alignment.center,
            height: width * 0.08,
            width: width * 0.08,
            decoration: BoxDecoration(
              color: device.device.isBonded
                  ? Brand.brightTeal
                  : Brand.brightGreyBlue,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                      Brand.appPadding(context: context) * 0.5 -
                          Brand.appPadding(context: context) * 0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DeviceDataTitle(
                    prefix: '',
                    data: device.device.isConnected ? 'ON' : 'OFF',
                    expands: true),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: width * 0.08 - (Brand.appPadding(context: context) * 0.6),
          right: 0,
          child: Container(
            alignment: Alignment.center,
            height: width * 0.08,
            width: width * 0.08,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.only(
                  bottomRight:
                      Radius.circular(Brand.appPadding(context: context) / 2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DeviceDataTitle(
                    prefix: '', data: device.rssi.toString(), expands: true),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class TileButton extends StatelessWidget {
  final int connectType;
  final double size;
  final VoidCallback onTap;

  const TileButton(
      {Key? key,
      required this.size,
      required this.connectType,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Brand.paleGreyBlue, borderRadius: BorderRadius.circular(30)),
        child: btnType(size: size, btnType: connectType),
      ),
    );
  }
}

Widget btnType({required int btnType, required double size}) {
  switch (btnType) {
    case 0:
      return Icon(
        Icons.bluetooth_connected_rounded,
        color: Colors.white,
        size: size,
      );
    case 1:
      return Icon(Icons.bluetooth_disabled_outlined,
          color: Colors.white, size: size);
    default:
      return Icon(Icons.remove_red_eye, color: Colors.white, size: size);
  }
}

// in use
class DeviceDataTitle extends StatelessWidget {
  final String prefix;
  final String data;
  bool expands;

  DeviceDataTitle(
      {Key? key,
      required this.expands,
      required this.prefix,
      required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      //flex: expands?0:1,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: data,
                style: GoogleFonts.poppins(
                    fontWeight: Brand.h3Weight,
                    color: Brand.darkGreyBlue,
                    fontSize: Brand.textSize(context))),
          ],
          text: prefix,
          style: GoogleFonts.poppins(
              fontWeight: Brand.h3Weight,
              color: Brand.blackGrey,
              fontSize: Brand.textSize(context)),
        ),
        overflow: TextOverflow.fade,
        softWrap: expands,
        textScaleFactor: 1,
        maxLines: expands ? 4 : 1,
        textAlign: TextAlign.start,
      ),
    );
  }
}

// in use
class LeadingIcon extends StatelessWidget {
  final double iconSize;
  final Color iconColor;
  final BluetoothDeviceType type;

  const LeadingIcon(
      {Key? key,
      required this.iconSize,
      required this.type,
      required this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case BluetoothDeviceType.dual:
        return Center(
            child: Icon(
          Icons.devices_other,
          color: iconColor,
          size: iconSize,
        ));
      case BluetoothDeviceType.le:
        return Center(
            child: Icon(
          Icons.developer_board,
          color: iconColor,
          size: iconSize,
        ));
      case BluetoothDeviceType.le:
        return Center(
            child: Icon(
              Icons.media_bluetooth_on_outlined,
              color: iconColor,
              size: iconSize,
            ));
      default:
        return Center(
            child: Icon(
          Icons.device_unknown,
          color: iconColor,
          size: iconSize,
        ));
    }
  }
}
