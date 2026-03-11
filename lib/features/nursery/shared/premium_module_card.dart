import 'package:flutter/material.dart';

class PremiumModuleCard extends StatefulWidget {
  final Widget visual;
  final String title;
  final bool isLocked;
  final bool isCompleted;
  final VoidCallback? onTap;
  final List<Color> gradientColors;
  final TextStyle? titleStyle;
  final double lockedOpacity;

  const PremiumModuleCard({
    super.key,
    required this.visual,
    required this.title,
    required this.isLocked,
    required this.isCompleted,
    required this.onTap,
    this.gradientColors = const [
      Color(0xFFFFF8F0),
      Color(0xFFF3FAFC),
    ],
    this.titleStyle,
    this.lockedOpacity = 0.58,
  });

  @override
  State<PremiumModuleCard> createState() => _PremiumModuleCardState();
}

class _PremiumModuleCardState extends State<PremiumModuleCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 1, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (widget.onTap == null) return;
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final content = Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Center(child: widget.visual)),
              const SizedBox(height: 14),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: widget.titleStyle ??
                    const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF14323A),
                    ),
              ),
            ],
          ),
        ),
        if (widget.isCompleted)
          const Positioned(
            top: 12,
            right: 12,
            child: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 28,
            ),
          ),
        if (widget.isLocked)
          const Positioned(
            top: 12,
            left: 12,
            child: Icon(
              Icons.lock_rounded,
              color: Color(0xFF67757B),
            ),
          ),
      ],
    );

    return Opacity(
      opacity: widget.isLocked ? widget.lockedOpacity : 1,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Transform.scale(
            scale: _scale.value,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      colors: widget.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: content,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
