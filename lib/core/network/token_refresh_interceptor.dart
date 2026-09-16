import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';
import '../storage/storage_keys.dart';
import 'end_points.dart';

class TokenRefreshInterceptor extends QueuedInterceptor {
  TokenRefreshInterceptor({
    required Dio dio,
    required this._secureStorage,
    this.onSessionExpired,
  })  : _dio = dio,
        _refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));

  final Dio _dio;
  final Dio _refreshDio;
  final AppSecureStorage _secureStorage;

  final void Function()? onSessionExpired;

  static const _noRefreshPaths = {
    EndPoints.login,
    EndPoints.register,
    EndPoints.refresh,
    EndPoints.logout,
    EndPoints.logoutAll,
  };

  static const _retryFlag = 'isRetry';

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final failedPath = err.requestOptions.path;
    if (err.response?.statusCode != 401 || _noRefreshPaths.contains(failedPath)) {
      return handler.next(err);
    }

    if (err.requestOptions.extra[_retryFlag] == true) {
      return handler.next(err);
    }

    final currentAccessToken = await _secureStorage.read(StorageKeys.accessToken);
    final failedRequestToken = err.requestOptions.headers['Authorization'] as String?;
    final tokenAlreadyRefreshed =
        currentAccessToken != null && 'Bearer $currentAccessToken' != failedRequestToken;

    if (tokenAlreadyRefreshed) {
      return _retry(err, handler, currentAccessToken);
    }

    final refreshToken = await _secureStorage.read(StorageKeys.refreshToken);
    if (refreshToken == null) {
      onSessionExpired?.call();
      return handler.next(err);
    }

    try {
      final response = await _refreshDio.post(
        EndPoints.refresh,
        data: {'refreshToken': refreshToken},
      );
      final newAccessToken = response.data['accessToken'] as String;
      final newRefreshToken = response.data['refreshToken'] as String;
      await _secureStorage.write(StorageKeys.accessToken, newAccessToken);
      await _secureStorage.write(StorageKeys.refreshToken, newRefreshToken);

      await _retry(err, handler, newAccessToken);
    } catch (_) {
      await _secureStorage.delete(StorageKeys.accessToken);
      await _secureStorage.delete(StorageKeys.refreshToken);
      onSessionExpired?.call();
      return handler.next(err);
    }
  }

  Future<void> _retry(
    DioException err,
    ErrorInterceptorHandler handler,
    String accessToken,
  ) async {
    try {
      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $accessToken';
      retryOptions.extra[_retryFlag] = true;
      final retryResponse = await _dio.fetch(retryOptions);
      handler.resolve(retryResponse);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}
