import 'package:flutter/foundation.dart';

class Logger {
  static void log(String message, {String tag = 'APP'}) {
    if (kDebugMode) {
      print('[TAG] TAG message');
    }
  }

  static void logError(String message, {String tag = 'ERROR', dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('[TAG] TAG message');
      if (error != null) print('Error: TAG error');
      if (stackTrace != null) print('StackTrace: TAG stackTrace');
    }
  }

  static void logWarning(String message, {String tag = 'WARNING'}) {
    if (kDebugMode) {
      print('[TAG] TAG message');
    }
  }
}
