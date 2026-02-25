import 'package:flutter/material.dart';
import '../services/progress_service.dart';
import '../services/shapes_progress_service.dart';
import 'alphabet_list_screen.dart';
import 'numbers_list_screen.dart';
import 'shapes_list_screen.dart';
import '../features/nursery/colours/presentation/colours_list_screen.dart';
import '../features/nursery/colours/services/colours_progress_service.dart';

class NurseryModulesScreen extends StatefulWidget {
  const NurseryModulesScreen({super.key});

  @override
  State<NurseryModulesScreen> createState() =>
      _NurseryModulesScreenState();
}

class _NurseryModulesScreenState extends State<NurseryModulesScreen> {
  bool _alphaCompleted = false;
  bool _numbersCompleted = false;
  bool _shapesCompleted = false;
  bool _coloursCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  // ✅ loads ALL module progress
  Future<void> _loadProgress() async {
    final alphaDone =
        await ProgressService.isAlphabetFullyCompleted();
    final numbersDone =
        await ProgressService.isNumbersFullyCompleted();
    final shapesDone =
        await ShapesProgressService.isShapesFullyCompleted();
    final coloursDone =
        await ColoursProgressService.isColoursFullyCompleted();

    if (!mounted) return;

    setState(() {
      _alphaCompleted = alphaDone;
      _numbersCompleted = numbersDone;
      _shapesCompleted = shapesDone;
      _coloursCompleted = coloursDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nursery Learning"),
        centerTitle: true,
      ),

      // ⭐⭐⭐ UPDATED BODY ⭐⭐⭐
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 0.92,
                children: [
                  // ✅ ALPHABETS
                  _PremiumTile(
                    title: "Alphabets",
                    color: Colors.orange,
                    imagePath: "assets/images/alphabets_icon.png",
                    isCompleted: _alphaCompleted,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AlphabetListScreen(),
                        ),
                      );
                      _loadProgress();
                    },
                  ),

                  // ✅ NUMBERS
                  _PremiumTile(
                    title: "Numbers",
                    color: Colors.blue,
                    imagePath: "assets/images/numbers_icon.png",
                    isCompleted: _numbersCompleted,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NumbersListScreen(),
                        ),
                      );
                      _loadProgress();
                    },
                  ),

                  // ✅ SHAPES
                  _PremiumTile(
                    title: "Shapes",
                    color: Colors.purple,
                    imagePath: "assets/images/shapes_icon.png",
                    isCompleted: _shapesCompleted,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShapesListScreen(),
                        ),
                      );
                      _loadProgress();
                    },
                  ),

                  // ✅ COLOURS
                  _PremiumTile(
                    title: "Colours",
                    color: Colors.teal,
                    imagePath: "assets/images/colours_icon.png",
                    isCompleted: _coloursCompleted,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ColoursListScreen(),
                        ),
                      );
                      _loadProgress();
                    },
                  ),

                  // 🔒 RHYMES (placeholder — ready for future)
                  _lockedTile("Rhymes", Colors.indigo),

                  // 🔒 PROGRESS REPORT (premium perception booster)
                  _lockedTile("Progress Report", Colors.brown),

                  // 🔒 FUTURE
                  _lockedTile("Animals", Colors.green),
                  _lockedTile("Fruits", Colors.redAccent),
                ],
              ),
            ),

            // ⭐ PREMIUM BOTTOM BACK BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F8A9E),
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    "Back to Classes",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LOCKED TILE =================

  Widget _lockedTile(String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, size: 44, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Coming Soon",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

//
// ================= PREMIUM TILE =================
//

class _PremiumTile extends StatefulWidget {
  final String title;
  final Color color;
  final String imagePath;
  final bool isCompleted;
  final VoidCallback onTap;

  const _PremiumTile({
    required this.title,
    required this.color,
    required this.imagePath,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  State<_PremiumTile> createState() => _PremiumTileState();
}

class _PremiumTileState extends State<_PremiumTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 180),
    );

    _scale = Tween(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _down(TapDownDetails _) => _controller.forward();

  void _up(TapUpDetails _) {
    _controller.reverse();
    widget.onTap();
  }

  void _cancel() => _controller.reverse();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _down,
      onTapUp: _up,
      onTapCancel: _cancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Transform.scale(
            scale: _scale.value,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.color.withOpacity(0.95),
                            widget.color.withOpacity(0.85),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 65,
                            child: Center(
                              child: Image.asset(
                                widget.imagePath,
                                height: 92,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 35,
                            child: Center(
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (widget.isCompleted)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
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
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}