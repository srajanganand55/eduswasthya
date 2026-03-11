import '../../../content/vehicles_data.dart';
import '../../../core/learning/lesson_content.dart';

LessonContent vehiclesLessonContentAdapter(VehicleItem item) {
  return LessonContent(
    id: item.name.toLowerCase(),
    title: item.name,
    image: item.image,
    ttsText: item.sound,
  );
}
