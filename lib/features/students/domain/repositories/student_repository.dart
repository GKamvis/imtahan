import 'package:dartz/dartz.dart'; // Əgər istəyirsənsə, yoxsa sadə Future atarıq
import '../../../../core/error/failures.dart';
import '../entities/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getStudents();
  Future<void> createStudent(Student student);
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(int nomre);
}
