import '../../../content/animals_data.dart';
import '../../../content/fruits_data.dart';
import '../../../core/learning/lesson_content.dart';
import '../colours/data/colour_item.dart';

LessonContent fruitToLessonContent(FruitItem item) {
  return LessonContent(
    id: item.name.toLowerCase(),
    title: item.name,
    image: item.image,
    ttsText: item.sound,
  );
}

LessonContent animalToLessonContent(AnimalItem item) {
  return LessonContent(
    id: item.name.toLowerCase(),
    title: item.name,
    image: item.image,
    ttsText: item.sound,
  );
}

LessonContent colourToLessonContent(ColourItem item) {
  return LessonContent(
    id: item.id,
    title: item.name,
    image: item.imagePath,
    ttsText: item.name,
  );
}
