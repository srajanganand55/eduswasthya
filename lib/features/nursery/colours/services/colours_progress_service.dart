import 'package:shared_preferences/shared_preferences.dart';

class ColoursProgressService {
  static const String _prefix = 'nursery_colour_';
  static const String _completedKey = 'nursery_colours_completed';
  static const String _lastIndexKey = 'nursery_colours_last_index';

  static const List<String> _allIds = [
    'red',
    'blue',
    'yellow',
    'green',
    'orange',
    'purple',
    'pink',
    'brown',
  ];

  // ============================================================
  // ✅ MARK SINGLE COLOUR COMPLETE
  // ============================================================

  static Future<void> markColourCompleted(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix$id', true);
  }

  // ============================================================
  // ✅ CHECK SINGLE COLOUR (⭐ REQUIRED BY GRID)
  // ============================================================

  static Future<bool> isColourCompleted(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_prefix$id') ?? false;
  }

  // ============================================================
  // ⭐ STORE LAST INDEX (for Continue banner)
  // ============================================================

  static Future<void> setLastIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastIndexKey, index);
  }

  // ============================================================
  // ⭐ GET LAST INDEX (SELF-HEALING)
  // ============================================================

  static Future<int?> getLastIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_lastIndexKey);

    if (value == null) return null;
    if (value < 0 || value >= _allIds.length) return null;

    return value;
  }

  // ============================================================
  // ⭐ CHECK PARTIAL PROGRESS
  // ============================================================

  static Future<bool> hasStartedButNotFinished() async {
    final prefs = await SharedPreferences.getInstance();

    bool anyCompleted = false;
    bool allCompleted = true;

    for (final id in _allIds) {
      final done = prefs.getBool('$_prefix$id') ?? false;
      if (done) anyCompleted = true;
      if (!done) allCompleted = false;
    }

    return anyCompleted && !allCompleted;
  }

  // ============================================================
  // ✅ FULL COMPLETION CHECK
  // ============================================================

  static Future<bool> isColoursFullyCompleted() async {
    final prefs = await SharedPreferences.getInstance();

    for (final id in _allIds) {
      if (!(prefs.getBool('$_prefix$id') ?? false)) {
        return false;
      }
    }

    await prefs.setBool(_completedKey, true);
    return true;
  }

  // ============================================================
  // ⭐⭐⭐ RESET PROGRESS (WORKFLOW CRITICAL)
  // ============================================================

  static Future<void> resetColoursProgress() async {
    final prefs = await SharedPreferences.getInstance();

    // remove individual colour flags
    for (final id in _allIds) {
      await prefs.remove('$_prefix$id');
    }

    // remove module flags
    await prefs.remove(_completedKey);
    await prefs.remove(_lastIndexKey);
  }
}