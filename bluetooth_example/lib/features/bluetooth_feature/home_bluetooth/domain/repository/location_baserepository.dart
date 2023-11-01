import 'dart:async';

import 'package:bluetooth_example/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract interface class LocationBaseRepository{
  Future<Either<Failure,bool>>turnOnLocation();
  Future<Either<Failure,bool>>turnOffLocation();
  Future<Either<Failure,bool>>isLocationOn();
}