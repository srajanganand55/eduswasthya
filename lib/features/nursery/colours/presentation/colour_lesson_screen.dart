import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../data/colour_item.dart';

class ColourLessonScreen extends StatefulWidget {
  final ColourItem colour;

  const ColourLessonScreen({
    super.key,
    required this.colour,
  });

  @override
  State<ColourLessonScreen> createState() => _ColourLessonScreenState();
}

class _ColourLessonScreenState extends State<ColourLessonScreen> {
  late FlutterTts _tts;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    _speakColour(); // ✅ auto speak on open
  }

  Future<void> _initTts() async {
    _tts = FlutterTts();

    await _tts.setLanguage("en-IN");
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);

    _tts.setCompletionHandler(() {
      if (mounted) {
        setState(() => _isSpeaking = false);
      }
    });
  }

  Future<void> _speakColour() async {
    if (_isSpeaking) return;

    setState(() => _isSpeaking = true);
    await _tts.stop();
    await _tts.speak(widget.colour.name);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final softColor = _getSoftColour(widget.colour.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.colour.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              const Spacer(),

              // ✅ Big tappable image
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
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    widget.colour.imagePath,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ✅ Colour name
              Text(
                widget.colour.name,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Tap to hear again",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  // same soft palette as grid
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
}