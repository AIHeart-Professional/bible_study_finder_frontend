import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Professional logger for Bible Study Finder Frontend.
/// Provides structured logging with colors, timestamps, and different log levels.
enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}

/// ANSI color codes for terminal output
class _AnsiColors {
  static const String reset = '\x1B[0m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  // ignore: unused_field
  static const String blue = '\x1B[34m'; // Used in string interpolation
  // ignore: unused_field
  static const String magenta = '\x1B[35m'; // Used in string interpolation
  static const String cyan = '\x1B[36m';
  static const String white = '\x1B[37m';
  static const String brightRed = '\x1B[91m';
}

class BibleStudyLogger {
  static LogLevel _logLevel = LogLevel.info;
  static bool _initialized = false;
  static File? _logFile;
  static bool _fileOutput = false;
  static bool _consoleOutput = true;
  static final Map<String, BibleStudyLogger> _loggers = {};

  final String name;

  BibleStudyLogger._(this.name);

  /// Initialize the logging system
  static void initialize({
    LogLevel logLevel = LogLevel.info,
    String? logFilePath,
    bool consoleOutput = true,
    bool fileOutput = false,
  }) {
    if (_initialized) return;

    _logLevel = logLevel;
    _consoleOutput = consoleOutput;
    _fileOutput = fileOutput;

    if (fileOutput && logFilePath != null) {
      try {
        final file = File(logFilePath);
        final directory = file.parent;
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }
        _logFile = file;
      } catch (e) {
        developer.log(
          'Failed to initialize log file: $e',
          name: 'BibleStudyLogger',
          level: 1000, // ERROR level
        );
      }
    }

    _initialized = true;
  }

  /// Get a logger instance for the given name
  static BibleStudyLogger getLogger(String name) {
    if (!_initialized) {
      initialize();
    }

    if (!_loggers.containsKey(name)) {
      _loggers[name] = BibleStudyLogger._(name);
    }

    return _loggers[name]!;
  }

  /// Format timestamp
  String _formatTimestamp() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
  }

  /// Get color for log level
  String _getColorForLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return _AnsiColors.cyan;
      case LogLevel.info:
        return _AnsiColors.green;
      case LogLevel.warning:
        return _AnsiColors.yellow;
      case LogLevel.error:
        return _AnsiColors.red;
      case LogLevel.critical:
        return '${_AnsiColors.brightRed}${_AnsiColors.white}';
    }
  }

  /// Format log level string
  String _formatLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARNING';
      case LogLevel.error:
        return 'ERROR';
      case LogLevel.critical:
        return 'CRITICAL';
    }
  }

  /// Write to log file
  Future<void> _writeToFile(String message) async {
    if (!_fileOutput || _logFile == null) return;

    try {
      await _logFile!.writeAsString(
        '$message\n',
        mode: FileMode.append,
      );
    } catch (e) {
      // Silently fail to avoid recursion
    }
  }

  /// Internal log method
  void _log(LogLevel level, String message, {Object? error, StackTrace? stackTrace}) {
    if (_shouldLog(level)) {
      final timestamp = _formatTimestamp();
      final levelStr = _formatLevel(level);
      final color = _getColorForLevel(level);
      final nameStr = name.padRight(20);
      final levelStrPadded = levelStr.padRight(8);

      // Format console message with colors
      final consoleMessage = _consoleOutput && !kIsWeb
          ? '$_AnsiColors.magenta$timestamp$_AnsiColors.reset | '
              '$color$levelStrPadded$_AnsiColors.reset | '
              '$_AnsiColors.blue$nameStr$_AnsiColors.reset | '
              '$message'
          : '$timestamp | $levelStrPadded | $nameStr | $message';

      // Format file message without colors
      final fileMessage = '$timestamp | $levelStrPadded | $nameStr | $message';

      // Write to console
      if (_consoleOutput) {
        // Always use print() for console output so it shows up in terminal
        // developer.log() is used for Flutter DevTools, but print() is more visible in console
        print(consoleMessage);
        if (error != null) {
          print('${_AnsiColors.red}Error: $error${_AnsiColors.reset}');
        }
        if (stackTrace != null) {
          print('${_AnsiColors.yellow}Stack trace: $stackTrace${_AnsiColors.reset}');
        }
        
        // Also use developer.log() for Flutter DevTools integration
        if (kDebugMode) {
          developer.log(
            message,
            name: name,
            level: _getDeveloperLogLevel(level),
            error: error,
            stackTrace: stackTrace,
          );
        }
      }

      // Write to file
      if (_fileOutput) {
        _writeToFile(fileMessage);
        if (error != null) {
          _writeToFile('Error: $error');
        }
        if (stackTrace != null) {
          _writeToFile('Stack trace: $stackTrace');
        }
      }
    }
  }

  /// Check if should log at this level
  bool _shouldLog(LogLevel level) {
    final levelValues = {
      LogLevel.debug: 0,
      LogLevel.info: 1,
      LogLevel.warning: 2,
      LogLevel.error: 3,
      LogLevel.critical: 4,
    };

    return levelValues[level]! >= levelValues[_logLevel]!;
  }

  /// Convert LogLevel to developer.log level
  int _getDeveloperLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500; // DEBUG
      case LogLevel.info:
        return 800; // INFO
      case LogLevel.warning:
        return 900; // WARNING
      case LogLevel.error:
        return 1000; // ERROR
      case LogLevel.critical:
        return 1200; // CRITICAL
    }
  }

  /// Log debug message
  void debug(String message) {
    _log(LogLevel.debug, message);
  }

  /// Log info message
  void info(String message) {
    _log(LogLevel.info, message);
  }

  /// Log warning message
  void warning(String message) {
    _log(LogLevel.warning, message);
  }

  /// Log error message
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  }

  /// Log critical message
  void critical(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.critical, message, error: error, stackTrace: stackTrace);
  }

  /// Log API calls with structured information
  void logApiCall({
    required String method,
    required String url,
    int? statusCode,
    double? responseTime,
    String? error,
  }) {
    if (error != null) {
      this.error('API $method $url | Error: $error');
    } else if (statusCode != null) {
      final statusColor = (statusCode >= 200 && statusCode < 300)
          ? _AnsiColors.green
          : _AnsiColors.red;
      final timeInfo = responseTime != null ? ' | Time: ${responseTime.toStringAsFixed(3)}s' : '';
      final message = 'API $method $url | Status: $statusColor$statusCode${_AnsiColors.reset}$timeInfo';
      info(message);
    } else {
      info('API $method $url');
    }
  }

  /// Log database operations
  void logDatabaseOperation({
    required String operation,
    required String table,
    String? recordId,
    bool success = true,
    String? error,
  }) {
    final idInfo = recordId != null ? ' | ID: $recordId' : '';

    if (error != null) {
      this.error('DB $operation $table$idInfo | Error: $error');
    } else if (success) {
      info('DB $operation $table$idInfo | Success');
    } else {
      warning('DB $operation $table$idInfo | Failed');
    }
  }

  /// Log business logic operations
  void logBusinessLogic({
    required String operation,
    String? details,
    Map<String, dynamic>? data,
  }) {
    final detailsStr = details != null ? ' | $details' : '';
    final dataStr = data != null ? ' | Data: $data' : '';
    info('BUSINESS $operation$detailsStr$dataStr');
  }

  /// Log security events
  void logSecurityEvent({
    required String eventType,
    String? userId,
    String? ipAddress,
    String? details,
  }) {
    final userInfo = userId != null ? ' | User: $userId' : '';
    final ipInfo = ipAddress != null ? ' | IP: $ipAddress' : '';
    final detailsStr = details != null ? ' | $details' : '';
    warning('SECURITY $eventType$userInfo$ipInfo$detailsStr');
  }

  /// Log performance metrics
  void logPerformance({
    required String operation,
    required double duration,
    double? memoryUsage,
  }) {
    final memoryInfo = memoryUsage != null ? ' | Memory: ${memoryUsage.toStringAsFixed(2)}MB' : '';
    info('PERFORMANCE $operation | Duration: ${duration.toStringAsFixed(3)}s$memoryInfo');
  }
}

/// Convenience function to get a logger
BibleStudyLogger getLogger(String name) {
  return BibleStudyLogger.getLogger(name);
}

