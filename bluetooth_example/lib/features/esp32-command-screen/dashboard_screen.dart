import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/features/esp32-command-screen/page_scroll_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import 'dashboard_widgets/dashboard_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageScroll =
        context.select<PageScrollViewModel, double>((val) => val.scrollOffset);
    //print('scroll from provider ::: $pageScroll');
    final device =
        ModalRoute.of(context)?.settings.arguments as BluetoothDevice;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Brand.darkTeal,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            'welcome to ${device.name} dashboards',
            maxLines: 2,
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: Brand.h3Size(context),
                fontWeight: Brand.h3Weight),
          )),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dy < 0) {
                print('should scroll downwards ');
              }
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              clipBehavior: Clip.none,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: deviceWidth,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            child: Container(
                              //color: Colors.grey,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 400,
                                    width: deviceWidth,
                                    //color: Colors.redAccent,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment:
                                            Alignment((pageScroll) * 0.0005, 0),
                                        fit: BoxFit.cover,
                                        opacity: 0.9,
                                        image: const NetworkImage(
                                            'https://blog.veritable-potager.fr/wp-content/uploads/2017/04/culture-hydroponie-hors-sol-jardin-interieur.jpg'),
                                      ),
                                      //color: Colors.blue
                                    ),
                                    child: Container(
                                      height: 200,
                                      decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                            Colors.white,
                                            Colors.transparent
                                          ],
                                              stops: [
                                            0,
                                            0.6
                                          ])),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: deviceWidth * 0.06,
                            left: Brand.appPadding(context: context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Charts',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: Brand.h2Size(context),
                                      fontWeight: Brand.h1Weight),
                                ),
                                SizedBox(height: deviceWidth * 0.01),
                                Text(
                                  'Swipe or click to expand the chart panel',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: Brand.h4Size(context),
                                      fontWeight: Brand.h4Weight),
                                ),
                              ],
                            )),
                        Positioned(
                          right: 0,
                          top: deviceWidth * 0.25,
                          child: DataStream(
                            listHeight: deviceWidth * 0.95,
                            listWidth: deviceWidth,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Brand.appPadding(context: context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: deviceWidth * 0.2,
                        ),
                        const ChartConfigWidget(),
                        SizedBox(
                          height: deviceWidth * 0.1,
                        ),
                        Text(
                          'Real Time Data',
                          style: GoogleFonts.poppins(
                              color: Brand.blackGrey,
                              fontSize: Brand.h2Size(context),
                              fontWeight: Brand.h1Weight),
                        ),
                        SizedBox(height: deviceWidth * 0.02),
                        RealTimeDataCard(
                          width: deviceWidth,
                          height: deviceWidth * 0.2,
                          title: 'Temp',
                          chartTitle: '22°C',
                          chartValue: 66,
                          leadingIcon: FontAwesome.temperature_high,
                        ),
                        SizedBox(
                          height: deviceWidth * 0.05,
                        ),
                        RealTimeDataCard(
                          width: deviceWidth,
                          height: deviceWidth * 0.2,
                          title: 'Hum',
                          chartTitle: '20%',
                          chartValue: 20,
                          leadingIcon: FontAwesome.cloud_showers_water,
                        ),
                        SizedBox(
                          height: deviceWidth * 0.05,
                        ),
                        RealTimeDataCard(
                          width: deviceWidth,
                          height: deviceWidth * 0.2,
                          title: 'PH',
                          chartTitle: '7 ',
                          chartValue: 50,
                          leadingIcon: Icons.device_hub,
                        ),
                        SizedBox(
                          height: deviceWidth * 0.05,
                        ),
                        RealTimeDataCard(
                          width: deviceWidth,
                          height: deviceWidth * 0.2,
                          title: 'EC',
                          chartTitle: '10 mS/cm',
                          chartValue: 90,
                          leadingIcon: Icons.flash_on,
                        ),
                        SizedBox(
                          height: deviceWidth * 0.05,
                        ),
                        RealTimeDataCard(
                          width: deviceWidth,
                          height: deviceWidth * 0.2,
                          title: 'DO',
                          chartTitle: '8 ',
                          chartValue: 25,
                          leadingIcon: Icons.waves,
                        ),
                        SizedBox(
                          height: deviceWidth * 0.05,
                        ),
                        RealTimeDataCard(
                          width: deviceWidth,
                          height: deviceWidth * 0.2,
                          title: 'Water Temp',
                          chartTitle: '25°C',
                          chartValue: 80,
                          leadingIcon: Icons.thermostat,
                        ),
                        SizedBox(
                          height: deviceWidth * 0.2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              width: deviceWidth,
              child: BottomCommunicationWidget(deviceWidth: deviceWidth)),
        ],
      ),
    );
  }
}

// upper page view block
