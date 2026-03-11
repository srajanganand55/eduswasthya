import 'package:flutter/material.dart';

import '../../../content/animals_data.dart';
import '../../../main.dart';
import '../engine/nursery_lesson_engine.dart';
import '../shared/continue_learning_banner.dart';
import '../shared/nursery_module_theme.dart';
import '../shared/premium_module_card.dart';
import 'animals_module_config.dart';

class AnimalsGridScreen extends StatefulWidget {
  const AnimalsGridScreen({super.key});

  @override
  State<AnimalsGridScreen> createState() => _AnimalsGridScreenState();
}

class _AnimalsGridScreenState extends State<AnimalsGridScreen>
    with RouteAware {
  final NurseryLessonEngine<AnimalItem> _engine =
      NurseryLessonEngine<AnimalItem>(config: animalsModuleConfig);
  List<int> _completedLessons = <int>[];
  int _nextIndex = 0;
  bool _showContinueBanner = false;
  bool _isOpeningLesson = false;
  bool _isRestarting = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
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
      _showContinueBanner = partial && nextIndex < nurseryAnimals.length;
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

      if (!mounted) return;

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
            title: const Text('Restart Animals?'),
            content: const Text(
              'This will reset all Animals lesson progress.',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animals'),
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
              subjectTitle: 'Animals',
              nextLessonText: 'Continue with ${nurseryAnimals[_nextIndex].name}',
              iconColor: nurseryModuleAccentText('animals'),
              iconBackgroundColor: nurseryModuleStage('animals'),
              gradientColors: nurseryModuleGradient('animals'),
              buttonColor: nurseryModuleColor('animals'),
              subjectTextColor: nurseryModuleAccentText('animals'),
              nextLessonTextColor: nurseryModuleAccentText('animals'),
              onTap: _isOpeningLesson ? null : () => _openLesson(_nextIndex),
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
              physics: const BouncingScrollPhysics(),
              itemCount: nurseryAnimals.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 0.88,
              ),
              itemBuilder: (context, index) {
                final animal = nurseryAnimals[index];
                final isUnlocked = _isUnlocked(index);
                final isCompleted = _completedLessons.contains(index);

                return PremiumModuleCard(
                  title: animal.name,
                  gradientColors: nurseryModuleGradient('animals'),
                  titleStyle: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: nurseryModuleAccentText('animals'),
                  ),
                  isLocked: !isUnlocked,
                  isCompleted: isCompleted,
                  onTap: isUnlocked && !_isOpeningLesson
                      ? () => _openLesson(index)
                      : null,
                  visual: Image.asset(
                    animal.image,
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
