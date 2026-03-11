import 'package:shared_preferences/shared_preferences.dart';

class NurseryProgressBase {
  static Future<Object?> loadProgress(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  static Future<bool> saveProgress(String key, Object value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is bool) {
      return prefs.setBool(key, value);
    }
    if (value is int) {
      return prefs.setInt(key, value);
    }
    if (value is double) {
      return prefs.setDouble(key, value);
    }
    if (value is String) {
      return prefs.setString(key, value);
    }
    if (value is List<String>) {
      return prefs.setStringList(key, value);
    }

    throw ArgumentError('Unsupported SharedPreferences value type');
  }

  static Future<bool> resetProgress(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<bool> isCompleted(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<bool> markCompleted(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, true);
  }
}
