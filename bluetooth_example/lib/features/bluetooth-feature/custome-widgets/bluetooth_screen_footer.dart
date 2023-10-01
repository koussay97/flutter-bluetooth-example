import 'dart:async';

import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/core/routing/route_names.dart';
import 'package:bluetooth_example/features/bluetooth-feature/bloototh_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FooterWidget extends StatefulWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  late final StreamSubscription<BluetoothDiscoveryResult> fakeSubscription;

  List<BluetoothDiscoveryResult> listOfDevices =
      List<BluetoothDiscoveryResult>.empty(growable: true);

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fakeSubscription =
          context.read<BluetoothViewModel>().devicesStream().listen(
        (event) {
          setState(() {
            final existingIndex = listOfDevices.indexWhere(
                (element) => element.device.address == event.device.address);
            if (existingIndex >= 0) {
              listOfDevices[existingIndex] = event;
            } else {
              listOfDevices.add(event);
            }
          });
        },
        onError: (e) {
          print(e);
          //fakeSubscription.cancel.call();
        },
            onDone: (){},
        //onDone: ,
        cancelOnError: true,
      );
    });
  }

  @override
  void dispose() {
    fakeSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(

        itemCount: listOfDevices.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          // if(index==null){return Container(color: Colors.red,height: 20,width: 20,);}
          return BluetoothDeviceTile(
            onTap: () {
              Navigator.pushNamed(context, RouteAccessors.dashboardName,
                  arguments: listOfDevices[index]);
            },
            blDevice: listOfDevices[index],
            onDismiss: (a) {
              listOfDevices.removeWhere((element) =>
                  element.device.address ==
                  listOfDevices[index].device.address);
            },
          );
        });
  }
}

class BluetoothDeviceTile extends StatelessWidget {
  final BluetoothDiscoveryResult blDevice;
  final Function(DismissDirection) onDismiss;
  final VoidCallback onTap;

  const BluetoothDeviceTile(
      {Key? key,
      required this.onTap,
      required this.onDismiss,
      required this.blDevice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Brand.appPadding(context: context) * 0.5),
      child: Card(
        color: Colors.white,
        surfaceTintColor: Brand.darkBlue,
        shadowColor: Brand.darkBlue,
        elevation: 1,
        child: Dismissible(
          key: UniqueKey(),
          onDismissed: onDismiss,
          direction: DismissDirection.horizontal,
          dragStartBehavior: DragStartBehavior.start,
          child: ListTile(
            onTap: onTap,
            titleAlignment: ListTileTitleAlignment.titleHeight,
            iconColor: Brand.brightTeal,
            enabled: true,
            horizontalTitleGap: Brand.appPadding(context: context) / 2,
            isThreeLine: true,
            selected: false,
            subtitle: Text(blDevice.device.address,
                style: GoogleFonts.poppins(
                  fontSize: Brand.h3Size(context),
                  color: Brand.blackGrey,
                  fontWeight: Brand.h2Weight,
                )),
            contentPadding: EdgeInsets.symmetric(
                horizontal: Brand.appPadding(context: context) / 2,
                vertical: Brand.appPadding(context: context) / 2),
            trailing: Text('signal: ${blDevice.rssi}',
                style: GoogleFonts.poppins(
                  fontSize: Brand.textSize(context) * 0.8,
                  color: Brand.darkBlue,
                  fontWeight: Brand.h3Weight,
                )),
            title: Text('${blDevice.device.name}',
                style: GoogleFonts.poppins(
                    fontWeight: Brand.h3Weight,
                    color: Brand.darkBlue,
                    fontSize: Brand.h3Size(context))),
            leading: blDevice.device.type == BluetoothDeviceType.dual
                ? const LeadingTileIcon(
                    size: 30,
                    icon: Icon(
                      Icons.device_unknown,
                    ),
                  )
                : const LeadingTileIcon(size: 30, icon: Icon(Icons.device_hub)),
          ),
        ),
      ),
    );
  }
}

class LeadingTileIcon extends StatelessWidget {
  final double size;
  final Icon icon;

  const LeadingTileIcon({Key? key, required this.size, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: size,
      width: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: Colors.black,
          ),
          boxShadow: const [
            BoxShadow(
                color: Colors.white10,
                spreadRadius: 20,
                blurRadius: 20,
                offset: Offset.zero)
          ]),
      child: icon,
    );
  }
}
