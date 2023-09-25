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

  bool toggleValue=false;
  CustomBluetoothState? currentState;
  DeviceDataDto currentDevice =
      DeviceDataDto(name: 'UNKNOWN', address: 'UNKNOWN', isDiscoverable: false);
  bool loading = false;

  BluetoothViewModel() {
    _init();
  }

  Future<void> _init() async {
    // check if we have bluetooth enabled + check if permission is granted
   // debugPrint('called init +++++ ');

    //loading = true;
    final permissionBLState = await Permission.bluetooth.status;
    final permissionBLConnect = await Permission.bluetoothConnect.status;
    final permissionBLDiscoverable = await Permission.bluetoothAdvertise.status;
    final permissionBLScan = await Permission.bluetoothScan.status;

    if (permissionBLState.isGranted &&
        permissionBLConnect.isGranted
        // && permissionBLScan.isGranted
        // && permissionBLDiscoverable.isGranted
    ) {
      final bluetoothState = await FlutterBluetoothSerial.instance.state;
     // debugPrint('bluetooth state :: $bluetoothState');

      if (bluetoothState == BluetoothState.STATE_ON) {
        await _setDeviceData();
        currentState = CustomBluetoothState.secondState;
      } else {
        currentState = CustomBluetoothState.intermediate1;
      }
    } else {
      currentState = CustomBluetoothState.initial;
    }
   // loading = false;
    notifyListeners();
  }

  Future<void> _setDeviceData() async {
    currentDevice.name =
        await FlutterBluetoothSerial.instance.name ?? 'Unknown';
    currentDevice.address =
        await FlutterBluetoothSerial.instance.address ?? 'Unknown';
    currentDevice.isDiscoverable =
        await FlutterBluetoothSerial.instance.isDiscoverable ?? false;
    notifyListeners();
  }


  Future<void>enableBluetooth()async{
    toggleValue=!toggleValue;
    await _init();
    notifyListeners();
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
}
