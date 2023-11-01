import 'package:bluetooth_example/core/errors/failures.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/data/repository_impl/helper.dart';
import 'package:bluetooth_example/features/bluetooth_feature/home_bluetooth/domain/repository/location_baserepository.dart';
import 'package:dartz/dartz.dart';
import 'package:location/location.dart';

class LocationRepositoryIMPL implements LocationBaseRepository {
  final Location _location = Location();

  @override
  Future<Either<Failure, bool>> isLocationOn() async {
    return await Helper.highOrderFunction<bool>(
        callBack: () async => await _location.serviceEnabled(),
        fallbackValue: false);
  }

  @override
  Future<Either<Failure, bool>> turnOffLocation() async{
   throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> turnOnLocation() async{
    return await Helper.highOrderFunction<bool>(
        callBack: () async => await _location.requestService(),
        fallbackValue: false);
  }
}
