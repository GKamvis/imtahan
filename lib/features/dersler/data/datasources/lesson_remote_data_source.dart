import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/lesson_model.dart';

abstract class LessonRemoteDataSource {
  Future<List<LessonModel>> getLessons();
  Future<void> createLesson(LessonModel lesson);
  Future<void> updateLesson(LessonModel lesson);
  Future<void> deleteLesson(String dersKodu);
}

class LessonRemoteDataSourceImpl implements LessonRemoteDataSource {
  final ApiClient client;

  LessonRemoteDataSourceImpl(this.client);

  @override
  Future<List<LessonModel>> getLessons() async {
    final json = await client.get(ApiConfig.lessonsList);
    if (json is Map && json['success'] == true) {
      final List data = json['data'] ?? [];
      return data.map((e) => LessonModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<void> createLesson(LessonModel lesson) async {
    await client.post(
      ApiConfig.lessonsCreate,
      body: lesson.toJson(),
    );
  }

  @override
  Future<void> updateLesson(LessonModel lesson) async {
    await client.post(
      ApiConfig.lessonsUpdate,
      body: lesson.toJson(),
    );
  }

  @override
  Future<void> deleteLesson(String dersKodu) async {
    await client.get(
      ApiConfig.lessonsDelete,
      queryParams: {'ders_kodu': dersKodu},
    );
  }
}
