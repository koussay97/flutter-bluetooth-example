import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/features/bluetooth_feature/bloototh_view_model.dart';
import 'package:bluetooth_example/features/esp32-command-screen/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BottomCommunicationWidget extends StatefulWidget {
  const BottomCommunicationWidget({
    Key? key,
    required this.deviceWidth,
  }) : super(key: key);

  final double deviceWidth;

  @override
  State<BottomCommunicationWidget> createState() =>
      _BottomCommunicationWidgetState();
}

class _BottomCommunicationWidgetState extends State<BottomCommunicationWidget> {
  late StreamSubscription<Uint8List>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _subscription = context
            .read<BluetoothViewModel>()
            .currentConnection
            ?.input
            ?.asBroadcastStream()
            .listen((event) {
          context.read<DashboardViewModel>().readValue(valueReadFromBLE: event);
        });
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }

  /* String readMessage = "";
   Color messageColor=Colors.black;
   getReadMessage(){

    return _subscription?.onData((data) {
      setState(() {
        re
      });
    });


  }*/

  @override
  Widget build(BuildContext context) {
    final valueRead =
        context.select<DashboardViewModel, double>((val) => val.currentAction1);

    return InkWell(
        onTap: () {
          showModalBottomSheet(
              constraints: BoxConstraints(
                  minWidth: widget.deviceWidth,
                  minHeight: widget.deviceWidth * 0.1,
                  maxWidth: widget.deviceWidth,
                  maxHeight: widget.deviceWidth),
              context: context,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.all(Brand.appPadding(context: context)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'click the button to turn on led',
                        style: GoogleFonts.poppins(
                          color: Brand.blackGrey,
                          fontSize: Brand.h3Size(context),
                          fontWeight: Brand.h3Weight,
                        ),
                      ),
                      SizedBox(
                        height: widget.deviceWidth * 0.1,
                      ),

                      /*StreamBuilder<Uint8List>(
                          stream: context
                              .read<BluetoothViewModel>()
                              .currentConnection
                              ?.input
                              ?.asBroadcastStream(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                  'value from BLE : ${String.fromCharCodes(snapshot.data ?? [
                                        97,
                                        99
                                      ])}',
                                  style: GoogleFonts.poppins(
                                    color: Brand.darkTeal,
                                    fontSize: Brand.h4Size(context),
                                    fontWeight: Brand.h4Weight,
                                  ));
                            }
                            if (snapshot.hasError) {
                              return Text(
                                'An error occurred : ',
                                style: GoogleFonts.poppins(
                                  color: Colors.redAccent,
                                  fontSize: Brand.h4Size(context),
                                  fontWeight: Brand.h4Weight,
                                ),
                              );
                            }
                            return Text(
                              'click to toggle LED',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: Brand.h2Size(context),
                                fontWeight: Brand.h2Weight,
                              ),
                            );
                          }),*/
                      Text(
                        valueRead >= 9999
                            ? 'no available data'
                            : " action read1: $valueRead",
                        style: GoogleFonts.poppins(
                          color: valueRead >= 9999 ? Colors.blue : Colors.black,
                          fontSize: Brand.h2Size(context),
                          fontWeight: Brand.h2Weight,
                        ),
                      ),
                      SizedBox(
                        height: widget.deviceWidth * 0.2,
                      ),
                      Row(children: [
                        InkWell(
                          onTap: () {
                            context
                                .read<BluetoothViewModel>()
                                .currentConnection
                                ?.output
                                .add(Uint8List.fromList('Led:1'.codeUnits));
                          },
                          child: Container(
                            color: Colors.grey,
                            height: widget.deviceWidth * .1,
                            width: widget.deviceWidth * 0.1,
                            child: Center(
                                child: Text(
                              'On',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: Brand.h2Size(context),
                                fontWeight: Brand.h2Weight,
                              ),
                            )),
                          ),
                        ),
                        SizedBox(
                          width: widget.deviceWidth * 0.1,
                        ),
                        InkWell(
                          onTap: () {
                            context
                                .read<BluetoothViewModel>()
                                .currentConnection
                                ?.output
                                .add(Uint8List.fromList('Led:0'.codeUnits));
                          },
                          child: Container(
                            width: widget.deviceWidth * 0.1,
                            color: Colors.grey,
                            height: widget.deviceWidth * .1,
                            child: Center(
                              child: Text(
                                'Off',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: Brand.h2Size(context),
                                  fontWeight: Brand.h2Weight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                );
              });
        },
        child: Container(
          decoration: BoxDecoration(
              color: Brand.darkTeal,
              borderRadius: BorderRadius.only(
                  topRight:
                      Radius.circular(Brand.appPadding(context: context) * 4),
                  topLeft:
                      Radius.circular(Brand.appPadding(context: context) * 4))),
          height: widget.deviceWidth * 0.1,
          width: widget.deviceWidth,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.arrow_circle_up_outlined,
                  color: Colors.white,
                ),
                Text(
                  'Send Data',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: Brand.h4Size(context),
                      fontWeight: Brand.h4Weight),
                )
              ],
            ),
            /* AnimatedIcon(
           progress: Tween<double>(begin: 0.0,end :1.0).animate(),
           icon: AnimatedIcons.arrow_menu,
         ),
        */
          ),
        ));
  }
}
