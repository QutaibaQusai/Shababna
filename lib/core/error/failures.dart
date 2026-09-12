import 'package:equatable/equatable.dart';

import 'network_failure_kind.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  String get displayMessage => message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
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
  const ValidationFailure(super.message, {this.errors});

  final Map<String, List<String>>? errors;

  @override
  String get displayMessage {
    final fieldErrors = errors?.values;
    if (fieldErrors == null || fieldErrors.isEmpty) return message;
    final firstGroup = fieldErrors.first;
    return firstGroup.isEmpty ? message : firstGroup.first;
  }

  @override
  List<Object?> get props => [message, errors];
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class ConflictFailure extends Failure {
  const ConflictFailure(super.message);
}

class RateLimitFailure extends Failure {
  const RateLimitFailure(super.message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
