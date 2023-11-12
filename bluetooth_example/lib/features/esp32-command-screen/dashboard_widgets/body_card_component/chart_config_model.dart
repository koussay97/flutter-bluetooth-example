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
        temperatureInterval: [0, 20, 30, 50],
        humidityInterval: [0, 20, 30, 100],
        phInterval: [0, 6, 8, 14],
        waterQualityInterval: [0, 0.5, 2, 10],
        oxygenConcentrationInterval: [0, 20, 30, 90],
        waterTemperatureInterval: [0, 20, 30, 50]);
  }

  ChartConfig copyWith({
    double? minIdealTem,
    double? maxIdealTemp,
    double? maxTemperature,
    double? minHumidity,
    double? minIdealHum,
    double? maxIdealHum,
    double? maxHumidity,
    double? minIdealPh,
    double? maxIdealPh,

    double? minIdealEc,
    double? maxIdealEc,

    double? minOxy,
    double? minIdealOxy,
    double? maxIdealOxy,
    double? maxOxy,

    double? minIdealWaterTem,
    double? maxIdealWaterTemp,
    double? maxWaterTemperature,
  }) {
    return ChartConfig(
      temperatureInterval: [
        0,
        minIdealTem ?? temperatureInterval[1],
        maxIdealTemp ?? temperatureInterval[2],
        maxTemperature ?? temperatureInterval[3]
      ],
      humidityInterval: [
        minHumidity ?? humidityInterval[0],
        minIdealHum ?? humidityInterval[1],
        maxIdealHum ?? humidityInterval[2],
        maxHumidity ?? humidityInterval[3]
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
        minOxy ?? oxygenConcentrationInterval[0],
        minIdealOxy ?? oxygenConcentrationInterval[1],
        maxIdealOxy ?? oxygenConcentrationInterval[2],
        maxOxy ?? oxygenConcentrationInterval[3]
      ],
      waterTemperatureInterval: [
        0,
        minIdealWaterTem??waterTemperatureInterval[1],
        minIdealWaterTem??waterTemperatureInterval[2],
        maxIdealWaterTemp??waterTemperatureInterval[3]
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