import '../entities/lesson.dart';

abstract class LessonRepository {
  Future<List<Lesson>> getLessons();
  Future<void> createLesson(Lesson lesson);
  Future<void> updateLesson(Lesson lesson);
  Future<void> deleteLesson(String dersKodu);
}
