import 'package:flutter/material.dart';

import '../../../content/vehicles_data.dart';
import '../engine/nursery_engine_grid_screen.dart';
import '../engine/nursery_engine_lesson_screen.dart';
import '../engine/nursery_persistence_adapter.dart';
import '../shared/nursery_module_config.dart';
import 'vehicles_completion_screen.dart';
import 'vehicles_lesson_content_adapter.dart';

final NurseryModuleConfig<VehicleItem> vehiclesModuleConfig =
    NurseryModuleConfig<VehicleItem>(
      moduleId: 'vehicles',
      title: 'Vehicles',
      totalLessons: nurseryVehicles.length,
      progressKey: 'vehicles_progress',
      lessonDataSource: nurseryVehicles,
      completionRoute: _vehiclesCompletionRouteBuilder,
      lessonScreenBuilder: _vehiclesLessonScreenBuilder,
      gridRouteBuilder: _vehiclesGridRouteBuilder,
      persistenceAdapter: AggregateNurseryPersistenceAdapter(
        progressKey: 'vehicles_progress',
        totalLessons: nurseryVehicles.length,
        completedKey: 'vehicles_completed',
        lastIndexKey: 'vehicles_last_index',
      ),
      lessonContentAdapter: vehiclesLessonContentAdapter,
    );

Widget _vehiclesCompletionRouteBuilder(BuildContext context) {
  return const VehiclesCompletionScreen();
}

Widget _vehiclesLessonScreenBuilder(
  BuildContext context,
  List<VehicleItem> lessonDataSource,
  int initialIndex,
) {
  return NurseryEngineLessonScreen<VehicleItem>(
    config: vehiclesModuleConfig,
    initialIndex: initialIndex,
  );
}

Widget _vehiclesGridRouteBuilder(BuildContext context) {
  return NurseryEngineGridScreen<VehicleItem>(
    config: vehiclesModuleConfig,
  );
}
