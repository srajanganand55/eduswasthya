import 'nursery_progress_base.dart';

class NurseryLessonCoordinator {
  final String progressKey;
  final int totalLessons;
  final List<String>? lessonKeys;
  final String? completedKey;
  final String? lastIndexKey;

  const NurseryLessonCoordinator({
    required this.progressKey,
    required this.totalLessons,
    this.lessonKeys,
    this.completedKey,
    this.lastIndexKey,
  }) : assert(
          lessonKeys == null || lessonKeys.length == totalLessons,
          'lessonKeys length must match totalLessons',
        );

  Future<List<int>> getCompletedLessons() async {
    if (lessonKeys != null) {
      final completed = <int>[];

      for (var index = 0; index < lessonKeys!.length; index++) {
        if (await NurseryProgressBase.isCompleted(lessonKeys![index])) {
          completed.add(index);
        }
      }

      return completed;
    }

    final stored =
        (await NurseryProgressBase.loadProgress(progressKey) as List<String>?) ??
            <String>[];

    return stored
        .map((value) => int.tryParse(value))
        .whereType<int>()
        .where((value) => value >= 0 && value < totalLessons)
        .toSet()
        .toList()
      ..sort();
  }

  Future<int> getNextLessonIndex() async {
    final completed = await getCompletedLessons();
    return computeContinueLesson(completed) ?? totalLessons;
  }

  bool isLessonUnlocked(List<int> completedLessons, int index) {
    return index == 0 || completedLessons.contains(index - 1);
  }

  Future<void> markLessonCompleted(int index) async {
    if (index < 0 || index >= totalLessons) return;

    if (lessonKeys != null) {
      await NurseryProgressBase.markCompleted(lessonKeys![index]);
    } else {
      final completed = await getCompletedLessons();

      if (!completed.contains(index)) {
        completed.add(index);
        completed.sort();
        await NurseryProgressBase.saveProgress(
          progressKey,
          completed.map((value) => value.toString()).toList(),
        );
      }
    }

    if (lastIndexKey != null) {
      final nextIndex = index + 1 > totalLessons ? totalLessons : index + 1;
      await setLastIndex(nextIndex);
    }
  }

  int? computeContinueLesson(List<int> completedLessons) {
    for (var index = 0; index < totalLessons; index++) {
      if (!completedLessons.contains(index)) {
        return index;
      }
    }

    return null;
  }

  Future<void> resetModuleProgress() async {
    if (lessonKeys != null) {
      for (final key in lessonKeys!) {
        await NurseryProgressBase.resetProgress(key);
      }
    } else {
      await NurseryProgressBase.resetProgress(progressKey);
    }

    if (completedKey != null) {
      await NurseryProgressBase.resetProgress(completedKey!);
    }

    if (lastIndexKey != null) {
      await NurseryProgressBase.resetProgress(lastIndexKey!);
    }
  }

  Future<bool> isModuleCompleted() async {
    final completed = await getCompletedLessons();
    final isCompleted = completed.length == totalLessons;

    if (isCompleted && completedKey != null) {
      await NurseryProgressBase.markCompleted(completedKey!);
    }

    return isCompleted;
  }

  Future<bool> hasStartedButNotFinished() async {
    final completed = await getCompletedLessons();
    return completed.isNotEmpty && completed.length < totalLessons;
  }

  Future<void> setLastIndex(int index) async {
    if (lastIndexKey == null) return;

    final current = await getLastIndex() ?? 0;
    final safeIndex = index.clamp(0, totalLessons);

    if (safeIndex > current) {
      await NurseryProgressBase.saveProgress(lastIndexKey!, safeIndex);
    }
  }

  Future<int?> getLastIndex() async {
    if (lastIndexKey == null) return null;

    final value = await NurseryProgressBase.loadProgress(lastIndexKey!) as int?;

    if (value == null) return null;
    if (value < 0 || value > totalLessons) return null;

    return value;
  }
}
