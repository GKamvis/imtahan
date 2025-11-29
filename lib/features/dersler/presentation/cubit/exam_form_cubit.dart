import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../imtahanlar/domain/entities/exam.dart';
import '../../../imtahanlar/domain/repositories/exam_repository.dart';
import '../../../students/domain/entities/student.dart';
import '../../../students/domain/repositories/student_repository.dart';
import '../../../dersler/domain/entities/lesson.dart';
import '../../../dersler/domain/repositories/lesson_repository.dart';


part 'exam_form_state.dart';

class ExamFormCubit extends Cubit<ExamFormState> {
  final ExamRepository examRepository;
  final StudentRepository studentRepository;
  final LessonRepository lessonRepository;

  ExamFormCubit({
    required this.examRepository,
    required this.studentRepository,
    required this.lessonRepository,
    Exam? initialExam,
  }) : super(
    ExamFormState(
      isEditing: initialExam != null,
      initialExam: initialExam,
    ),
  );

  Future<void> loadInitialData() async {
    emit(state.copyWith(status: ExamFormStatus.loading));

    try {
      final students = await studentRepository.getStudents();
      final lessons = await lessonRepository.getLessons();

      Lesson? selectedLesson = state.selectedLesson;
      Student? selectedStudent = state.selectedStudent;
      DateTime? selectedDate = state.selectedDate;
      int? qiymet = state.qiymet;

      if (state.isEditing && state.initialExam != null) {
        final exam = state.initialExam!;
        selectedLesson = lessons.firstWhere(
              (l) => l.dersKodu == exam.dersKodu,
          orElse: () => lessons.isNotEmpty ? lessons.first : throw Exception('Dərs tapılmadı'),
        );
        selectedStudent = students.firstWhere(
              (s) => s.nomre == exam.sagirdNomresi,
          orElse: () => students.isNotEmpty ? students.first : throw Exception('Şagird tapılmadı'),
        );
        selectedDate = exam.imtahanTarixi;
        qiymet = exam.qiymet;
      }

      emit(state.copyWith(
        status: ExamFormStatus.ready,
        students: students,
        lessons: lessons,
        selectedLesson: selectedLesson,
        selectedStudent: selectedStudent,
        selectedDate: selectedDate,
        qiymet: qiymet,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ExamFormStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void changeLesson(Lesson? lesson) {
    emit(state.copyWith(selectedLesson: lesson));
  }

  void changeStudent(Student? student) {
    emit(state.copyWith(selectedStudent: student));
  }

  void changeDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void changeQiymet(int? qiymet) {
    emit(state.copyWith(qiymet: qiymet));
  }

  Future<void> submit() async {
    if (state.selectedLesson == null ||
        state.selectedStudent == null ||
        state.selectedDate == null ||
        state.qiymet == null) {
      emit(state.copyWith(
        status: ExamFormStatus.failure,
        errorMessage: 'Bütün xanaları doldurun.',
      ));
      return;
    }

    emit(state.copyWith(status: ExamFormStatus.submitting, errorMessage: null));

    try {
      final exam = Exam(
        id: state.initialExam?.id ?? 0, // create-də backend özü id verir
        dersKodu: state.selectedLesson!.dersKodu,
        dersAdi: state.selectedLesson!.dersAdi,
        sagirdNomresi: state.selectedStudent!.nomre,
        sagirdAdi: state.selectedStudent!.adi,
        sagirdSoyadi: state.selectedStudent!.soyadi,
        imtahanTarixi: state.selectedDate!,
        qiymet: state.qiymet!,
      );

      if (state.isEditing) {
        await examRepository.updateExam(exam);
      } else {
        await examRepository.createExam(exam);
      }

      emit(state.copyWith(status: ExamFormStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ExamFormStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
