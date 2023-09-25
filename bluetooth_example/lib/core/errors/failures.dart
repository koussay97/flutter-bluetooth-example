import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? stacktrace;
  final int code;

  const Failure({required this.message, this.stacktrace, required this.code});

  @override
  List<Object> get props => [code];

  @override
  bool get stringify => true;
}

class PermissionFailure extends Failure {
  const PermissionFailure({required super.message, required super.code});
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({required super.message, required super.code});
}

class RequestFailure extends Failure {
  const RequestFailure({required super.message, required super.code});
}
