/// ideal values for [RealTimeDataCard]
/// - Temp : 27 -> 30°c *
/// - Hum  : 30% -> 45% *
/// - ph   : 6 -> 8 ph *
/// - Ec   : 0->0.8 ideal; 0.8 --> 2.5 -+ ; 2.5 --> 10 dangerous mS/cm *
/// - Do   : ideal 7 -> 10 mg/L oxygen *
/// - waterTemp : 20 -> 25 °C *

class ChartConfig {
  final List<double> temperatureInterval; // [min, idealBegin, idealEnd, max ]
  final List<double> humidityInterval; // [min, idealBegin, idealEnd, max ]
  final List<double> phInterval; // [min, idealBegin, idealEnd, max ]
  final List<double> waterQualityInterval; // [min, idealBegin, idealEnd, max ]
  final List<double>
  oxygenConcentrationInterval; // [min, idealBegin, idealEnd, max ]
  final List<double>
  waterTemperatureInterval; // [min, idealBegin, idealEnd, max ]

  ChartConfig(
      {required this.temperatureInterval,
        required this.humidityInterval,
        required this.phInterval,
        required this.waterQualityInterval,
        required this.oxygenConcentrationInterval,
        required this.waterTemperatureInterval});

  static ChartConfig empty() {
    return ChartConfig(
        temperatureInterval: [0, 20, 35, 80],
        humidityInterval: [0, 20, 50, 100],
        phInterval: [0, 6, 8, 14],
        waterQualityInterval: [0, 0.5, 2, 10],
        oxygenConcentrationInterval: [0, 7, 15, 40],
        waterTemperatureInterval: [0, 20, 35, 80]);
  }

  ChartConfig copyWith({
    double? minIdealTem,
    double? maxIdealTemp,

    double? minIdealHum,
    double? maxIdealHum,

    double? minIdealPh,
    double? maxIdealPh,

    double? minIdealEc,
    double? maxIdealEc,


    double? minIdealOxy,
    double? maxIdealOxy,


    double? minIdealWaterTem,
    double? maxIdealWaterTemp,

  }) {
    return ChartConfig(
      temperatureInterval: [
        0,
        minIdealTem ?? temperatureInterval[1],
        maxIdealTemp ?? temperatureInterval[2],
        80
      ],
      humidityInterval: [
        0,
        minIdealHum ?? humidityInterval[1],
        maxIdealHum ?? humidityInterval[2],
       100
      ],
      phInterval: [
        0,
        minIdealPh ?? phInterval[1],
        maxIdealPh ?? phInterval[2],
        14
      ],
      waterQualityInterval: [
        0,
        minIdealEc??waterQualityInterval[1],
        maxIdealEc??waterQualityInterval[2],
        10
      ],
      oxygenConcentrationInterval: [
      0,
        minIdealOxy ?? oxygenConcentrationInterval[1],
        maxIdealOxy ?? oxygenConcentrationInterval[2],
       40
      ],
      waterTemperatureInterval: [
        0,
        minIdealWaterTem??waterTemperatureInterval[1],
        minIdealWaterTem??waterTemperatureInterval[2],
       80
      ],
    );
  }

  // the widget that will read this position must accept values in %
  // in the widget ::
  // we want to draw 2 indicators minIdeal + maxIdeal
  // we want to draw our current position in the arc
  // all of the values will be exported using this function into % values
  static double getInArcPosition({double? value,required List<double>interval}){
    if(value==null){
      return 0.0;
    }
    return ((value)*100/(interval[3]-interval[0]));
  }

}