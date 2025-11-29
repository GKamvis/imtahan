import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/student_model.dart';

abstract class StudentRemoteDataSource {
  Future<List<StudentModel>> getStudents();
  Future<void> createStudent(StudentModel student);
  Future<void> updateStudent(StudentModel student);
  Future<void> deleteStudent(int nomre);
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final ApiClient client;

  StudentRemoteDataSourceImpl(this.client);

  @override
  Future<List<StudentModel>> getStudents() async {
    final json = await client.get(ApiConfig.studentsList);
    if (json is Map && json['success'] == true) {
      final List data = json['data'] ?? [];
      return data.map((e) => StudentModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<void> createStudent(StudentModel student) async {
    await client.post(
      ApiConfig.studentsCreate,
      body: student.toJson(),
    );
  }

  @override
  Future<void> updateStudent(StudentModel student) async {
    await client.post(
      ApiConfig.studentsUpdate,
      body: student.toJson(),
    );
  }

  @override
  Future<void> deleteStudent(int nomre) async {
    await client.get(
      ApiConfig.studentsDelete,
      queryParams: {'nomre': nomre.toString()},
    );
  }
}
