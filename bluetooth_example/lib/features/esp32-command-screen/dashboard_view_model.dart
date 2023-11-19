import 'dart:typed_data';

import 'package:bluetooth_example/features/esp32-command-screen/dashboard_widgets/body_card_component/chart_config_model.dart';
import 'package:flutter/cupertino.dart';

class DashboardViewModel extends ChangeNotifier {
  //ChartConfig
  late ChartConfig chartConfig;

  late double currentTemperatureVal;
  late double currentHumidityVal;
  late double currentPhVal;
  late double currentEcVal;
  late double currentDOxyVal;
  late double currentWaterTempVal;

  void init() {
    chartConfig = ChartConfig.empty();
    currentTemperatureVal = 0.0;
    currentHumidityVal = 0.0;
    currentPhVal = 0.0;
    currentEcVal = 0.0;
    currentDOxyVal = 0.0;
    currentWaterTempVal = 0.0;
    notifyListeners();
  }

  void changeConfig({required ChartConfig config}) {
    chartConfig = config;
    notifyListeners();
  }

  void readValue({required Uint8List valueReadFromBLE}) {
    final valueRead = getValueDecoupled(valueReadFromBLE: valueReadFromBLE);

    switch (valueRead.keys.first) {
      case "Temperature":
        {
          currentTemperatureVal = getAnchreValueInFraction(
              value: valueRead.values.first,
              min: chartConfig.temperatureInterval[0],
              max: chartConfig.temperatureInterval[3]);
          notifyListeners();
        }
        break;
      case "Water Temperature":
        {
          currentWaterTempVal = getAnchreValueInFraction(
              value: valueRead.values.first,
              min: chartConfig.waterTemperatureInterval[0],
              max: chartConfig.waterTemperatureInterval[3]);
          notifyListeners();
        }
        break;
      case "Humidity":
        {
          currentWaterTempVal = getAnchreValueInFraction(
              value: valueRead.values.first,
              min: chartConfig.humidityInterval[0],
              max: chartConfig.humidityInterval[3]);
          notifyListeners();
        }
        break;
      case "Ph":
        {
          currentWaterTempVal = getAnchreValueInFraction(
              value: valueRead.values.first,
              min: chartConfig.phInterval[0],
              max: chartConfig.phInterval[3]);
          notifyListeners();
        }
        break;
      case "Ec":
        {
          currentWaterTempVal = getAnchreValueInFraction(
              value: valueRead.values.first,
              min: chartConfig.waterQualityInterval[0],
              max: chartConfig.waterQualityInterval[3]);
          notifyListeners();
        }
        break;
      case "Do":
        {
          currentWaterTempVal = getAnchreValueInFraction(
              value: valueRead.values.first,
              min: chartConfig.oxygenConcentrationInterval[0],
              max: chartConfig.oxygenConcentrationInterval[3]);
          notifyListeners();
        }
        break;
      default:
        {
          print("the key sent is unrecognized +++++ ${valueRead.keys.first}");
        }
    }
  }
}

double getAnchreValueInFraction(
    {dynamic value, required double min, required double max}) {
  if (value == null) {
    return 0.0;
  }
  return (value / (max - min)) * 100;
}

Map<String, dynamic> getValueDecoupled({required Uint8List valueReadFromBLE}) {
  final stringResult = String.fromCharCodes(valueReadFromBLE);
  final listOfStrings = stringResult.split(":");
  if (listOfStrings.isEmpty) {
    return {};
  }
  return {
    listOfStrings[0]: num.parse(listOfStrings[1]).toDouble(),
  };
}
