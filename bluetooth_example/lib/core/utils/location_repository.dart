import 'package:bluetooth_example/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:location/location.dart';

abstract interface class LocationRepository{

  Future<Either<Failure,bool>> turnOnLocation();
  Future<Either<Failure,bool>> enableLocationInBackground({required bool on});
  Future<Either<Failure,LocationData>> getCurrentLocation();
  Future<Either<Failure,Stream<LocationData>>> onLocationChanged();

}