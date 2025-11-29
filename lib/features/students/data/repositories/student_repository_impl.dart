import '../../../../core/error/exceptions.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/student_remote_data_source.dart';
import '../models/student_model.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDataSource remoteDataSource;

  StudentRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Student>> getStudents() async {
    try {
      final list = await remoteDataSource.getStudents();
      return list;
    } on ServerException catch (e) {
      // burda istəsən log, snack, s. edə bilərsən
      rethrow;
    }
  }

  @override
  Future<void> createStudent(Student student) async {
    final model = StudentModel(
      nomre: student.nomre,
      adi: student.adi,
      soyadi: student.soyadi,
      sinif: student.sinif,
    );

    await remoteDataSource.createStudent(model);
  }

  @override
  Future<void> updateStudent(Student student) async {
    final model = StudentModel(
      nomre: student.nomre,
      adi: student.adi,
      soyadi: student.soyadi,
      sinif: student.sinif,
    );

    await remoteDataSource.updateStudent(model);
  }

  @override
  Future<void> deleteStudent(int nomre) async {
    await remoteDataSource.deleteStudent(nomre);
  }
}
