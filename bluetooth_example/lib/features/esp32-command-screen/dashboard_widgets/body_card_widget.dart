import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class RealTimeDataCard extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final String chartTitle;
  final double chartValue;
  final double height;
  final double width;

  const RealTimeDataCard({
    Key? key,
    required this.title,
    required this.chartTitle,
    required this.chartValue,
    required this.leadingIcon,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: Brand.paleGreyBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
                Brand.appPadding(context: context) * 0.5)),
        padding: EdgeInsets.symmetric(
            horizontal: Brand.appPadding(context: context) * 0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              leadingIcon,
              size: Brand.textSize(context) * 2,
              color: chartValue < 85
                  ? chartValue > 65
                      ? Colors.orangeAccent
                      : Brand.darkTeal
                  : Colors.redAccent,
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                  color: Brand.blackGrey,
                  fontSize: Brand.h3Size(context),
                  fontWeight: Brand.h3Weight),
            ),
            SizedBox(
              height: height,
              width: height,
              child: PieChart(
                PieChartData(
                    startDegreeOffset: -90.0,
                    borderData: FlBorderData(
                        border: const Border.symmetric(
                            horizontal: BorderSide(
                          color: Colors.white,
                          width: 1,
                        )),
                        show: true),
                    centerSpaceColor: Brand.brightGreyBlue,
                    pieTouchData: PieTouchData(
                        enabled: true,
                        longPressDuration: const Duration(milliseconds: 200)),
                    sections: [
                      PieChartSectionData(
                          color: chartValue < 85
                              ? chartValue > 65
                                  ? Colors.orangeAccent
                                  : Brand.darkGreyBlue
                              : Colors.redAccent,
                          value: chartValue,
                          title: chartTitle,
                          titleStyle: TextStyle(
                              color: Colors.white,
                              fontSize: Brand.textSize(context) * 0.8)),
                      PieChartSectionData(
                          showTitle: false,
                          color: Brand.darkTeal,
                          value: 100 - chartValue),
                    ]),
              ),
            ),
          ],
        ));
  }
}
