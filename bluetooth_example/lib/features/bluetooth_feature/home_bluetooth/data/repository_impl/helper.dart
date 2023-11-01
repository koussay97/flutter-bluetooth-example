import 'package:bluetooth_example/core/errors/failures.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/data/repository_impl/home_bluetooth_permission_checker.dart';
import 'package:dartz/dartz.dart';

abstract class Helper {
  static Future<Either<Failure, T>> highOrderFunction<T>(
      {required Future<T?> Function() callBack,
        required T fallbackValue}) async {
    try {
      final blPerm =
      await HomeBluetoothPermissionChecker.isAllowedToOpenBluetooth();
      final locPerm =
      await HomeBluetoothPermissionChecker.isAllowedToOpenLocation();
      if (blPerm.isRight() && locPerm.isRight()) {
        final result = await callBack.call();
        return Right(result ?? fallbackValue);
      }
      if (blPerm.isLeft()) {

        blPerm.fold((l) => Future.value(Left(l)), (r) => null);
      }
      locPerm.fold((l) => Future.value(Left(l)), (r) => null);
      return Future.value(
          const Left(RequestFailure(message: 'something went wrong', code: 0)));
    } catch (e) {
      return Future.value(
          const Left(RequestFailure(message: 'something went wrong', code: 3)));
    }
  }
}