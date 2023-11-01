import 'dart:async';

import 'package:bluetooth_example/core/errors/failures.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/data/repository_impl/stream_transformer.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/domain/repository/bluetooth_device_entity.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/domain/repository/bluetooth_state_base_repository.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/domain/repository/location_baserepository.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/presentation/bloc/bluetooth_state/bluetooth_state_bloc/bluetooth_state_bloc_event.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/presentation/bloc/bluetooth_state/bluetooth_state_bloc/bluetooth_state_bloc_state.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BlocHelper{
  static Future<void> init(
      {required InitBluetoothEvent event,
        required Emitter<BluetoothBlocState> emit,
        required LocationBaseRepository locRepository,
        required BluetoothStateRepository blRepository}) async {
    emit(BluetoothTurningOn());
    await locRepository.isLocationOn().then((value) {
      value.fold(
              (l) {
            emit(BluetoothOff());},
              (r) async {
            if(!r){
              emit(BluetoothOff());
              await blRepository.isBluetoothConnected().then((value) {
                value.fold(
                        (l) {},
                        (r) async{
                      if(r){
                        await blRepository.closeBluetooth();
                      }});
              });
            } else {
              await blRepository.isBluetoothConnected().then((value) {
                value.fold((l) {
                  emit(BluetoothOff());
                }, (r) async{
                  if(r){
                    final result = await blRepository.getDeviceData();
                    result.fold((l) {
                      emit(BluetoothOn(currentDevice: BluetoothDeviceEntity.orEmpty()));
                    }, (r) {
                      emit(BluetoothOn(currentDevice: r));
                    });
                  }else{
                    emit(BluetoothOff());
                  }
                });
              });
            }
          });
    });
  }
  static Future<void> turnOn(
      { required  TurnOnBluetoothEvent event,
        required Emitter<BluetoothBlocState> emit,
        required LocationBaseRepository locRepository,
        required BluetoothStateRepository blRepository
  })async {
    emit(BluetoothTurningOn());
   await blRepository.openBluetooth().then((value) {
     value.fold((l) {
       // if code == 0 => missing bluetooth permissions
       // if code == 1 => missing location permissions
       emit(BluetoothError(errorMessage: l.message, code: l.code));
     }, (r) async{
       if(r){
         final result = await blRepository.getDeviceData();
         result.fold((l) {
           emit(BluetoothOn(currentDevice: BluetoothDeviceEntity.orEmpty()));
         }, (r) {
           emit(BluetoothOn(currentDevice: r));
         });
       }else{
         emit(BluetoothOff());
       }
     });
   });

  }

  static Future<void> turnOff(
      { required TurnOffBluetoothEvent event,
        required Emitter<BluetoothBlocState> emit,
        required LocationBaseRepository locRepository,
        required BluetoothStateRepository blRepository
      }) async{
    emit(BluetoothTurningOn());
    await blRepository.closeBluetooth().then((value){
     value.fold((l) {
       // if code == 0 => missing bluetooth permissions
       // if code == 1 => missing location permissions
       emit(
           BluetoothError(errorMessage: l.message, code: l.code));
       }, (r) {
       if(r){
         emit(BluetoothOff());
       }
     });
   });

  }

  static Future<Either<Failure,Stream<BluetoothBlocState>?>>listenToPackage({required BluetoothStateRepository blRepository})async{
    /// check if bluetooth is open [FlutterBluetoothSerial]
    /// call the repository function getCurrentState;
    /// on failure return null
    /// it is safe to listen to the state from the plugin because in the initEvent,
    /// if the location is not on we will turn off the bluetooth manually
    /// meaning that we are indirectly extending the package functionality to give us
    /// connected status only if both bluetooth and location are both turned on !!
    final checkResult = await  blRepository.isBluetoothConnected();
    return checkResult.fold((l) {
      print('failed to obtain the ble connection stream from the plugin due to bluetooth is not open');
      return const Right(null);
    } , (r)async {

      final stream = await blRepository.getBluetoothCurrentState();
         return stream.fold(
                 (l) {
            print('failed to obtain the ble connection stream from the plugin due to permission issues');
            return const Right(null);
          },
                 (r) => right(r?.transform(FlutterBluetoothSerialTransformer.transformer))
         );
    });
  }
}
