import 'package:dio/dio.dart';

import 'network_failure_kind.dart';

class ServerException implements Exception {
  const ServerException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  const ValidationException(this.message, this.errors);

  final String message;
  final Map<String, List<String>> errors;

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  const NetworkException(this.message, {this.kind = NetworkFailureKind.noConnection});

  final String message;
  final NetworkFailureKind kind;

  @override
  String toString() => message;
}

class CacheException implements Exception {
  const CacheException(this.message);

  final String message;

  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  const UnauthorizedException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ConflictException implements Exception {
  const ConflictException(this.message);

  final String message;

  @override
  String toString() => message;
}

class RateLimitException implements Exception {
  const RateLimitException(this.message);

  final String message;

  @override
  String toString() => message;
}

Never handleDioExceptions(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      throw const NetworkException(
        'Connection timeout. Please check your internet connection.',
        kind: NetworkFailureKind.timeout,
      );

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;
      final message = _problemMessage(responseData) ?? _defaultMessage(statusCode);

      if (statusCode == 400 && responseData is Map<String, dynamic>) {
        final rawErrors = responseData['errors'];
        if (rawErrors is Map<String, dynamic>) {
          throw ValidationException(
            message,
            rawErrors.map(
              (field, messages) => MapEntry(
                field,
                (messages as List).map((m) => m.toString()).toList(),
              ),
            ),
          );
        }
      }

      switch (statusCode) {
        case 401:
          throw UnauthorizedException(message);
        case 409:
          throw ConflictException(message);
        case 429:
          throw RateLimitException(message);
        default:
          throw ServerException(message);
      }

    case DioExceptionType.cancel:
      throw const ServerException('Request was cancelled.');

    case DioExceptionType.connectionError:
      throw const NetworkException(
        'No internet connection. Please check your network.',
      );

    case DioExceptionType.badCertificate:
      throw const NetworkException(
        'Unable to establish a secure connection.',
        kind: NetworkFailureKind.badCertificate,
      );

    case DioExceptionType.unknown:
      if (e.error.toString().contains('SocketException')) {
        throw const NetworkException(
          'No internet connection. Please check your network.',
        );
      }
      throw const ServerException('Unexpected error occurred. Please try again.');
  }
}

String? _problemMessage(Object? responseData) {
  if (responseData is! Map<String, dynamic>) return null;
  return (responseData['detail'] as String?) ?? (responseData['title'] as String?);
}

String _defaultMessage(int? statusCode) => switch (statusCode) {
      400 => 'Bad request. Please check your input.',
      401 => 'Unauthenticated. Please login again.',
      403 => 'You don\'t have access to this resource.',
      404 => 'Resource not found.',
      409 => 'This already exists.',
      429 => 'Too many requests. Please try again shortly.',
      500 || 502 || 503 => 'Server error. Please try again later.',
      _ => 'Something went wrong. Please try again.',
    };
