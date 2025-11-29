import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/api_client.dart';
import 'features/students/data/datasources/student_remote_data_source.dart';
import 'features/students/data/repositories/student_repository_impl.dart';
import 'features/students/domain/repositories/student_repository.dart';
import 'features/imtahanlar/data/datasources/exam_remote_data_source.dart';
import 'features/imtahanlar/data/repositories/exam_repository_impl.dart';
import 'features/imtahanlar/domain/repositories/exam_repository.dart';
import 'features/dersler/data/datasources/lesson_remote_data_source.dart';
import 'features/dersler/data/repositories/lesson_repository_impl.dart';
import 'features/dersler/domain/repositories/lesson_repository.dart';
import 'features/dashboard/presentation/pages/admin_dashboard_page.dart';

void main() {
  final apiClient = ApiClient();

  // Repos
  final StudentRepository studentRepository =
  StudentRepositoryImpl(StudentRemoteDataSourceImpl(apiClient));

  final ExamRepository examRepository =
  ExamRepositoryImpl(ExamRemoteDataSourceImpl(apiClient));

  final LessonRepository lessonRepository =
  LessonRepositoryImpl(LessonRemoteDataSourceImpl(apiClient));

  runApp(
    MyApp(
      studentRepository: studentRepository,
      examRepository: examRepository,
      lessonRepository: lessonRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final StudentRepository studentRepository;
  final ExamRepository examRepository;
  final LessonRepository lessonRepository;

  const MyApp({
    super.key,
    required this.studentRepository,
    required this.examRepository,
    required this.lessonRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<StudentRepository>.value(value: studentRepository),
        RepositoryProvider<ExamRepository>.value(value: examRepository),
        RepositoryProvider<LessonRepository>.value(value: lessonRepository),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const AdminDashboardPage(),
      ),
    );
  }
}
