import 'dart:typed_data';

import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/features/bluetooth_feature/bloototh_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BottomCommunicationWidget extends StatelessWidget {
  const BottomCommunicationWidget({
    Key? key,
    required this.deviceWidth,
  }) : super(key: key);

  final double deviceWidth;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          showModalBottomSheet(
              constraints: BoxConstraints(
                  minWidth: deviceWidth,
                  minHeight: deviceWidth * 0.1,
                  maxWidth: deviceWidth,
                  maxHeight: deviceWidth),
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
                        height: deviceWidth * 0.1,
                      ),
                      StreamBuilder<Uint8List>(
                          stream: context
                              .read<BluetoothViewModel>()
                              .currentConnection
                              ?.input,
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
                          }),
                      SizedBox(
                        height: deviceWidth * 0.2,
                      ),
                      Row(children: [
                        InkWell(
                          onTap: () {
                            context
                                .read<BluetoothViewModel>()
                                .currentConnection
                                ?.output
                                .add(Uint8List.fromList('LED/1'.codeUnits));
                          },
                          child: Container(
                            color: Colors.grey,
                            height: deviceWidth * .1,
                            width: deviceWidth * 0.1,
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
                          width: deviceWidth * 0.1,
                        ),
                        InkWell(
                          onTap: () {
                            context
                                .read<BluetoothViewModel>()
                                .currentConnection
                                ?.output
                                .add(Uint8List.fromList('LED/0'.codeUnits));
                          },
                          child: Container(
                            width: deviceWidth * 0.1,
                            color: Colors.grey,
                            height: deviceWidth * .1,
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
          height: deviceWidth * 0.1,
          width: deviceWidth,
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
