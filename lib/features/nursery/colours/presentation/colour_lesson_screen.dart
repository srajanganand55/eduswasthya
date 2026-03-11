import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../colours_module_config.dart';
import '../../engine/nursery_lesson_engine.dart';
import '../../shared/lesson_nav_buttons.dart';
import '../../shared/nursery_lesson_flow_controller.dart';
import '../../shared/nursery_module_theme.dart';
import '../data/colour_item.dart';
import '../services/colours_progress_service.dart';

class ColourLessonScreen extends StatefulWidget {
  final List<ColourItem> colours;
  final int initialIndex;

  const ColourLessonScreen({
    super.key,
    required this.colours,
    required this.initialIndex,
  });

  @override
  State<ColourLessonScreen> createState() => _ColourLessonScreenState();
}

class _ColourLessonScreenState extends State<ColourLessonScreen> {
  final NurseryLessonEngine<ColourItem> _engine =
      NurseryLessonEngine<ColourItem>(config: coloursModuleConfig);
  late FlutterTts _tts;
  late final NurseryLessonFlowController _flowController;
  bool _isSpeaking = false;

  ColourItem get colour => widget.colours[_flowController.currentLessonIndex];

  bool get _isFirst => _flowController.isFirstLesson;
  bool get _isLast => _flowController.isLastLesson;

  @override
  void initState() {
    super.initState();
    _flowController = NurseryLessonFlowController(
      progressKey: 'nursery_colour_',
      totalLessons: widget.colours.length,
      currentLessonIndex: widget.initialIndex,
      markLessonCompleted: (index) {
        return ColoursProgressService.markColourCompleted(
          widget.colours[index].id,
        );
      },
      persistNextIndex: ColoursProgressService.setLastIndex,
    );
    _initTts();
    _initializeLesson();
    _speakColour();
  }

  Future<void> _initTts() async {
    _tts = FlutterTts();
    await _tts.setLanguage("en-IN");
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);

    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  Future<void> _speakColour() async {
    try {
      await _tts.stop();
      if (!mounted) return;

      setState(() => _isSpeaking = true);
      await Future.delayed(const Duration(milliseconds: 120));
      await _tts.speak(colour.name);
    } catch (_) {
      if (mounted) setState(() => _isSpeaking = false);
    }
  }

  Future<void> _initializeLesson() async {
    await _flowController.initializeFromContinueState(
      initialIndex: widget.initialIndex,
    );
    await _flowController.saveProgressOnAdvance();
    await ColoursProgressService.setLastIndex(
      _flowController.currentLessonIndex + 1 >= widget.colours.length
          ? widget.colours.length
          : _flowController.currentLessonIndex + 1,
    );
  }

  Future<void> _next() async {
    final shouldShowCompletion = await _flowController.nextLesson();

    if (shouldShowCompletion) {
      await ColoursProgressService.setLastIndex(widget.colours.length);

      if (!mounted) return;
      await _engine.replaceWithCompletion(context);
      return;
    }

    setState(() {});
    _speakColour();
  }

  Future<void> _previous() async {
    final moved = await _flowController.previousLesson();
    if (!moved) return;

    setState(() {});
    _speakColour();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: nurseryModuleSurface('colours'),
      appBar: AppBar(title: Text(colour.name)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: _speakColour,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: nurseryModuleStage('colours'),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Image.asset(
                        colour.imagePath,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                colour.name,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: nurseryModuleAccentText('colours'),
                ),
              ),
              const Spacer(),
              LessonNavButtons(
                onPrevious: !_isFirst ? _previous : null,
                onNext: _next,
                nextLabel: "Next",
                spacing: 20,
                buttonHeight: 64,
                borderRadius: 32,
                textStyle: const TextStyle(
                  color: Colors.teal,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
                previousEnabledTextColor: Colors.teal,
                previousDisabledTextColor: Colors.teal,
                nextTextColor: Colors.teal,
                previousDisabledColor: Colors.grey.shade400,
                nextDisabledColor: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
