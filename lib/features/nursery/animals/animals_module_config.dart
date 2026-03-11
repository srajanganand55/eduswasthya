import 'package:flutter/material.dart';

import '../../../content/animals_data.dart';
import '../engine/nursery_persistence_adapter.dart';
import '../shared/nursery_lesson_content_adapter.dart';
import '../shared/nursery_module_config.dart';
import 'animal_completion_screen.dart';
import 'animal_lesson_screen.dart';
import 'animals_grid_screen.dart';
import 'animals_progress_service.dart';

final NurseryModuleConfig<AnimalItem> animalsModuleConfig =
    NurseryModuleConfig<AnimalItem>(
      moduleId: 'animals',
      title: 'Animals',
      totalLessons: nurseryAnimals.length,
      progressKey: AnimalsProgressService.progressKey,
      lessonDataSource: nurseryAnimals,
      completionRoute: _animalsCompletionRouteBuilder,
      lessonScreenBuilder: _animalsLessonScreenBuilder,
      gridRouteBuilder: _animalsGridRouteBuilder,
      persistenceAdapter: AggregateNurseryPersistenceAdapter(
        progressKey: AnimalsProgressService.progressKey,
        totalLessons: nurseryAnimals.length,
        completedKey: 'animals_completed',
        lastIndexKey: 'animals_last_index',
      ),
      lessonContentAdapter: animalToLessonContent,
    );

Widget _animalsCompletionRouteBuilder(BuildContext context) {
  return const AnimalCompletionScreen();
}

Widget _animalsLessonScreenBuilder(
  BuildContext context,
  List<AnimalItem> lessonDataSource,
  int initialIndex,
) {
  return AnimalLessonScreen(
    animals: lessonDataSource,
    initialIndex: initialIndex,
  );
}

Widget _animalsGridRouteBuilder(BuildContext context) {
  return const AnimalsGridScreen();
}
