import '../entities/exam.dart';

abstract class ExamRepository {
  Future<List<Exam>> getExams();
  Future<List<Exam>> getExamsByStudent(int sagirdNomresi);
  Future<List<Exam>> getExamsByLesson(String dersKodu);
  Future<void> createExam(Exam exam);
  Future<void> updateExam(Exam exam);
  Future<void> deleteExam(int id);
}
