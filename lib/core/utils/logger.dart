import 'package:flutter/foundation.dart';

class Logger {
  static void log(String message, {String tag = 'APP'}) {
    if (kDebugMode) {
      print('[$tag] $message');
    }
  }

  static void logError(String message, {String tag = 'ERROR', dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('[$tag] $message');
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    }
  }

  static void logWarning(String message, {String tag = 'WARNING'}) {
    if (kDebugMode) {
      print('[$tag] $message');
    }
  }
}
