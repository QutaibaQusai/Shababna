import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/app_config.dart';
import '../error/exceptions.dart';
import '../services/locale_service.dart';
import '../services/theme_service.dart';
import '../storage/secure_storage.dart';
import 'api_consumer.dart';
import 'api_interceptors.dart';
import 'token_refresh_interceptor.dart';

class DioConsumer implements ApiConsumer {
  DioConsumer({
    required this.dio,
    required AppSecureStorage secureStorage,
    required LocaleService localeService,
    required ThemeService themeService,
    void Function()? onSessionExpired,
  }) {
    dio.options
      ..baseUrl = AppConfig.baseUrl
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30)
      ..responseType = ResponseType.json;

    dio.interceptors.add(
      ApiInterceptor(
        secureStorage: secureStorage,
        localeService: localeService,
        themeService: themeService,
      ),
    );

    dio.interceptors.add(
      TokenRefreshInterceptor(
        dio: dio,
        secureStorage: secureStorage,
        onSessionExpired: onSessionExpired,
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
      ),
    );
  }

  final Dio dio;

  @override
  Future<dynamic> get(String path, {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, data: data, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: isFormData ? FormData.fromMap(data as Map<String, dynamic>) : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  @override
  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data as Map<String, dynamic>) : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: isFormData ? FormData.fromMap(data as Map<String, dynamic>) : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  @override
  Future<dynamic> delete(String path, {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.delete(path, data: data, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }
}
