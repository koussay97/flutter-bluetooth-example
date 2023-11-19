import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:bluetooth_example/features/esp32-command-screen/dashboard_widgets/body_card_component/new_arc_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RealTimeDataCard extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final String chartTitle;
  final double chartValue;
  final double height;
  final double width;
  final List<double> interval;

  const RealTimeDataCard({
    Key? key,
    required this.interval,
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
              width: height * 0.8,
              child: ArcChart(
                  interval: interval, reading: chartValue, title: chartTitle),
            ),
          ],
        ));
  }
}
