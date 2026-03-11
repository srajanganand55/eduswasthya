import 'package:flutter/material.dart';

import '../../../core/learning/lesson_content.dart';
import '../../../services/tts_service.dart';
import '../shared/lesson_nav_buttons.dart';
import '../shared/nursery_lesson_flow_controller.dart';
import '../shared/nursery_module_config.dart';
import '../shared/nursery_module_theme.dart';
import 'nursery_lesson_engine.dart';

class NurseryEngineLessonScreen<T> extends StatefulWidget {
  final NurseryModuleConfig<T> config;
  final int initialIndex;

  const NurseryEngineLessonScreen({
    super.key,
    required this.config,
    required this.initialIndex,
  });

  @override
  State<NurseryEngineLessonScreen<T>> createState() =>
      _NurseryEngineLessonScreenState<T>();
}

class _NurseryEngineLessonScreenState<T>
    extends State<NurseryEngineLessonScreen<T>> {
  late final NurseryLessonEngine<T> _engine;
  late final NurseryLessonFlowController _flowController;
  bool _isNavigating = false;

  T get _item =>
      widget.config.lessonDataSource[_flowController.currentLessonIndex];
  LessonContent get _content => widget.config.toLessonContent(
        _item,
        index: _flowController.currentLessonIndex,
      );
  bool get _isFirst => _flowController.isFirstLesson;
  bool get _isLast => _flowController.isLastLesson;

  @override
  void initState() {
    super.initState();
    _engine = NurseryLessonEngine<T>(config: widget.config);
    _flowController = NurseryLessonFlowController(
      progressKey: widget.config.progressKey,
      totalLessons: widget.config.totalLessons,
      currentLessonIndex: widget.initialIndex,
      markLessonCompleted: _engine.markLessonCompleted,
    );
    _initializeLesson();
  }

  Future<void> _initializeLesson() async {
    await _flowController.initializeFromContinueState(
      initialIndex: widget.initialIndex,
    );
    await _flowController.saveProgressOnAdvance();
    await _speakCurrentItem();
  }

  Future<void> _speakCurrentItem() async {
    try {
      await TTSService().speak(_content.ttsText);
    } catch (_) {}
  }

  Future<void> _goNext() async {
    if (_isNavigating) return;
    var navigatedToCompletion = false;

    setState(() {
      _isNavigating = true;
    });

    try {
      final shouldShowCompletion = await _flowController.nextLesson();

      if (shouldShowCompletion) {
        navigatedToCompletion = true;

        if (!mounted) return;

        await _engine.replaceWithCompletion(context);
        return;
      }

      if (!mounted) return;

      setState(() {});
      await _speakCurrentItem();
    } finally {
      if (!mounted || navigatedToCompletion) return;
      setState(() {
        _isNavigating = false;
      });
    }
  }

  Future<void> _goPrevious() async {
    if (_isFirst || _isNavigating) return;

    setState(() {
      _isNavigating = true;
    });

    try {
      final moved = await _flowController.previousLesson();
      if (!moved || !mounted) return;

      setState(() {});
      await _speakCurrentItem();
    } finally {
      if (!mounted) return;
      setState(() {
        _isNavigating = false;
      });
    }
  }

  @override
  void dispose() {
    TTSService().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moduleId = widget.config.moduleId;

    return Scaffold(
      backgroundColor: nurseryModuleSurface(moduleId),
      appBar: AppBar(
        title: Text(_content.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
          child: Column(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: _speakCurrentItem,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: nurseryModuleStage(moduleId),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(26),
                      child: Image.asset(
                        _content.image,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                _content.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: nurseryModuleAccentText(moduleId),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tap the picture to hear it again',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              LessonNavButtons(
                onPrevious: _isFirst || _isNavigating ? null : _goPrevious,
                onNext: _isNavigating ? null : _goNext,
                nextLabel: _isLast ? 'Finish' : 'Next',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
