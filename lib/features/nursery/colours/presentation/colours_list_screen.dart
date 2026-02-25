import 'package:flutter/material.dart';
import '../../../../main.dart';
import '../data/colours_data.dart';
import '../data/colour_item.dart';
import '../services/colours_progress_service.dart';
import 'colour_lesson_screen.dart';

class ColoursListScreen extends StatefulWidget {
  const ColoursListScreen({super.key});

  @override
  State<ColoursListScreen> createState() => _ColoursListScreenState();
}

class _ColoursListScreenState extends State<ColoursListScreen>
    with RouteAware {
  final List<ColourItem> colours = ColoursData.nurseryColours;

  Set<String> completedIds = {};
  int nextIndex = 0;
  bool showContinueBanner = false;

  // ============================================================
  // LIFECYCLE
  // ============================================================

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

  // ============================================================
  // PROGRESS LOADER (⭐ FIXED LOGIC)
  // ============================================================

  Future<void> _loadProgress() async {
    final done = <String>{};

    for (final c in colours) {
      final isDone =
          await ColoursProgressService.isColourCompleted(c.id);
      if (isDone) done.add(c.id);
    }

    // ⭐ compute NEXT pending index (correct behaviour)
    int next = 0;
    while (next < colours.length &&
        done.contains(colours[next].id)) {
      next++;
    }

    final partial =
        await ColoursProgressService.hasStartedButNotFinished();

    if (!mounted) return;

    setState(() {
      completedIds = done;
      nextIndex = next;
      showContinueBanner = partial && next < colours.length;
    });
  }

  Future<void> _openLesson(int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ColourLessonScreen(
          colours: colours,
          initialIndex: index,
        ),
      ),
    );

    _loadProgress();
  }

  bool _isUnlocked(int index) {
    return index == 0 ||
        completedIds.contains(colours[index - 1].id);
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Colours')),
      body: Column(
        children: [
          if (showContinueBanner)
            _ContinueBanner(
              colourName: colours[nextIndex].name,
              onTap: () => _openLesson(nextIndex),
            ),

          Expanded(
            child: GridView.builder(
              padding:
                  const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
                final tileColor = _getSoftColour(colour.id);
                final isDone =
                    completedIds.contains(colour.id);
                final unlocked = _isUnlocked(index);

                return GestureDetector(
                  onTap:
                      unlocked ? () => _openLesson(index) : null,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: [
                              tileColor.withOpacity(0.25),
                              tileColor.withOpacity(0.08),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.asset(
                                colour.imagePath,
                                fit: BoxFit.contain,
                                filterQuality:
                                    FilterQuality.high,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              colour.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color:
                                    _getStrongColour(colour.id),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (isDone)
                        const Positioned(
                          top: 10,
                          right: 10,
                          child: _DoneBadge(),
                        ),

                      if (!unlocked)
                        const Positioned(
                          top: 10,
                          left: 10,
                          child: Icon(Icons.lock,
                              color: Colors.white),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COLOR HELPERS
  // ============================================================

  Color _getSoftColour(String id) {
    switch (id) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.amber;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'brown':
        return Colors.brown;
      default:
        return Colors.teal;
    }
  }

  Color _getStrongColour(String id) {
    if (id == 'yellow') return Colors.orange.shade800;
    return _getSoftColour(id);
  }
}

// ============================================================
// CONTINUE BANNER (UNIFORM)
// ============================================================

class _ContinueBanner extends StatelessWidget {
  final String colourName;
  final VoidCallback onTap;

  const _ContinueBanner({
    required this.colourName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(Icons.school,
                size: 40, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Continue learning from $colourName",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: onTap,
              child: const Text("Start"),
            )
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DONE BADGE
// ============================================================

class _DoneBadge extends StatelessWidget {
  const _DoneBadge();

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.check_circle,
        color: Colors.green, size: 28);
  }
}