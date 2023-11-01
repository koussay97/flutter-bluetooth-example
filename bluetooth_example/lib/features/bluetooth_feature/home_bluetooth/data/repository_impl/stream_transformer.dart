import 'dart:async';

import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/domain/repository/bluetooth_device_entity.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/presentation/bloc/bluetooth_state/bluetooth_state_bloc/bluetooth_state_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';



abstract class FlutterBluetoothSerialTransformer{

  static  StreamTransformer<BluetoothState,BluetoothBlocState> get transformer=> StreamTransformer.fromHandlers(
      handleError: (error,stackTrace,EventSink<BluetoothBlocState> sink){
        print('stream triggered error in StreamTransformer');
        sink.addError(BluetoothError(errorMessage: 'error from Stream', code: 404));
        sink.close();
      },

      handleDone: (EventSink<BluetoothBlocState> sink){
        sink.close();
      },
      handleData: (BluetoothState state,EventSink<BluetoothBlocState> sink){

        if(state == BluetoothState.STATE_ON||state==BluetoothState.STATE_BLE_ON){
          sink.add(BluetoothOn(currentDevice: BluetoothDeviceEntity.orEmpty()));
        }
        if(state == BluetoothState.STATE_OFF){
          sink.add(BluetoothOff());
        }
        if(state == BluetoothState.STATE_BLE_TURNING_ON||state == BluetoothState.STATE_TURNING_ON||state == BluetoothState.STATE_BLE_TURNING_OFF||state == BluetoothState.STATE_TURNING_OFF){
          sink.add(BluetoothTurningOn());
        }
        if(state == BluetoothState.ERROR||state == BluetoothState.UNKNOWN){
          sink.addError(BluetoothError(errorMessage: 'error from OS', code: 500));
        }
      }
  );

}