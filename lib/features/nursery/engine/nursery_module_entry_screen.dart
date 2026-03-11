import 'package:flutter/material.dart';

import '../shared/nursery_module_config.dart';
import 'nursery_lesson_engine.dart';

class NurseryModuleEntryScreen<T> extends StatelessWidget {
  final NurseryModuleConfig<T> config;

  const NurseryModuleEntryScreen({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final engine = NurseryLessonEngine<T>(config: config);
    return engine.buildGridRoute(context);
  }
}
