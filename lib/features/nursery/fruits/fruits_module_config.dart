import 'package:flutter/material.dart';

import '../../../content/fruits_data.dart';
import '../engine/nursery_engine_grid_screen.dart';
import '../engine/nursery_engine_lesson_screen.dart';
import '../engine/nursery_persistence_adapter.dart';
import '../shared/nursery_lesson_content_adapter.dart';
import '../shared/nursery_module_config.dart';
import 'fruits_completion_screen.dart';

final NurseryModuleConfig<FruitItem> fruitsModuleConfig =
    NurseryModuleConfig<FruitItem>(
      moduleId: 'fruits',
      title: 'Fruits',
      totalLessons: nurseryFruits.length,
      progressKey: 'fruits_progress',
      lessonDataSource: nurseryFruits,
      completionRoute: _fruitsCompletionRouteBuilder,
      lessonScreenBuilder: _fruitsLessonScreenBuilder,
      gridRouteBuilder: _fruitsGridRouteBuilder,
      persistenceAdapter: AggregateNurseryPersistenceAdapter(
        progressKey: 'fruits_progress',
        totalLessons: nurseryFruits.length,
        completedKey: 'fruits_completed',
        lastIndexKey: 'fruits_last_index',
      ),
      lessonContentAdapter: fruitToLessonContent,
    );

Widget _fruitsCompletionRouteBuilder(BuildContext context) {
  return const FruitsCompletionScreen();
}

Widget _fruitsLessonScreenBuilder(
  BuildContext context,
  List<FruitItem> lessonDataSource,
  int initialIndex,
) {
  return NurseryEngineLessonScreen<FruitItem>(
    config: fruitsModuleConfig,
    initialIndex: initialIndex,
  );
}

Widget _fruitsGridRouteBuilder(BuildContext context) {
  return NurseryEngineGridScreen<FruitItem>(
    config: fruitsModuleConfig,
  );
}
