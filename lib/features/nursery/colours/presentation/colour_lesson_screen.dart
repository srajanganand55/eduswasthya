import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../data/colour_item.dart';
import '../services/colours_progress_service.dart';
import 'colours_complete_screen.dart';

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
  late FlutterTts _tts;
  late int _currentIndex;
  bool _isSpeaking = false;

  ColourItem get colour => widget.colours[_currentIndex];

  bool get _isFirst => _currentIndex == 0;
  bool get _isLast => _currentIndex == widget.colours.length - 1;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _initTts();

    // ⭐ mark current colour complete
    _markCompleted();

    // ⭐ IMPORTANT: store NEXT index (not current)
    _storeNextIndex();

    _speakColour();
  }

  // ============================================================
  // TTS
  // ============================================================

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

  // ============================================================
  // PROGRESS
  // ============================================================

  Future<void> _markCompleted() async {
    await ColoursProgressService.markColourCompleted(colour.id);
  }

  /// ⭐ ALWAYS store the NEXT colour to learn
  Future<void> _storeNextIndex() async {
    int nextIndex = _currentIndex + 1;

    if (nextIndex >= widget.colours.length) {
      nextIndex = widget.colours.length;
    }

    await ColoursProgressService.setLastIndex(nextIndex);
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  // ✅ NEXT (FULLY FIXED)
  Future<void> _next() async {
    await _markCompleted();

    // ⭐ LAST ITEM → COMPLETION
    if (_isLast) {
      await ColoursProgressService.setLastIndex(widget.colours.length);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ColoursCompleteScreen(),
        ),
      );
      return;
    }

    // ⭐ MOVE FORWARD
    final nextIndex = _currentIndex + 1;

    setState(() => _currentIndex = nextIndex);

    await ColoursProgressService.setLastIndex(nextIndex + 1);
    await _markCompleted();

    _speakColour();
  }

  // ✅ PREVIOUS (SAFE)
  Future<void> _previous() async {
    if (_isFirst) return;

    final prevIndex = _currentIndex - 1;

    setState(() => _currentIndex = prevIndex);

    // ⭐ store correct next index after going back
    await ColoursProgressService.setLastIndex(prevIndex + 1);

    await _markCompleted();
    _speakColour();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final softColor = _getSoftColour(colour.id);

    return Scaffold(
      appBar: AppBar(title: Text(colour.name)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              const Spacer(),

              // ⭐ IMAGE CARD
              GestureDetector(
                onTap: _speakColour,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.42,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(
                      colors: [
                        softColor.withOpacity(0.25),
                        softColor.withOpacity(0.08),
                      ],
                    ),
                  ),
                  child: Image.asset(
                    colour.imagePath,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ⭐ COLOUR NAME
              Text(
                colour.name,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: _getStrongColour(colour.id),
                ),
              ),

              const Spacer(),

              // ⭐ NAV
              Row(
                children: [
                  Expanded(
                    child: _PillNavButton(
                      label: "Previous",
                      enabled: !_isFirst,
                      enabledColor: Colors.orange,
                      disabledColor: Colors.grey.shade400,
                      onTap: _previous,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _PillNavButton(
                      label: "Next",
                      enabled: true,
                      enabledColor: const Color(0xFF1F8A9E),
                      disabledColor: Colors.grey.shade400,
                      onTap: _next,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // COLOR MAPS
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
    switch (id) {
      case 'yellow':
        return Colors.orange.shade800;
      default:
        return _getSoftColour(id);
    }
  }
}

// ============================================================
// BUTTON
// ============================================================

class _PillNavButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final Color enabledColor;
  final Color disabledColor;
  final VoidCallback onTap;

  const _PillNavButton({
    required this.label,
    required this.enabled,
    required this.enabledColor,
    required this.disabledColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = enabled ? enabledColor : disabledColor;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(32),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.deepPurple,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}