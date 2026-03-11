class LessonContent {
  final String id;
  final String title;
  final String image;
  final String ttsText;
  final String? example;
  final Object? practiceData;
  final String? revisionNote;
  final Map<String, Object?> metadata;

  const LessonContent({
    required this.id,
    required this.title,
    required this.image,
    required this.ttsText,
    this.example,
    this.practiceData,
    this.revisionNote,
    this.metadata = const <String, Object?>{},
  });
}
