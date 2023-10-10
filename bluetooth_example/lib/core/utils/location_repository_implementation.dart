import 'package:bluetooth_example/core/errors/failures.dart';
import 'package:bluetooth_example/core/utils/location_repository.dart';
import 'package:bluetooth_example/core/utils/util_exports.dart';
import 'package:dartz/dartz.dart';
import 'package:location/location.dart';

class LocationRepositoryIMPL implements LocationRepository {
  final Location _location = Location();

  @override
  Future<Either<Failure, bool>> turnOnLocation() async {
    final checkResult =
        await BluetoothPermissionChecker.isAllowedToOpenLocation();
    return checkResult.fold((l) => Left(l), (r) async {
      final result = await _location.requestService();
      return Right(result);
    });
  }

  @override
  Future<Either<Failure, Stream<LocationData>>> onLocationChanged() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, LocationData>> getCurrentLocation() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> enableLocationInBackground({required bool on}) {
    throw UnimplementedError();
  }
}
