import 'package:flutter/material.dart';
import '../services/progress_service.dart';
import 'alphabet_list_screen.dart';
import 'numbers_list_screen.dart';
import 'shapes_list_screen.dart';
import '../services/shapes_progress_service.dart';

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

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final alphaDone = await ProgressService.isAlphabetFullyCompleted();
    final numbersDone = await ProgressService.isNumbersFullyCompleted();
    final shapesDone = await ShapesProgressService.isShapesFullyCompleted();

    if (!mounted) return;

    setState(() {
      _alphaCompleted = alphaDone;
      _numbersCompleted = numbersDone;
      _shapesCompleted = shapesDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nursery Learning"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,

          // ⭐ SAFE UNIVERSAL RATIO
          childAspectRatio: 0.78,

          children: [
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
            _lockedTile("Shapes", Colors.purple),
            _lockedTile("Colours", Colors.teal),
            _lockedTile("Animals", Colors.green),
            _lockedTile("Fruits", Colors.redAccent),
          ],
        ),
      ),
    );
  }

  Widget _lockedTile(String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.lock, size: 44, color: Colors.white),
          SizedBox(height: 12),
          Text(
            "Coming Soon",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

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
      reverseDuration: const Duration(milliseconds: 160),
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
                    borderRadius: BorderRadius.circular(26),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.color.withOpacity(0.95),
                        widget.color,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.22),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 18,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            widget.imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // ✅ completion badge
                if (widget.isCompleted)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      height: 30,
                      width: 30,
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
                        size: 18,
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