import 'package:imtahan/core/config/api_config.dart';
import 'package:imtahan/core/network/api_client.dart';

import '../models/exam_model.dart';

abstract class ExamRemoteDataSource {
  Future<List<ExamModel>> getExams();
  Future<List<ExamModel>> getExamsByStudent(int sagirdNomresi);
  Future<List<ExamModel>> getExamsByLesson(String dersKodu);
  Future<void> createExam(ExamModel exam);
  Future<void> updateExam(ExamModel exam);
  Future<void> deleteExam(int id);
}

class ExamRemoteDataSourceImpl implements ExamRemoteDataSource {
  final ApiClient client;

  ExamRemoteDataSourceImpl(this.client);

  @override
  Future<List<ExamModel>> getExams() async {
    final json = await client.get(ApiConfig.examsList);
    if (json is Map && json['success'] == true) {
      final List data = json['data'] ?? [];
      return data.map((e) => ExamModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<ExamModel>> getExamsByStudent(int sagirdNomresi) async {
    final json = await client.get(
      ApiConfig.examsByStudent,
      queryParams: {'sagird': sagirdNomresi.toString()},
    );
    if (json is Map && json['success'] == true) {
      final List data = json['data'] ?? [];
      return data.map((e) => ExamModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<ExamModel>> getExamsByLesson(String dersKodu) async {
    final json = await client.get(
      ApiConfig.examsByLesson,
      queryParams: {'ders_kodu': dersKodu},
    );
    if (json is Map && json['success'] == true) {
      final List data = json['data'] ?? [];
      return data.map((e) => ExamModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<void> createExam(ExamModel exam) async {
    await client.post(
      ApiConfig.examsCreate,
      body: exam.toJson(),
    );
  }

  @override
  Future<void> updateExam(ExamModel exam) async {
    await client.post(
      ApiConfig.examsUpdate,
      body: exam.toJson(),
    );
  }

  @override
  Future<void> deleteExam(int id) async {
    await client.get(
      ApiConfig.examsDelete,
      queryParams: {'id': id.toString()},
    );
  }
}
