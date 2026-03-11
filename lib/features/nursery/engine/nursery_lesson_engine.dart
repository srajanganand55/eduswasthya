import 'package:flutter/material.dart';

import '../shared/nursery_module_config.dart';
import 'nursery_persistence_adapter.dart';

class NurseryLessonEngine<T> {
  final NurseryModuleConfig<T> config;

  NurseryLessonEngine({
    required this.config,
  });

  NurseryPersistenceAdapter get persistenceAdapter =>
      config.persistenceAdapter;

  Future<List<int>> getCompletedLessonIndices() {
    return persistenceAdapter.getCompletedLessonIndices();
  }

  Future<int> getNextLessonIndex() {
    return persistenceAdapter.getNextLessonIndex();
  }

  bool isLessonUnlocked(List<int> completedLessons, int index) {
    return persistenceAdapter.isLessonUnlocked(completedLessons, index);
  }

  Future<bool> hasStartedButNotFinished() {
    return persistenceAdapter.hasStartedButNotFinished();
  }

  Future<bool> isModuleCompleted() {
    return persistenceAdapter.isModuleCompleted();
  }

  Future<void> markLessonCompleted(int index) {
    return persistenceAdapter.markLessonCompleted(index);
  }

  Future<void> resetModuleProgress() {
    return persistenceAdapter.resetModuleProgress();
  }

  Widget buildGridRoute(BuildContext context) {
    return config.gridRouteBuilder(context);
  }

  Widget buildLessonRoute(BuildContext context, int initialIndex) {
    return config.lessonScreenBuilder(
      context,
      config.lessonDataSource,
      initialIndex,
    );
  }

  Widget buildCompletionRoute(BuildContext context) {
    return config.completionRoute(context);
  }

  Future<void> openLesson(BuildContext context, int initialIndex) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => buildLessonRoute(context, initialIndex),
      ),
    );
  }

  Future<void> replaceWithCompletion(BuildContext context) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => buildCompletionRoute(context),
      ),
    );
  }

  Future<void> openContinueEntry(BuildContext context) async {
    final nextIndex = await getNextLessonIndex();

    if (nextIndex >= config.totalLessons) {
      await replaceWithCompletion(context);
      return;
    }

    await openLesson(context, nextIndex);
  }

  Future<void> restartAndOpenGrid(
    BuildContext context, {
    RoutePredicate? predicate,
  }) async {
    await resetModuleProgress();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => buildGridRoute(context),
      ),
      predicate ?? (route) => false,
    );
  }
}
