import '../shared/nursery_lesson_coordinator.dart';

abstract class NurseryPersistenceAdapter {
  String get progressKey;
  int get totalLessons;

  Future<List<int>> getCompletedLessonIndices();
  Future<int> getNextLessonIndex();
  bool isLessonUnlocked(List<int> completedLessons, int index);
  Future<void> markLessonCompleted(int index);
  Future<void> setLastIndex(int index);
  Future<int?> getLastIndex();
  Future<bool> hasStartedButNotFinished();
  Future<bool> isModuleCompleted();
  Future<void> resetModuleProgress();
}

class AggregateNurseryPersistenceAdapter
    implements NurseryPersistenceAdapter {
  @override
  final String progressKey;
  @override
  final int totalLessons;
  final String? completedKey;
  final String? lastIndexKey;

  const AggregateNurseryPersistenceAdapter({
    required this.progressKey,
    required this.totalLessons,
    this.completedKey,
    this.lastIndexKey,
  });

  NurseryLessonCoordinator get _coordinator => NurseryLessonCoordinator(
        progressKey: progressKey,
        totalLessons: totalLessons,
        completedKey: completedKey,
        lastIndexKey: lastIndexKey,
      );

  @override
  Future<List<int>> getCompletedLessonIndices() {
    return _coordinator.getCompletedLessons();
  }

  @override
  Future<int> getNextLessonIndex() {
    return _coordinator.getNextLessonIndex();
  }

  @override
  bool isLessonUnlocked(List<int> completedLessons, int index) {
    return _coordinator.isLessonUnlocked(completedLessons, index);
  }

  @override
  Future<void> markLessonCompleted(int index) {
    return _coordinator.markLessonCompleted(index);
  }

  @override
  Future<void> setLastIndex(int index) {
    return _coordinator.setLastIndex(index);
  }

  @override
  Future<int?> getLastIndex() {
    return _coordinator.getLastIndex();
  }

  @override
  Future<bool> hasStartedButNotFinished() {
    return _coordinator.hasStartedButNotFinished();
  }

  @override
  Future<bool> isModuleCompleted() {
    return _coordinator.isModuleCompleted();
  }

  @override
  Future<void> resetModuleProgress() {
    return _coordinator.resetModuleProgress();
  }
}

class PerLessonNurseryPersistenceAdapter
    implements NurseryPersistenceAdapter {
  @override
  final String progressKey;
  @override
  final int totalLessons;
  final List<String> lessonKeys;
  final String? completedKey;
  final String? lastIndexKey;

  const PerLessonNurseryPersistenceAdapter({
    required this.progressKey,
    required this.totalLessons,
    required this.lessonKeys,
    this.completedKey,
    this.lastIndexKey,
  });

  NurseryLessonCoordinator get _coordinator => NurseryLessonCoordinator(
        progressKey: progressKey,
        totalLessons: totalLessons,
        lessonKeys: lessonKeys,
        completedKey: completedKey,
        lastIndexKey: lastIndexKey,
      );

  @override
  Future<List<int>> getCompletedLessonIndices() {
    return _coordinator.getCompletedLessons();
  }

  @override
  Future<int> getNextLessonIndex() {
    return _coordinator.getNextLessonIndex();
  }

  @override
  bool isLessonUnlocked(List<int> completedLessons, int index) {
    return _coordinator.isLessonUnlocked(completedLessons, index);
  }

  @override
  Future<void> markLessonCompleted(int index) {
    return _coordinator.markLessonCompleted(index);
  }

  @override
  Future<void> setLastIndex(int index) {
    return _coordinator.setLastIndex(index);
  }

  @override
  Future<int?> getLastIndex() {
    return _coordinator.getLastIndex();
  }

  @override
  Future<bool> hasStartedButNotFinished() {
    return _coordinator.hasStartedButNotFinished();
  }

  @override
  Future<bool> isModuleCompleted() {
    return _coordinator.isModuleCompleted();
  }

  @override
  Future<void> resetModuleProgress() {
    return _coordinator.resetModuleProgress();
  }
}
