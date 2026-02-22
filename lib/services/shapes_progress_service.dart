import 'package:shared_preferences/shared_preferences.dart';
import '../services/shapes_progress_service.dart';

class ShapesProgressService {
  static const String shapesKey = "shapes_completed_items";

  /// total shapes in Nursery (we start with 8 — can expand later)
  static const int totalShapes = 7;

  /// Get completed shapes safely
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

  /// Mark shape completed
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
  }

  /// Check full completion
  static Future<bool> isShapesFullyCompleted() async {
    List<int> completed = await getCompletedShapes();
    return completed.length == totalShapes;
  }

  /// Reset progress
  static Future<void> resetShapesProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(shapesKey);
  }
}