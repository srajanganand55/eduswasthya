import 'package:flutter/material.dart';

import '../engine/nursery_persistence_adapter.dart';
import 'data/colour_item.dart';
import 'data/colours_data.dart';
import 'presentation/colour_lesson_screen.dart';
import 'presentation/colours_complete_screen.dart';
import 'presentation/colours_list_screen.dart';
import '../shared/nursery_lesson_content_adapter.dart';
import '../shared/nursery_module_config.dart';

final NurseryModuleConfig<ColourItem> coloursModuleConfig =
    NurseryModuleConfig<ColourItem>(
      moduleId: 'colours',
      title: 'Colours',
      totalLessons: ColoursData.nurseryColours.length,
      progressKey: 'nursery_colour_',
      lessonDataSource: ColoursData.nurseryColours,
      completionRoute: _coloursCompletionRouteBuilder,
      lessonScreenBuilder: _coloursLessonScreenBuilder,
      gridRouteBuilder: _coloursGridRouteBuilder,
      persistenceAdapter: PerLessonNurseryPersistenceAdapter(
        progressKey: 'nursery_colour_',
        totalLessons: ColoursData.nurseryColours.length,
        lessonKeys: [
          'nursery_colour_red',
          'nursery_colour_blue',
          'nursery_colour_yellow',
          'nursery_colour_green',
          'nursery_colour_orange',
          'nursery_colour_purple',
          'nursery_colour_pink',
          'nursery_colour_brown',
        ],
        completedKey: 'nursery_colours_completed',
        lastIndexKey: 'nursery_colours_last_index',
      ),
      lessonContentAdapter: colourToLessonContent,
    );

Widget _coloursCompletionRouteBuilder(BuildContext context) {
  return const ColoursCompleteScreen();
}

Widget _coloursLessonScreenBuilder(
  BuildContext context,
  List<ColourItem> lessonDataSource,
  int initialIndex,
) {
  return ColourLessonScreen(
    colours: lessonDataSource,
    initialIndex: initialIndex,
  );
}

Widget _coloursGridRouteBuilder(BuildContext context) {
  return const ColoursListScreen();
}
