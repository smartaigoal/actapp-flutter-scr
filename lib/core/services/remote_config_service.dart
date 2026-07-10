import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> init() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await _remoteConfig.fetchAndActivate();
  }

  static String getString(String key, {String defaultValue = ''}) {
    return _remoteConfig.getString(key);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _remoteConfig.getBool(key);
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return _remoteConfig.getInt(key);
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    return _remoteConfig.getDouble(key);
  }
}
