import '../../../../core/error/exceptions.dart';
import '../../domain/entities/exam.dart';
import '../../domain/repositories/exam_repository.dart';
import '../datasources/exam_remote_data_source.dart';
import '../models/exam_model.dart';

class ExamRepositoryImpl implements ExamRepository {
  final ExamRemoteDataSource remoteDataSource;

  ExamRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Exam>> getExams() async {
    try {
      return await remoteDataSource.getExams();
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<List<Exam>> getExamsByStudent(int sagirdNomresi) async {
    try {
      return await remoteDataSource.getExamsByStudent(sagirdNomresi);
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<List<Exam>> getExamsByLesson(String dersKodu) async {
    try {
      return await remoteDataSource.getExamsByLesson(dersKodu);
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<void> createExam(Exam exam) async {
    final model = ExamModel(
      id: exam.id,
      dersKodu: exam.dersKodu,
      dersAdi: exam.dersAdi,
      sagirdNomresi: exam.sagirdNomresi,
      sagirdAdi: exam.sagirdAdi,
      sagirdSoyadi: exam.sagirdSoyadi,
      imtahanTarixi: exam.imtahanTarixi,
      qiymet: exam.qiymet,
    );
    await remoteDataSource.createExam(model);
  }

  @override
  Future<void> updateExam(Exam exam) async {
    final model = ExamModel(
      id: exam.id,
      dersKodu: exam.dersKodu,
      dersAdi: exam.dersAdi,
      sagirdNomresi: exam.sagirdNomresi,
      sagirdAdi: exam.sagirdAdi,
      sagirdSoyadi: exam.sagirdSoyadi,
      imtahanTarixi: exam.imtahanTarixi,
      qiymet: exam.qiymet,
    );
    await remoteDataSource.updateExam(model);
  }

  @override
  Future<void> deleteExam(int id) async {
    await remoteDataSource.deleteExam(id);
  }
}
