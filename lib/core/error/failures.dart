import 'package:equatable/equatable.dart';

import 'network_failure_kind.dart';

abstract class Failure extends Equatable {
  const Failure(this.message, {this.code, this.extensions = const {}});

  final String message;
  final String? code;
  final Map<String, dynamic> extensions;

  String get displayMessage => message;

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code, super.extensions});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {this.kind = NetworkFailureKind.noConnection});

  final NetworkFailureKind kind;

  @override
  List<Object?> get props => [message, kind];
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.errors, super.code, super.extensions});

  final Map<String, List<String>>? errors;

  @override
  String get displayMessage {
    final fieldErrors = errors?.values;
    if (fieldErrors == null || fieldErrors.isEmpty) return message;
    final firstGroup = fieldErrors.first;
    return firstGroup.isEmpty ? message : firstGroup.first;
  }

  @override
  List<Object?> get props => [message, code, errors];
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, {super.code, super.extensions});
}

class ConflictFailure extends Failure {
  const ConflictFailure(super.message, {super.code, super.extensions});
}

class RateLimitFailure extends Failure {
  const RateLimitFailure(super.message, {super.code, super.extensions});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
