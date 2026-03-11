import '../../shared/nursery_lesson_coordinator.dart';
import '../../shared/nursery_progress_base.dart';

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
  static final NurseryLessonCoordinator _coordinator =
      NurseryLessonCoordinator(
        progressKey: _prefix,
        totalLessons: _allIds.length,
        lessonKeys: _allIds.map((id) => '$_prefix$id').toList(),
        completedKey: _completedKey,
        lastIndexKey: _lastIndexKey,
      );

  // ============================================================
  // ✅ MARK SINGLE COLOUR COMPLETE
  // ============================================================

  static Future<void> markColourCompleted(String id) async {
    await NurseryProgressBase.saveProgress('$_prefix$id', true);
  }

  // ============================================================
  // ✅ CHECK SINGLE COLOUR (⭐ REQUIRED BY GRID)
  // ============================================================

  static Future<bool> isColourCompleted(String id) async {
    return await NurseryProgressBase.isCompleted('$_prefix$id');
  }

  // ============================================================
  // ⭐ STORE LAST INDEX (for Continue banner)
  // ============================================================

  static Future<void> setLastIndex(int index) async {
    await NurseryProgressBase.saveProgress(_lastIndexKey, index);
  }

  // ============================================================
  // ⭐ GET LAST INDEX (SELF-HEALING)
  // ============================================================

  static Future<int?> getLastIndex() async {
    final value = await NurseryProgressBase.loadProgress(_lastIndexKey) as int?;

    if (value == null) return null;
    if (value < 0 || value >= _allIds.length) return null;

    return value;
  }

  // ============================================================
  // ⭐ CHECK PARTIAL PROGRESS
  // ============================================================

  static Future<bool> hasStartedButNotFinished() async {
    return _coordinator.hasStartedButNotFinished();
  }

  // ============================================================
  // ✅ FULL COMPLETION CHECK
  // ============================================================

  static Future<bool> isColoursFullyCompleted() async {
    return _coordinator.isModuleCompleted();
  }

  // ============================================================
  // ⭐⭐⭐ RESET PROGRESS (WORKFLOW CRITICAL)
  // ============================================================

  static Future<void> resetColoursProgress() async {
    await _coordinator.resetModuleProgress();
  }
}
