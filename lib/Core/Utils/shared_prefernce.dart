import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }

  // 👉 SORT TYPE (مهمتك)
  static Future<void> setSortType(String type) async {
    await _prefs.setString('sortType', type);
  }

  static String getSortType() {
    return _prefs.getString('sortType') ?? 'date';
  }

  static Future<void> saveSortType(String s) async {
    await _prefs.setString('sortType', s);

  }
}