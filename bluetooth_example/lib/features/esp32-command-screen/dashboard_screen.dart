import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/features/bluetooth_feature/bloototh_view_model.dart';
import 'package:bluetooth_example/features/esp32-command-screen/dashboard_view_model.dart';
import 'package:bluetooth_example/features/esp32-command-screen/page_scroll_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import 'dashboard_widgets/dashboard_widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final StreamSubscription<Uint8List>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _subscription = context
            .read<BluetoothViewModel>()
            .currentConnection
            ?.input
            ?.listen((event) {
          print(

              "this is the event coming from BLE ${String.fromCharCodes (event)}");
          context.read<DashboardViewModel>().readValue(valueReadFromBLE:event);
        });
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageScroll =
        context.select<PageScrollViewModel, double>((val) => val.scrollOffset);

    final device =
        ModalRoute.of(context)?.settings.arguments as BluetoothDevice;
    final deviceWidth = MediaQuery.of(context).size.width;
    final chartConfig = context
        .select<DashboardViewModel, ChartConfig>((value) => value.chartConfig);
    final temperatureVal = (context.select<DashboardViewModel, double>(
        (value) => value.currentTemperatureVal)) / 1.25;
    final humidityVal = (context.select<DashboardViewModel, double>(
            (value) => value.currentHumidityVal));
    final phVal =( context
        .select<DashboardViewModel, double>((value) => value.currentPhVal))/7.142;
    final DoVal = (context
        .select<DashboardViewModel, double>((value) => value.currentDOxyVal) ) / 2.25;
    final ECVal = (context
        .select<DashboardViewModel, double>((value) => value.currentEcVal)) / 10;
    final waterTemperatureVal = (context.select<DashboardViewModel, double>(
            (value) => value.currentWaterTempVal)) / 1.25 ;
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
                  /*  SizedBox(
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
                  ),*/
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
                          interval: chartConfig.temperatureInterval,
                          width: deviceWidth,
                          height: deviceWidth * 0.5,
                          title: 'Temp',
                          chartTitle: '${temperatureVal}°C',
                          chartValue: temperatureVal,
                          leadingIcon: FontAwesome.temperature_high,
                        ),
                        SizedBox(
                          height: deviceWidth * 0.05,
                        ),
                        RealTimeDataCard(
                          interval: chartConfig.humidityInterval,
                          width: deviceWidth,
                          height: deviceWidth * 0.5,
                          title: 'Hum',
                          chartTitle: '${humidityVal}%',
                          chartValue: humidityVal,
                          leadingIcon: FontAwesome.cloud_showers_water,
                        ),
                        SizedBox(
                          height: deviceWidth * 0.05,
                        ),
                        RealTimeDataCard(
                          interval: chartConfig.phInterval,
                          width: deviceWidth,
                          height: deviceWidth * 0.5,
                          title: 'PH',
                          chartTitle: '${phVal}',
                          chartValue: phVal,
                          leadingIcon: Icons.device_hub,
                        ),
                        SizedBox(
                          height: deviceWidth * 0.05,
                        ),
                        RealTimeDataCard(
                          interval: chartConfig.waterQualityInterval,
                          width: deviceWidth,
                          height: deviceWidth * 0.5,
                          title: 'EC',
                          chartTitle: '${ECVal} mS/cm',
                          chartValue: ECVal,
                          leadingIcon: Icons.flash_on,
                        ),
                        SizedBox(
                          height: deviceWidth * 0.05,
                        ),
                        RealTimeDataCard(
                          interval: chartConfig.oxygenConcentrationInterval,
                          width: deviceWidth,
                          height: deviceWidth * 0.5,
                          title: 'DO',
                          chartTitle: '${DoVal} mg/L',
                          chartValue: DoVal,
                          leadingIcon: Icons.waves,
                        ),
                        SizedBox(
                          height: deviceWidth * 0.05,
                        ),
                        RealTimeDataCard(
                          interval: chartConfig.waterTemperatureInterval,
                          width: deviceWidth,
                          height: deviceWidth * 0.5,
                          title: 'Water',
                          chartTitle: '${waterTemperatureVal}°C',
                          chartValue: waterTemperatureVal,
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
