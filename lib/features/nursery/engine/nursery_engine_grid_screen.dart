import 'package:flutter/material.dart';

import '../shared/continue_learning_banner.dart';
import '../shared/nursery_module_config.dart';
import '../shared/nursery_module_theme.dart';
import '../shared/premium_module_card.dart';
import 'nursery_lesson_engine.dart';

class NurseryEngineGridScreen<T> extends StatefulWidget {
  final NurseryModuleConfig<T> config;

  const NurseryEngineGridScreen({
    super.key,
    required this.config,
  });

  @override
  State<NurseryEngineGridScreen<T>> createState() =>
      _NurseryEngineGridScreenState<T>();
}

class _NurseryEngineGridScreenState<T>
    extends State<NurseryEngineGridScreen<T>> {
  late final NurseryLessonEngine<T> _engine;
  List<int> _completedLessons = <int>[];
  int _nextIndex = 0;
  bool _showContinueBanner = false;
  bool _isOpeningLesson = false;
  bool _isRestarting = false;

  @override
  void initState() {
    super.initState();
    _engine = NurseryLessonEngine<T>(config: widget.config);
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final completed = await _engine.getCompletedLessonIndices();
    final partial = await _engine.hasStartedButNotFinished();
    final nextIndex = await _engine.getNextLessonIndex();

    if (!mounted) return;

    setState(() {
      _completedLessons = completed;
      _nextIndex = nextIndex;
      _showContinueBanner =
          partial && nextIndex < widget.config.lessonDataSource.length;
    });
  }

  bool _isUnlocked(int index) {
    return _engine.isLessonUnlocked(_completedLessons, index);
  }

  Future<void> _openLesson(int index) async {
    if (_isOpeningLesson) return;

    setState(() {
      _isOpeningLesson = true;
    });

    try {
      await _engine.openLesson(context, index);
      await _loadProgress();
    } finally {
      if (!mounted) return;
      setState(() {
        _isOpeningLesson = false;
      });
    }
  }

  Future<void> _restartProgress() async {
    if (_isRestarting) return;

    final shouldRestart = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Restart ${widget.config.title}?'),
            content: Text(
              'This will reset all ${widget.config.title} lesson progress.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Restart'),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldRestart) return;

    setState(() {
      _isRestarting = true;
    });

    try {
      await _engine.resetModuleProgress();
      await _loadProgress();
    } finally {
      if (!mounted) return;
      setState(() {
        _isRestarting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final moduleId = widget.config.moduleId;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.config.title),
        actions: [
          IconButton(
            tooltip: 'Restart progress',
            onPressed: _isRestarting ? null : _restartProgress,
            icon: const Icon(Icons.restart_alt_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showContinueBanner)
            ContinueLearningBanner(
              subjectTitle: widget.config.title,
              nextLessonText: 'Continue with '
                  '${widget.config.toLessonContent(
                widget.config.lessonDataSource[_nextIndex],
                index: _nextIndex,
              ).title}',
              iconColor: nurseryModuleAccentText(moduleId),
              iconBackgroundColor: nurseryModuleStage(moduleId),
              gradientColors: nurseryModuleGradient(moduleId),
              buttonColor: nurseryModuleColor(moduleId),
              subjectTextColor: nurseryModuleAccentText(moduleId),
              nextLessonTextColor: nurseryModuleAccentText(moduleId),
              onTap: _isOpeningLesson ? null : () => _openLesson(_nextIndex),
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
              physics: const BouncingScrollPhysics(),
              itemCount: widget.config.lessonDataSource.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 0.88,
              ),
              itemBuilder: (context, index) {
                final item = widget.config.lessonDataSource[index];
                final content = widget.config.toLessonContent(
                  item,
                  index: index,
                );
                final isUnlocked = _isUnlocked(index);
                final isCompleted = _completedLessons.contains(index);

                return PremiumModuleCard(
                  title: content.title,
                  gradientColors: nurseryModuleGradient(moduleId),
                  titleStyle: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: nurseryModuleAccentText(moduleId),
                  ),
                  isLocked: !isUnlocked,
                  isCompleted: isCompleted,
                  onTap: isUnlocked && !_isOpeningLesson
                      ? () => _openLesson(index)
                      : null,
                  visual: Image.asset(
                    content.image,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
