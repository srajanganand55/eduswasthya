import 'package:shared_preferences/shared_preferences.dart';

class NumbersProgressService {
  static const String numbersKey = "numbers_completed_list";

  /// Get completed numbers safely
  static Future<List<int>> getCompletedNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? stored = prefs.getStringList(numbersKey);

    if (stored == null) return [];

    List<int> numbers =
        stored.map((e) => int.tryParse(e) ?? -1).toList();

    // Remove invalid entries
    numbers.removeWhere((e) => e < 0 || e > 9);

    // Remove duplicates & sort
    numbers = numbers.toSet().toList()..sort();

    return numbers;
  }

  /// Mark number completed
  static Future<void> markNumberCompleted(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<int> completed = await getCompletedNumbers();

    if (!completed.contains(index)) {
      completed.add(index);
      completed.sort();
      await prefs.setStringList(
          numbersKey,
          completed.map((e) => e.toString()).toList());
    }
  }

  /// Check full completion (1–10)
  static Future<bool> isNumbersFullyCompleted() async {
    List<int> completed = await getCompletedNumbers();
    return completed.length == 10;
  }

  /// Reset numbers progress
  static Future<void> resetNumbersProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(numbersKey);
  }
}