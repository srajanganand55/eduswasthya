import '../shared/nursery_lesson_coordinator.dart';

class AnimalsProgressService {
  static const String progressKey = 'animals_progress';
  static const String _completedKey = 'animals_completed';
  static const String _lastIndexKey = 'animals_last_index';
  static const int _totalAnimals = 8;
  static const NurseryLessonCoordinator _coordinator =
      NurseryLessonCoordinator(
        progressKey: progressKey,
        totalLessons: _totalAnimals,
        completedKey: _completedKey,
        lastIndexKey: _lastIndexKey,
      );

  static Future<void> completeLesson(int index) async {
    await _coordinator.markLessonCompleted(index);
  }

  static Future<List<int>> getCompletedLessons() async {
    return _coordinator.getCompletedLessons();
  }

  static Future<bool> isLessonCompleted(int index) async {
    final completed = await getCompletedLessons();
    return completed.contains(index);
  }

  static bool isLessonUnlocked(List<int> completedLessons, int index) {
    return _coordinator.isLessonUnlocked(completedLessons, index);
  }

  static Future<int> getNextLessonIndex() async {
    return _coordinator.getNextLessonIndex();
  }

  static Future<void> setLastIndex(int index) async {
    await _coordinator.setLastIndex(index);
  }

  static Future<int?> getLastIndex() async {
    return _coordinator.getLastIndex();
  }

  static Future<bool> hasStartedButNotFinished() async {
    return _coordinator.hasStartedButNotFinished();
  }

  static Future<bool> isAnimalsFullyCompleted() async {
    return _coordinator.isModuleCompleted();
  }

  static Future<void> resetProgress() async {
    await _coordinator.resetModuleProgress();
  }
}
