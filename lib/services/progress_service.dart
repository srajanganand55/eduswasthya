import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  // ================= ALPHABET =================

  static const String alphabetKey = "alphabet_completed_letters";

  /// Get completed letters safely
  static Future<List<int>> getCompletedLetters() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? stored = prefs.getStringList(alphabetKey);

    if (stored == null) return [];

    // Convert safely to int list
    List<int> letters =
        stored.map((e) => int.tryParse(e) ?? -1).toList();

    // Remove invalid values (self healing)
    letters.removeWhere((e) => e < 0 || e > 25);

    // Remove duplicates & sort
    letters = letters.toSet().toList()..sort();

    return letters;
  }

  /// Mark a letter completed safely
  static Future<void> markLetterCompleted(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<int> completed = await getCompletedLetters();

    if (!completed.contains(index)) {
      completed.add(index);
      completed.sort();
      await prefs.setStringList(
        alphabetKey,
        completed.map((e) => e.toString()).toList(),
      );
    }
  }

  /// Check full completion
  static Future<bool> isAlphabetFullyCompleted() async {
    List<int> completed = await getCompletedLetters();
    return completed.length == 26;
  }

  /// Reset alphabet progress
  static Future<void> resetAlphabetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(alphabetKey);
  }

  // ================= NUMBERS =================

  static const String _numbersCompletedKey = "numbers_completed";
  static const String _numbersLastIndexKey = "numbers_last_index";

  /// Save numbers progress safely
  static Future<void> saveNumbersProgress(int index) async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(_numbersLastIndexKey) ?? 0;

    if (index > current) {
      await prefs.setInt(_numbersLastIndexKey, index);
    }
  }

  /// Get last completed number index
  static Future<int> getNumbersLastIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_numbersLastIndexKey) ?? 0;
  }

  /// Mark numbers fully completed
  static Future<void> markNumbersCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_numbersCompletedKey, true);
  }

  /// Check if numbers fully completed
  static Future<bool> isNumbersFullyCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_numbersCompletedKey) ?? false;
  }

  /// Reset numbers progress
  static Future<void> resetNumbersProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_numbersLastIndexKey);
    await prefs.remove(_numbersCompletedKey);
  }
}