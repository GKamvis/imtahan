import '../../../../core/error/exceptions.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../datasources/lesson_remote_data_source.dart';
import '../models/lesson_model.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonRemoteDataSource remoteDataSource;

  LessonRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Lesson>> getLessons() async {
    try {
      return await remoteDataSource.getLessons();
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<void> createLesson(Lesson lesson) async {
    final model = LessonModel(
      dersKodu: lesson.dersKodu,
      dersAdi: lesson.dersAdi,
      sinif: lesson.sinif,
      muellimAdi: lesson.muellimAdi,
      muellimSoyadi: lesson.muellimSoyadi,
    );
    await remoteDataSource.createLesson(model);
  }

  @override
  Future<void> updateLesson(Lesson lesson) async {
    final model = LessonModel(
      dersKodu: lesson.dersKodu,
      dersAdi: lesson.dersAdi,
      sinif: lesson.sinif,
      muellimAdi: lesson.muellimAdi,
      muellimSoyadi: lesson.muellimSoyadi,
    );
    await remoteDataSource.updateLesson(model);
  }

  @override
  Future<void> deleteLesson(String dersKodu) async {
    await remoteDataSource.deleteLesson(dersKodu);
  }
}
