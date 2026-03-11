import 'package:flutter/material.dart';

import '../../../content/animals_data.dart';
import '../../../services/tts_service.dart';
import '../engine/nursery_lesson_engine.dart';
import '../shared/lesson_nav_buttons.dart';
import '../shared/nursery_lesson_flow_controller.dart';
import '../shared/nursery_module_theme.dart';
import 'animals_module_config.dart';
import 'animals_progress_service.dart';

class AnimalLessonScreen extends StatefulWidget {
  final List<AnimalItem> animals;
  final int initialIndex;

  const AnimalLessonScreen({
    super.key,
    required this.animals,
    required this.initialIndex,
  });

  @override
  State<AnimalLessonScreen> createState() =>
      _AnimalLessonScreenState();
}

class _AnimalLessonScreenState extends State<AnimalLessonScreen> {
  final NurseryLessonEngine<AnimalItem> _engine =
      NurseryLessonEngine<AnimalItem>(config: animalsModuleConfig);
  late final NurseryLessonFlowController _flowController;
  bool _isNavigating = false;

  AnimalItem get _animal => widget.animals[_flowController.currentLessonIndex];
  bool get _isFirst => _flowController.isFirstLesson;
  bool get _isLast => _flowController.isLastLesson;

  @override
  void initState() {
    super.initState();
    _flowController = NurseryLessonFlowController(
      progressKey: AnimalsProgressService.progressKey,
      totalLessons: widget.animals.length,
      currentLessonIndex: widget.initialIndex,
      markLessonCompleted: AnimalsProgressService.completeLesson,
    );
    _initializeLesson();
  }

  Future<void> _initializeLesson() async {
    await _flowController.initializeFromContinueState(
      initialIndex: widget.initialIndex,
    );
    await _flowController.saveProgressOnAdvance();
    await _speakAnimal();
  }

  Future<void> _speakAnimal() async {
    try {
      await TTSService().speak(_animal.sound);
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
      await _speakAnimal();
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
      await _speakAnimal();
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
    return Scaffold(
      backgroundColor: nurseryModuleSurface('animals'),
      appBar: AppBar(
        title: Text(_animal.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
          child: Column(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: _speakAnimal,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: nurseryModuleStage('animals'),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(26),
                      child: Image.asset(
                        _animal.image,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                _animal.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: nurseryModuleAccentText('animals'),
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
