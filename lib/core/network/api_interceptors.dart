import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';
import '../storage/storage_keys.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor({required this._secureStorage});

  final AppSecureStorage _secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept'] = 'application/json';
    if (options.data is! FormData) {
      options.headers.putIfAbsent('Content-Type', () => 'application/json');
    }

    final token = await _secureStorage.read(StorageKeys.accessToken);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
