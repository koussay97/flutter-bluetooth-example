import 'package:equatable/equatable.dart';

/// custom exception
///
/// - permission exception
/// - connection exception
/// - request exception

abstract class BaseException implements Exception {
  final String message;
  final String? stacktrace;
  final int code;

  BaseException({required this.message, this.stacktrace, required this.code});
}

class PermissionException extends BaseException implements Equatable {
  PermissionException(
      {required super.message, required super.code, super.stacktrace});

  @override
  List<int> get props => [code];

  @override
  bool? get stringify => true;
}

class ConnectionException extends BaseException implements Equatable {
  ConnectionException(
      {required super.message, required super.code, super.stacktrace});

  @override
  List<int> get props => [code];

  @override
  bool? get stringify => true;
}

class RequestException extends BaseException implements Equatable {
  RequestException(
      {required super.message, required super.code, super.stacktrace});

  @override
  List<int> get props => [code];

  @override
  bool? get stringify => true;
}
