import 'package:dio/dio.dart';

import '../services/locale_service.dart';
import '../services/theme_service.dart';
import '../storage/secure_storage.dart';
import '../storage/storage_keys.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor({
    required this._secureStorage,
    required this._localeService,
    required this._themeService,
  });

  final AppSecureStorage _secureStorage;
  final LocaleService _localeService;
  final ThemeService _themeService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept'] = 'application/json';
    if (options.data is! FormData) {
      options.headers.putIfAbsent('Content-Type', () => 'application/json');
    }

    options.headers['Accept-Language'] = _localeService.languageCode;
    options.headers['X-Theme'] = _themeService.themeName;

    final token = await _secureStorage.read(StorageKeys.accessToken);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
