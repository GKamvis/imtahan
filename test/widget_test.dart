
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:imtahan/features/dashboard/presentation/pages/admin_dashboard_page.dart';

import 'package:imtahan/features/students/domain/entities/student.dart';
import 'package:imtahan/features/students/domain/repositories/student_repository.dart';
import 'package:imtahan/features/students/presentation/cubit/student_list_cubit.dart';
import 'package:imtahan/features/students/presentation/pages/student_list_page.dart';

import 'package:imtahan/features/imtahanlar/domain/entities/exam.dart';
import 'package:imtahan/features/imtahanlar/domain/repositories/exam_repository.dart';

import 'package:imtahan/features/dersler/domain/entities/lesson.dart';
import 'package:imtahan/features/dersler/domain/repositories/lesson_repository.dart';

void main() {


  // --- TEST 1: Dashboard açılır və menyu itemləri görünür ---

  testWidgets('AdminDashboardPage menyu düymələrini göstərir',
  (WidgetTester tester) async {
  // Fake repos
  final studentRepo = FakeStudentRepository();
  final examRepo = FakeExamRepository();
  final lessonRepo = FakeLessonRepository();

  await tester.pumpWidget(
  MultiRepositoryProvider(
  providers: [
  RepositoryProvider<StudentRepository>.value(value: studentRepo),
  RepositoryProvider<ExamRepository>.value(value: examRepo),
  RepositoryProvider<LessonRepository>.value(value: lessonRepo),
  ],
  child: const MaterialApp(
  home: AdminDashboardPage(),
  ),
  ),
  );

  // Dashboard button yazıları görünməlidir
  expect(find.text('Şagirdlər'), findsOneWidget);
  expect(find.text('İmtahanlar'), findsOneWidget);
  expect(find.text('Dərslər'), findsOneWidget);
  });

  // --- TEST 2: Şagirdlər düyməsinə klik -> StudentListPage açılır ---

  testWidgets('Dashboard-dan Şagirdlər səhifəsinə navigasiya',
  (WidgetTester tester) async {
  final studentRepo = FakeStudentRepository();
  final examRepo = FakeExamRepository();
  final lessonRepo = FakeLessonRepository();

  await tester.pumpWidget(
  MultiRepositoryProvider(
  providers: [
  RepositoryProvider<StudentRepository>.value(value: studentRepo),
  RepositoryProvider<ExamRepository>.value(value: examRepo),
  RepositoryProvider<LessonRepository>.value(value: lessonRepo),
  ],
  child: const MaterialApp(
  home: AdminDashboardPage(),
  ),
  ),
  );

  // "Şagirdlər" kartına tap + tap
  final studentsButtonFinder = find.text('Şagirdlər');
  expect(studentsButtonFinder, findsOneWidget);

  await tester.tap(studentsButtonFinder);
  await tester.pumpAndSettle();

  // Yönləndikdən sonra StudentListPage olmalıdır
  expect(find.byType(StudentListPage), findsOneWidget);
  });

  // --- TEST 3: StudentListPage fake repository-dən gələn şagirdləri göstərir ---

  testWidgets('StudentListPage şagirdləri siyahıda göstərir',
  (WidgetTester tester) async {
  final studentRepo = FakeStudentRepository();

  await tester.pumpWidget(
  RepositoryProvider<StudentRepository>.value(
  value: studentRepo,
  child: BlocProvider(
  create: (_) => StudentListCubit(studentRepo)..loadStudents(),
  child: const MaterialApp(
  home: StudentListPage(),
  ),
  ),
  ),
  );

  // async əməliyyatın bitməsini gözləyək
  await tester.pumpAndSettle();

  // Fake repo-dan gələn adlar siyahıda görünməlidir
  expect(find.text('Ali Aliyev'), findsOneWidget);
  expect(find.text('Nigar Quliyeva'), findsOneWidget);
  });
}



  class FakeStudentRepository implements StudentRepository {
  final List<Student> _students = const [
  Student(nomre: 10001, adi: 'Ali', soyadi: 'Aliyev', sinif: 9),
  Student(nomre: 10002, adi: 'Nigar', soyadi: 'Quliyeva', sinif: 9),
  ];

  @override
  Future<void> createStudent(Student student) async {
  // testdə sadəlik üçün heç nə eləmirik
  }

  @override
  Future<void> deleteStudent(int nomre) async {
  // test üçün sadə no-op
  }

  @override
  Future<List<Student>> getStudents() async {
  return _students;
  }

  @override
  Future<void> updateStudent(Student student) async {
  // test üçün no-op
  }
  }

class FakeExamRepository implements ExamRepository {
  final List<Exam> _exams = const [];

  @override
  Future<void> createExam(Exam exam) async {}

  @override
  Future<void> deleteExam(int id) async {}

  @override
  Future<List<Exam>> getExams() async => _exams;

  @override
  Future<List<Exam>> getExamsByLesson(String dersKodu) async => _exams;

  @override
  Future<List<Exam>> getExamsByStudent(int sagirdNomresi) async => _exams;

  @override
  Future<void> updateExam(Exam exam) async {}
}

class FakeLessonRepository implements LessonRepository {
  final List<Lesson> _lessons = const [
    Lesson(
      dersKodu: 'MAT',
      dersAdi: 'Riyaziyyat',
      sinif: 9,
      muellimAdi: 'Aygün',
      muellimSoyadi: 'Həsənova',
    ),
  ];

  @override
  Future<void> createLesson(Lesson lesson) async {}

  @override
  Future<void> deleteLesson(String dersKodu) async {}

  @override
  Future<List<Lesson>> getLessons() async => _lessons;

  @override
  Future<void> updateLesson(Lesson lesson) async {}
}
