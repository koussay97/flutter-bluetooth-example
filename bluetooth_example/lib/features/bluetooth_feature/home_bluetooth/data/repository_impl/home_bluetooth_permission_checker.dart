import 'package:bluetooth_example/core/errors/exceptions.dart';
import 'package:bluetooth_example/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class HomeBluetoothPermissionChecker{

  static Future<Either<PermissionFailure,bool>>isAllowedToOpenBluetooth()async{

  final checkResults = await Future.wait([
    Permission.bluetooth.status.isGranted,
    Permission.bluetoothConnect.status.isGranted,
  ]);

  final permissionBLState = checkResults[0];
  final permissionBLConnect = checkResults[1];

  if (permissionBLState && permissionBLConnect) {
  return Future.value(const Right(true));
  }

  return Future.value(const Left(PermissionFailure(
  message: 'we request permission to open bluetooth ', code: 0)));

}
static Future<Either<PermissionFailure,bool>> isAllowedToOpenLocation()async{
    final checkResult = await Future.wait([Permission.location.isGranted,Permission.locationAlways.isGranted]);
    final permissionLocation = checkResult[0];
    final permissionLocationAlways = checkResult[1];
    if(permissionLocationAlways && permissionLocation){
      return Future.value(const Right(true));
    }
    return Future.value(const Left(PermissionFailure(
        message: 'we request permission to open location ', code: 1)));


}

}