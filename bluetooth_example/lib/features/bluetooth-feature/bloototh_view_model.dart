import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

enum CustomBluetoothState {
  initial, // only show toggle btn
  intermediate1, // Bluetooth permissions grated but its not enabled
  secondState, // bluetooth is enabled => show device data ?
  intermediate2, // discovery failed show message
  finalState, // discovery Successful => show list of devices
}

class BluetoothViewModel extends ChangeNotifier {
  bool toggleValue = false;

  CustomBluetoothState? currentState;

  DeviceDataDto currentDevice =
      DeviceDataDto(name: 'UNKNOWN', address: 'UNKNOWN', isDiscoverable: false);
  bool loading = false;

  BluetoothViewModel() {
    toggleValue = false;
    _init.call();
    notifyListeners();
  }

  Future<void> _init() async {
    // check if we have bluetooth enabled + check if permission is granted

    // final permissionBLState = await Permission.bluetooth.status;
    // final permissionBLConnect = await Permission.bluetoothConnect.status;
    // final permissionBLDiscoverable = await Permission.bluetoothAdvertise.status;
    // final permissionBLScan = await Permission.bluetoothScan.status;

    await Future.wait([
      Permission.bluetooth.status,
      Permission.bluetoothConnect.status,
      Permission.bluetoothAdvertise.status,
      Permission.bluetoothScan.status,
    ]).then((value) async {
      debugPrint(
          "permissions ${value[0].isGranted && value[1].isGranted && value[2].isGranted} ");

      if (value[0].isGranted && value[1].isGranted && value[2].isGranted) {
        currentState = CustomBluetoothState.intermediate1;
        notifyListeners();
        await FlutterBluetoothSerial.instance.state.then((result) {
          debugPrint('bluetooth enabled ${result.isEnabled}');
          if (result.isEnabled) {
            toggleValue = true;
            currentState = CustomBluetoothState.secondState;
            notifyListeners();
          } else {
            toggleValue = false;
            currentState = CustomBluetoothState.intermediate1;
            notifyListeners();
          }

          // we need to call set device data
        });
      } else {
        currentState = CustomBluetoothState.initial;
        notifyListeners();
      }
    });
    debugPrint('state in init $currentState');
    _setDeviceData.call();
  }

  Future<void> _setDeviceData() async {
    /// (bluetooth is on + permission is grated)  && toggle btn is on
    /// currentState == CustomBluetoothState.secondState
    debugPrint('currentState ${currentState.toString()}');
    debugPrint('toggle val $toggleValue');
    if (currentState == CustomBluetoothState.secondState && toggleValue) {
      await Future.wait([
        FlutterBluetoothSerial.instance.name,
        FlutterBluetoothSerial.instance.address,
        FlutterBluetoothSerial.instance.isDiscoverable
      ]).then((value) {
        debugPrint(value.toString());
        currentDevice.name = (value[0] as String?) ?? 'U';
        currentDevice.address = (value[1] as String?) ?? 'U';
        currentDevice.isDiscoverable = (value[2] as bool?) ?? false;
        notifyListeners();
      });
    } else {
      currentDevice.name = 'Unknown';
      currentDevice.address = 'Unknown';
      currentDevice.isDiscoverable = false;
      notifyListeners();
    }
    debugPrint(currentDevice.toString());
  }

  Future<void> tryEnableBluetooth() async {
    await Future.wait(
            [Permission.bluetooth.status, Permission.bluetoothConnect.status])
        .then((value) {
      if (value[0].isGranted && value[1].isGranted) {
        toggleValue = !toggleValue;

        if (toggleValue) {
          currentState = CustomBluetoothState.secondState;
        } else {
          currentState = CustomBluetoothState.intermediate1;
        }
      }
      toggleValue = false;
      currentState = CustomBluetoothState.initial;
      _setDeviceData();
      notifyListeners();
    });
  }
}

class DeviceDataDto {
  String name;
  String address;
  bool isDiscoverable;

  DeviceDataDto(
      {required this.name,
      required this.address,
      required this.isDiscoverable});

  @override
  toString() =>
      'name : $name , address : $address , isDiscoverable : $isDiscoverable';
}
