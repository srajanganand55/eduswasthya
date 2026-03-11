import 'package:flutter/material.dart';

import '../../../core/learning/lesson_content.dart';
import '../engine/nursery_persistence_adapter.dart';

typedef NurseryLessonScreenBuilder<T> = Widget Function(
  BuildContext context,
  List<T> lessonDataSource,
  int initialIndex,
);

typedef NurseryGridRouteBuilder = Widget Function(BuildContext context);
typedef NurseryItemTextBuilder<T> = String Function(T item);
typedef NurseryLessonContentAdapter<T> = LessonContent Function(T item);

class NurseryModuleConfig<T> {
  final String moduleId;
  final String title;
  final int totalLessons;
  final String progressKey;
  final List<T> lessonDataSource;
  final WidgetBuilder completionRoute;
  final NurseryLessonScreenBuilder<T> lessonScreenBuilder;
  final NurseryGridRouteBuilder gridRouteBuilder;
  final NurseryPersistenceAdapter persistenceAdapter;
  final NurseryLessonContentAdapter<T>? lessonContentAdapter;
  final NurseryItemTextBuilder<T>? lessonTitleBuilder;
  final NurseryItemTextBuilder<T>? lessonImageBuilder;
  final NurseryItemTextBuilder<T>? lessonSoundBuilder;

  const NurseryModuleConfig({
    required this.moduleId,
    required this.title,
    required this.totalLessons,
    required this.progressKey,
    required this.lessonDataSource,
    required this.completionRoute,
    required this.lessonScreenBuilder,
    required this.gridRouteBuilder,
    required this.persistenceAdapter,
    this.lessonContentAdapter,
    this.lessonTitleBuilder,
    this.lessonImageBuilder,
    this.lessonSoundBuilder,
  });

  LessonContent toLessonContent(T item, {int? index}) {
    final adapter = lessonContentAdapter;
    if (adapter != null) {
      return adapter(item);
    }

    final titleBuilder = lessonTitleBuilder;
    final imageBuilder = lessonImageBuilder;
    final soundBuilder = lessonSoundBuilder;

    if (titleBuilder == null ||
        imageBuilder == null ||
        soundBuilder == null) {
      throw StateError(
        'NurseryModuleConfig for $moduleId requires either '
        'lessonContentAdapter or lesson title/image/sound builders.',
      );
    }

    final resolvedTitle = titleBuilder(item);

    return LessonContent(
      id: '${moduleId}_${index ?? lessonDataSource.indexOf(item)}',
      title: resolvedTitle,
      image: imageBuilder(item),
      ttsText: soundBuilder(item),
    );
  }
}
