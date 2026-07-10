class RemoteConfigService {
  static Future<void> init() async {
    // Initialize Remote Config
    // Set default values
    // Fetch and activate remote config
  }

  static String getString(String key, {String defaultValue = ''}) {
    return defaultValue;
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return defaultValue;
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return defaultValue;
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    return defaultValue;
  }
}
