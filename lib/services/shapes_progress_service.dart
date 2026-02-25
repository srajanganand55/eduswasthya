import 'package:shared_preferences/shared_preferences.dart';

class ShapesProgressService {
  static const String shapesKey = "shapes_completed_items";
  static const String _lastIndexKey = "shapes_last_index";

  /// total shapes in Nursery
  static const int totalShapes = 7;

  /// ================= GET COMPLETED =================

  static Future<List<int>> getCompletedShapes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? stored = prefs.getStringList(shapesKey);

    if (stored == null) return [];

    List<int> items =
        stored.map((e) => int.tryParse(e) ?? -1).toList();

    items.removeWhere((e) => e < 0 || e >= totalShapes);
    items = items.toSet().toList()..sort();

    return items;
  }

  /// ================= MARK COMPLETE =================

  static Future<void> markShapeCompleted(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<int> completed = await getCompletedShapes();

    if (!completed.contains(index)) {
      completed.add(index);
      completed.sort();

      await prefs.setStringList(
        shapesKey,
        completed.map((e) => e.toString()).toList(),
      );
    }

    // ⭐ store last index
    await setLastIndex(index);
  }

  /// ================= LAST INDEX =================

  static Future<void> setLastIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(_lastIndexKey) ?? -1;

    if (index > current) {
      await prefs.setInt(_lastIndexKey, index);
    }
  }

  static Future<int?> getLastIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastIndexKey);
  }

  /// ================= PARTIAL =================

  static Future<bool> hasStartedButNotFinished() async {
    List<int> completed = await getCompletedShapes();

    if (completed.isEmpty) return false;
    if (completed.length == totalShapes) return false;

    return true;
  }

  /// ================= FULL =================

  static Future<bool> isShapesFullyCompleted() async {
    List<int> completed = await getCompletedShapes();
    return completed.length == totalShapes;
  }

  /// ================= RESET =================

  static Future<void> resetShapesProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(shapesKey);
    await prefs.remove(_lastIndexKey);
  }
}