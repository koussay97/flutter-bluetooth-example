import 'package:bluetooth_example/core/brand_guideline/brand_guidline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ArcChart extends StatelessWidget {
  final String title;
  final double reading;
  final List<double> interval;

  const ArcChart(
      {super.key,
      required this.interval,
      required this.title,
      required this.reading});

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      title: GaugeTitle(
          text: title,
          textStyle: GoogleFonts.poppins(
              fontSize: Brand.h2Size(context), color: Brand.darkTeal)),
      enableLoadingAnimation: true,
      axes: [
        RadialAxis(
          startAngle: -45,
          endAngle: 230,
          minimum: interval[0],
          maximum: interval[3],
          isInversed: true,
          interval: interval[3] - interval[0],
          axisLineStyle: const AxisLineStyle(
            color: Brand.brightGreyBlue,
          ),
          pointers: [
            NeedlePointer(value: reading, enableAnimation: true),
          ],
          ranges: [
            GaugeRange(
              startValue: interval[0],
              endValue: interval[1],
              color: Brand.paleGreyBlue,
              label: "Low",
            ),
            GaugeRange(
              startValue: interval[1],
              endValue: interval[2],
              color: Brand.brightTeal,
              label: "Ideal",
            ),
            GaugeRange(
              startValue: interval[2],
              endValue: interval[3],
              color: Colors.redAccent,
              label: "Dangerous",
            ),
          ],
        ),
      ],
    );
  }
}
