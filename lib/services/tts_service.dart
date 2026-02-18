import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;

  TTSService._internal();

  final FlutterTts _tts = FlutterTts();

  Future init() async {
    await _tts.setLanguage("en-IN"); // Indian English
    await _tts.setSpeechRate(0.45);  // kid-friendly speed
    await _tts.setPitch(1.05);       // softer tone
    await _tts.setVolume(1.0);
  }

  Future speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  Future stop() async {
    await _tts.stop();
  }
}