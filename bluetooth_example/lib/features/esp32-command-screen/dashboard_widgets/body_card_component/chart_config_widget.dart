import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/features/esp32-command-screen/dashboard_view_model.dart';
import 'package:bluetooth_example/features/esp32-command-screen/dashboard_widgets/body_card_component/chart_config_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class ChartConfigWidget extends StatefulWidget {
  const ChartConfigWidget({super.key});

  @override
  State<ChartConfigWidget> createState() => _ChartConfigWidgetState();
}

class _ChartConfigWidgetState extends State<ChartConfigWidget>
    with SingleTickerProviderStateMixin {
  late bool isChartConfigOpen;
  late double currentScaleY;
  late AnimationController _controller;
  late Animation<double> expandAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    expandAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    isChartConfigOpen = false;
    currentScaleY = 0.5;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: isChartConfigOpen,
          child: ChartConfigForm(
              deviceWidth: deviceWidth, expandAnimation: expandAnimation),
        ),

        // config btn
        MaterialButton(
            height: deviceWidth * 0.05,
            padding: EdgeInsets.zero,
            minWidth: deviceWidth * 0.05,
            onPressed: () {
              setState(() {
                isChartConfigOpen = !isChartConfigOpen;
              });
              if (isChartConfigOpen) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
            child: Container(
              height: deviceWidth * 0.15,
              width: deviceWidth * 0.15,
              decoration: BoxDecoration(
                color: Brand.darkTeal,
                borderRadius: BorderRadius.circular(
                    Brand.appBorderRadius(context: context)),
              ),
              child: Center(
                child: Icon(FontAwesome.gear,
                    color: Colors.white, size: deviceWidth * 0.05),
              ),
            ))
      ],
    );
  }
}

class ChartConfigForm extends StatelessWidget {
  final Animation<double> expandAnimation;

  const ChartConfigForm({
    super.key,
    required this.expandAnimation,
    required this.deviceWidth,
  });

  final double deviceWidth;

  @override
  Widget build(BuildContext context) {
    final instance = context
        .select<DashboardViewModel, ChartConfig>((value) => value.chartConfig);
    return AnimatedBuilder(
        animation: expandAnimation,
        builder: (context, widget) {
          return Transform.scale(
            //scale: expandAnimation.value,
            origin: Offset.zero,
            scaleY: expandAnimation.value,
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.all(Brand.appPadding(context: context) * 0.5),
              decoration: BoxDecoration(
                boxShadow: [Brand.cardShadow],
                borderRadius: BorderRadius.circular(
                    Brand.appBorderRadius(context: context)),
                color: Colors.white,
              ),
              // height: deviceWidth * 0.8,
              width: deviceWidth * 0.6,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChartConfigContent(
                      changedIdealMax: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(maxIdealTemp: val));
                      },
                      changedIdealMin: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(minIdealTem: val));
                      },
                      changedMax: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(maxTemperature: val));
                      },
                      changedMin: (value) {},
                      deviceWidth: deviceWidth,
                      interval: instance.temperatureInterval,
                      valuesDisabled: const [true, false, false, false],
                      title: 'Temperature',
                    ),
                    SizedBox(
                      height: deviceWidth * 0.05,
                    ),
                    ChartConfigContent(
                      changedIdealMax: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(maxIdealHum: val));
                      },
                      changedIdealMin: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(minIdealHum: val));
                      },
                      changedMax: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(maxHumidity: val));
                      },
                      changedMin: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(minHumidity: val));
                      },
                      deviceWidth: deviceWidth,
                      interval: instance.humidityInterval,
                      valuesDisabled: const [false, false, false, false],
                      title: 'Humidity',
                    ),
                    SizedBox(
                      height: deviceWidth * 0.05,
                    ),
                    ChartConfigContent(
                      changedIdealMax: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(maxIdealPh: val));
                      },
                      changedIdealMin: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(minIdealPh: val));
                      },
                      changedMax: (value) {},
                      changedMin: (value) {},
                      deviceWidth: deviceWidth,
                      interval: instance.phInterval,
                      valuesDisabled: const [true, false, false, true],
                      title: 'PH',
                    ),
                    SizedBox(
                      height: deviceWidth * 0.05,
                    ),
                    ChartConfigContent(
                      changedIdealMax: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(maxIdealEc: val));
                      },
                      changedIdealMin: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(minIdealEc: val));
                      },
                      changedMax: (value) {},
                      changedMin: (value) {},
                      deviceWidth: deviceWidth,
                      interval: instance.waterQualityInterval,
                      valuesDisabled: const [true, false, false, true],
                      title: 'EC',
                    ),
                    SizedBox(
                      height: deviceWidth * 0.05,
                    ),
                    ChartConfigContent(
                      changedIdealMax: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(maxIdealOxy: val));
                      },
                      changedIdealMin: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(minIdealOxy: val));
                      },
                      changedMax: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(maxOxy: val));
                      },
                      changedMin: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(minOxy: val));
                      },
                      deviceWidth: deviceWidth,
                      interval: instance.oxygenConcentrationInterval,
                      valuesDisabled: const [false, false, false, false],
                      title: 'DO',
                    ),
                    SizedBox(
                      height: deviceWidth * 0.05,
                    ),
                    ChartConfigContent(
                      changedIdealMax: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(maxIdealWaterTemp: val));
                      },
                      changedIdealMin: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config: instance.copyWith(minIdealWaterTem: val));
                      },
                      changedMax: (value) {
                        final val = num.parse(value).toDouble();
                        context.read<DashboardViewModel>().changeConfig(
                            config:
                                instance.copyWith(maxWaterTemperature: val));
                      },
                      changedMin: (value) {},
                      deviceWidth: deviceWidth,
                      interval: instance.waterTemperatureInterval,
                      valuesDisabled: const [true, false, false, false],
                      title: 'Water Temperature',
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class ChartConfigContent extends StatelessWidget {
  final String title;
  final double deviceWidth;
  final List<double> interval;
  final List<bool> valuesDisabled;
  final Function(String) changedMin;
  final Function(String) changedMax;
  final Function(String) changedIdealMax;
  final Function(String) changedIdealMin;

  const ChartConfigContent(
      {super.key,
      required this.deviceWidth,
      required this.interval,
      required this.title,
      required this.changedMax,
      required this.changedIdealMin,
      required this.changedIdealMax,
      required this.changedMin,
      required this.valuesDisabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Brand.darkTeal,
            fontSize: Brand.h3Size(context),
            fontWeight: Brand.h3Weight,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Min/Max',
                style: GoogleFonts.poppins(
                  color: Brand.darkBlue,
                  fontSize: Brand.textSize(context),
                  fontWeight: Brand.inputWeight,
                ),
              ),
              SizedBox(
                  width: deviceWidth * 0.14,
                  child: CustomTextInputField(
                    onChangedCallback: changedMin,
                    isLongHint: false,
                    initialValue: '${interval[0]}',
                    hintText: 'min',
                    disabled: valuesDisabled[0],
                  )),
              SizedBox(
                  width: deviceWidth * 0.14,
                  child: CustomTextInputField(
                    onChangedCallback: changedMax,
                    isLongHint: false,
                    initialValue: '${interval[3]}',
                    hintText: 'max',
                    disabled: valuesDisabled[3],
                  )),
            ]),
        const SizedBox(
          height: 10,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'IdealMin',
                    style: GoogleFonts.poppins(
                      color: Brand.darkBlue,
                      fontSize: Brand.textSize(context),
                      fontWeight: Brand.inputWeight,
                    ),
                  ),
                  Text(
                    'IdeaMax',
                    style: GoogleFonts.poppins(
                      color: Brand.darkBlue,
                      fontSize: Brand.textSize(context),
                      fontWeight: Brand.inputWeight,
                    ),
                  ),
                ],
              ),
              SizedBox(
                  width: deviceWidth * 0.14,
                  child: CustomTextInputField(
                    onChangedCallback: changedIdealMin,
                    isLongHint: true,
                    hintText: 'Ideal Min',
                    initialValue: '${interval[1]}',
                    disabled: valuesDisabled[1],
                  )),
              SizedBox(
                  width: deviceWidth * 0.14,
                  child: CustomTextInputField(
                    onChangedCallback: changedIdealMax,
                    isLongHint: true,
                    hintText: 'Ideal max',
                    initialValue: '${interval[2]}',
                    disabled: valuesDisabled[2],
                  )),
            ]),
      ],
    );
  }
}

class CustomTextInputField extends StatelessWidget {
  final bool disabled;
  final String hintText;
  final String initialValue;
  final bool isLongHint;
  final Function(String) onChangedCallback;

  const CustomTextInputField(
      {super.key,
      required this.isLongHint,
      required this.disabled,
      required this.hintText,
      required this.initialValue,
      required this.onChangedCallback});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.poppins(
        color: Brand.darkBlue,
        fontSize: Brand.textSize(context),
        fontWeight: Brand.inputWeight,
      ),
      onChanged: onChangedCallback,
      maxLength: 4,
      maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
      enabled: !disabled,
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 1.5, color: Brand.blackGrey),
          borderRadius: BorderRadius.circular(
              Brand.appBorderRadius(context: context) * 0.5),
          gapPadding: 2,
        ),
        counter: null,
        counterText: "",
        label: Text(
          '$hintText',
          style: GoogleFonts.poppins(
            color: Brand.darkBlue,
            fontSize: isLongHint
                ? Brand.textSize(context) * 0.7
                : Brand.textSize(context),
            fontWeight: Brand.inputWeight,
          ),
        ),
      ),
    );
  }
}
