import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  // ================= ALPHABET =================

  static const String alphabetKey = "alphabet_completed_letters";
static const String _alphabetLastIndexKey = "alphabet_last_index";

/// Get completed letters safely
static Future<List<int>> getCompletedLetters() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? stored = prefs.getStringList(alphabetKey);

  if (stored == null) return [];

  List<int> letters =
      stored.map((e) => int.tryParse(e) ?? -1).toList();

  letters.removeWhere((e) => e < 0 || e > 25);
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

  // ⭐ ALSO store last index (CRITICAL FOR CONTINUE)
  await setAlphabetLastIndex(index);
}

/// ⭐ Save last visited alphabet index
static Future<void> setAlphabetLastIndex(int index) async {
  final prefs = await SharedPreferences.getInstance();
  int current = prefs.getInt(_alphabetLastIndexKey) ?? -1;

  if (index > current) {
    await prefs.setInt(_alphabetLastIndexKey, index);
  }
}

/// ⭐ Get last index
static Future<int?> getAlphabetLastIndex() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(_alphabetLastIndexKey);
}

/// ⭐ Partial progress detection (for Continue banner)
static Future<bool> hasStartedAlphabetButNotFinished() async {
  List<int> completed = await getCompletedLetters();

  if (completed.isEmpty) return false;
  if (completed.length == 26) return false;

  return true;
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
  await prefs.remove(_alphabetLastIndexKey);
}

  // ================= NUMBERS =================

  // ================= NUMBERS =================

static const String _numbersPrefix = "nursery_number_";
static const String _numbersLastIndexKey = "nursery_numbers_last_index";

/// ✅ mark single number complete
static Future<void> markNumberCompleted(int index) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool("$_numbersPrefix$index", true);

  // ⭐ store last index
  await setNumbersLastIndex(index);
}

/// ⭐ save last index
static Future<void> setNumbersLastIndex(int index) async {
  final prefs = await SharedPreferences.getInstance();
  int current = prefs.getInt(_numbersLastIndexKey) ?? -1;

  if (index > current) {
    await prefs.setInt(_numbersLastIndexKey, index);
  }
}

/// ⭐ get last index
static Future<int?> getNumbersLastIndex() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(_numbersLastIndexKey);
}

/// ⭐ check if specific number completed
static Future<bool> isNumberCompleted(int index) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool("$_numbersPrefix$index") ?? false;
}

/// ⭐ partial detection
static Future<bool> hasStartedNumbersButNotFinished() async {
  final prefs = await SharedPreferences.getInstance();

  bool anyCompleted = false;
  bool allCompleted = true;

  for (int i = 0; i < 10; i++) {
    final done = prefs.getBool("$_numbersPrefix$i") ?? false;
    if (done) anyCompleted = true;
    if (!done) allCompleted = false;
  }

  return anyCompleted && !allCompleted;
}

/// ⭐ full completion
static Future<bool> isNumbersFullyCompleted() async {
  final prefs = await SharedPreferences.getInstance();

  for (int i = 0; i < 10; i++) {
    if (!(prefs.getBool("$_numbersPrefix$i") ?? false)) {
      return false;
    }
  }
  return true;
}

/// ⭐ reset numbers
static Future<void> resetNumbersProgress() async {
  final prefs = await SharedPreferences.getInstance();

  for (int i = 0; i < 10; i++) {
    await prefs.remove("$_numbersPrefix$i");
  }

  await prefs.remove(_numbersLastIndexKey);
}  
}