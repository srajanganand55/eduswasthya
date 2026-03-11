import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../colours_module_config.dart';
import '../../engine/nursery_lesson_engine.dart';
import '../../shared/continue_learning_banner.dart';
import '../../shared/nursery_module_theme.dart';
import '../../shared/premium_module_card.dart';
import '../data/colour_item.dart';
import '../data/colours_data.dart';

class ColoursListScreen extends StatefulWidget {
  const ColoursListScreen({super.key});

  @override
  State<ColoursListScreen> createState() => _ColoursListScreenState();
}

class _ColoursListScreenState extends State<ColoursListScreen>
    with RouteAware {
  final NurseryLessonEngine<ColourItem> _engine =
      NurseryLessonEngine<ColourItem>(config: coloursModuleConfig);
  final List<ColourItem> colours = ColoursData.nurseryColours;

  List<int> completedIndexes = <int>[];
  Set<String> completedIds = {};
  int nextIndex = 0;
  bool showContinueBanner = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
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
    final done = completed.map((index) => colours[index].id).toSet();
    final next = await _engine.getNextLessonIndex();
    final partial = await _engine.hasStartedButNotFinished();

    if (!mounted) return;

    setState(() {
      completedIndexes = completed;
      completedIds = done;
      nextIndex = next;
      showContinueBanner = partial && next < colours.length;
    });
  }

  Future<void> _openLesson(int index) async {
    await _engine.openLesson(context, index);
    _loadProgress();
  }

  bool _isUnlocked(int index) {
    return _engine.isLessonUnlocked(completedIndexes, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Colours')),
      body: Column(
        children: [
          if (showContinueBanner)
            ContinueLearningBanner(
              subjectTitle: 'Colours',
              nextLessonText:
                  'Continue learning from ${colours[nextIndex].name}',
              icon: Icons.palette_rounded,
              iconColor: nurseryModuleAccentText('colours'),
              iconBackgroundColor: nurseryModuleStage('colours'),
              gradientColors: nurseryModuleGradient('colours'),
              buttonColor: nurseryModuleColor('colours'),
              subjectTextColor: nurseryModuleAccentText('colours'),
              nextLessonTextColor: nurseryModuleAccentText('colours'),
              onTap: () => _openLesson(nextIndex),
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              physics: const BouncingScrollPhysics(),
              itemCount: colours.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) {
                final colour = colours[index];
                final isDone = completedIds.contains(colour.id);
                final unlocked = _isUnlocked(index);

                return PremiumModuleCard(
                  title: colour.name,
                  titleStyle: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: nurseryModuleAccentText('colours'),
                  ),
                  gradientColors: nurseryModuleGradient('colours'),
                  isLocked: !unlocked,
                  isCompleted: isDone,
                  onTap: unlocked ? () => _openLesson(index) : null,
                  visual: Image.asset(
                    colour.imagePath,
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
