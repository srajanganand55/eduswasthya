import 'nursery_lesson_coordinator.dart';

class NurseryLessonFlowController {
  final NurseryLessonCoordinator _coordinator;
  final Future<void> Function(int index)? _markLessonCompleted;
  final Future<void> Function(int nextIndex)? _persistNextIndex;
  final Future<void> Function()? _resetModuleProgress;

  int currentLessonIndex;

  NurseryLessonFlowController({
    required String progressKey,
    required int totalLessons,
    required this.currentLessonIndex,
    List<String>? lessonKeys,
    String? completedKey,
    String? lastIndexKey,
    Future<void> Function(int index)? markLessonCompleted,
    Future<void> Function(int nextIndex)? persistNextIndex,
    Future<void> Function()? resetModuleProgress,
  })  : _markLessonCompleted = markLessonCompleted,
        _persistNextIndex = persistNextIndex,
        _resetModuleProgress = resetModuleProgress,
        _coordinator = NurseryLessonCoordinator(
          progressKey: progressKey,
          totalLessons: totalLessons,
          lessonKeys: lessonKeys,
          completedKey: completedKey,
          lastIndexKey: lastIndexKey,
        );

  int get totalLessons => _coordinator.totalLessons;

  bool get isFirstLesson => currentLessonIndex == 0;

  bool get isLastLesson => currentLessonIndex == totalLessons - 1;

  Future<void> initializeFromContinueState({int? initialIndex}) async {
    if (initialIndex != null) {
      currentLessonIndex = initialIndex;
      return;
    }

    final lastIndex = await _coordinator.getLastIndex();
    final fallbackIndex = await _coordinator.getNextLessonIndex();
    currentLessonIndex =
        (lastIndex ?? fallbackIndex).clamp(0, totalLessons - 1) as int;
  }

  bool shouldShowCompletion() {
    return isLastLesson;
  }

  Future<void> saveProgressOnAdvance() async {
    if (_markLessonCompleted != null) {
      await _markLessonCompleted!(currentLessonIndex);
      return;
    }

    await _coordinator.markLessonCompleted(currentLessonIndex);
  }

  Future<bool> nextLesson() async {
    await saveProgressOnAdvance();

    if (shouldShowCompletion()) {
      await _persistNextLessonIndex(totalLessons);
      return true;
    }

    currentLessonIndex++;
    await _persistNextLessonIndex(currentLessonIndex + 1);
    await saveProgressOnAdvance();
    return false;
  }

  Future<bool> previousLesson() async {
    if (isFirstLesson) {
      return false;
    }

    currentLessonIndex--;
    await _persistNextLessonIndex(currentLessonIndex + 1);
    await saveProgressOnAdvance();
    return true;
  }

  Future<int?> computeContinueLesson() async {
    final completedLessons = await _coordinator.getCompletedLessons();
    return _coordinator.computeContinueLesson(completedLessons);
  }

  Future<void> handleRestart() async {
    if (_resetModuleProgress != null) {
      await _resetModuleProgress!();
      return;
    }

    await _coordinator.resetModuleProgress();
  }

  Future<void> _persistNextLessonIndex(int nextIndex) async {
    if (_persistNextIndex != null) {
      await _persistNextIndex!(nextIndex);
      return;
    }

    await _coordinator.setLastIndex(nextIndex);
  }
}
