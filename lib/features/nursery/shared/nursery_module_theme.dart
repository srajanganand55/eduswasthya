import 'package:flutter/material.dart';

const Map<String, Color> nurseryModuleThemeColors = <String, Color>{
  'alphabets': Colors.orange,
  'numbers': Colors.blue,
  'shapes': Colors.purple,
  'colours': Colors.teal,
  'animals': Colors.green,
  'fruits': Colors.deepOrangeAccent,
  'vehicles': Colors.lightBlue,
  'rhymes': Colors.indigo,
  'progress': Colors.brown,
};

Color nurseryModuleColor(String moduleId) {
  return nurseryModuleThemeColors[moduleId] ?? const Color(0xFF1F8A9E);
}

Color nurseryModuleSurface(String moduleId) {
  return nurseryModuleColor(moduleId).withOpacity(0.06);
}

Color nurseryModuleStage(String moduleId) {
  return nurseryModuleColor(moduleId).withOpacity(0.12);
}

List<Color> nurseryModuleGradient(String moduleId) {
  final color = nurseryModuleColor(moduleId);
  return <Color>[
    color.withOpacity(0.22),
    color.withOpacity(0.08),
  ];
}

Color nurseryModuleAccentText(String moduleId) {
  final color = nurseryModuleColor(moduleId);
  return Color.lerp(color, Colors.black, 0.18) ?? color;
}
