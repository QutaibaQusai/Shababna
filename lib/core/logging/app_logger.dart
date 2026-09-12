import 'package:logger/logger.dart';

abstract interface class AppLogger {
  void debug(String message, {String? tag});
  void info(String message, {String? tag});
  void warning(String message, {String? tag});
  void error(String message, {String? tag, Object? error, StackTrace? stackTrace});
}

class AppLoggerImpl implements AppLogger {
  AppLoggerImpl()
      : _logger = Logger(
          printer: PrettyPrinter(
            methodCount: 0,
            errorMethodCount: 5,
            lineLength: 100,
            colors: true,
            printEmojis: true,
            dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
          ),
        );

  final Logger _logger;

  @override
  void debug(String message, {String? tag}) => _logger.d(_format(message, tag));

  @override
  void info(String message, {String? tag}) => _logger.i(_format(message, tag));

  @override
  void warning(String message, {String? tag}) => _logger.w(_format(message, tag));

  @override
  void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) =>
      _logger.e(_format(message, tag), error: error, stackTrace: stackTrace);

  String _format(String message, String? tag) => tag != null ? '[$tag] $message' : message;
}