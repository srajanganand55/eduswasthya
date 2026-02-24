import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/colours_data.dart';
import '../data/colour_item.dart';
import '../services/colours_progress_service.dart';
import 'colour_lesson_screen.dart';

class ColoursListScreen extends StatefulWidget {
  const ColoursListScreen({super.key});

  @override
  State<ColoursListScreen> createState() => _ColoursListScreenState();
}

class _ColoursListScreenState extends State<ColoursListScreen> {
  final List<ColourItem> colours = ColoursData.nurseryColours;

  Set<String> completedIds = {};
  int? lastIndex;
  bool showContinueBanner = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final done = <String>{};

    for (final c in colours) {
      if (prefs.getBool('nursery_colour_${c.id}') ?? false) {
        done.add(c.id);
      }
    }

    final partial =
        await ColoursProgressService.hasStartedButNotFinished();
    final savedIndex =
        await ColoursProgressService.getLastIndex();

    if (!mounted) return;

    setState(() {
      completedIds = done;
      showContinueBanner = partial;
      lastIndex = savedIndex;
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

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Colours')),
      body: Column(
        children: [
          if (showContinueBanner && lastIndex != null)
            _ContinueBanner(
              colourName: colours[lastIndex!].name,
              onTap: () => _openLesson(lastIndex!),
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

                return GestureDetector(
                  onTap: () => _openLesson(index),
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
                        Positioned(
                          top: 10,
                          right: 10,
                          child: _DoneBadge(),
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

  // ================= COLOR HELPERS =================

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
    switch (id) {
      case 'yellow':
        return Colors.orange.shade800;
      default:
        return _getSoftColour(id);
    }
  }
}

// ================= CONTINUE BANNER =================

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
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF1F8A9E),
                Color(0xFF4FB6C2),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            "Continue Learning — $colourName",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

// ================= DONE BADGE =================

class _DoneBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
          ),
        ],
      ),
      child: const Icon(
        Icons.check,
        color: Colors.green,
        size: 22,
      ),
    );
  }
}