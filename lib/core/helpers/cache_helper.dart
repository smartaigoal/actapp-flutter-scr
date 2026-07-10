import 'package:hive_flutter/hive_flutter.dart';

class CacheHelper {
  static late Box<dynamic> _placesBox;
  static late Box<dynamic> _adsBox;
  static late Box<dynamic> _settingsBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _placesBox = await Hive.openBox('placesBox');
    _adsBox = await Hive.openBox('adsBox');
    _settingsBox = await Hive.openBox('settingsBox');
  }

  static Future<void> savePlaces(List<dynamic> places) async {
    await _placesBox.put('places', places);
  }

  static List<dynamic> getPlaces() {
    return _placesBox.get('places', defaultValue: []);
  }

  static Future<void> saveAds(List<dynamic> ads) async {
    await _adsBox.put('ads', ads);
  }

  static List<dynamic> getAds() {
    return _adsBox.get('ads', defaultValue: []);
  }

  static Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _settingsBox.put('settings', settings);
  }

  static Map<String, dynamic> getSettings() {
    return _settingsBox.get('settings', defaultValue: {});
  }

  static Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk('placesBox');
    await Hive.deleteBoxFromDisk('adsBox');
    await Hive.deleteBoxFromDisk('settingsBox');
  }
}
