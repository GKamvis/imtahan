part of 'exam_form_cubit.dart';

enum ExamFormStatus { initial, loading, ready, submitting, success, failure }

class ExamFormState extends Equatable {
  final ExamFormStatus status;
  final List<Student> students;
  final List<Lesson> lessons;

  final Student? selectedStudent;
  final Lesson? selectedLesson;
  final DateTime? selectedDate;
  final int? qiymet;

  final String? errorMessage;

  final bool isEditing;
  final Exam? initialExam;

  const ExamFormState({
    this.status = ExamFormStatus.initial,
    this.students = const [],
    this.lessons = const [],
    this.selectedStudent,
    this.selectedLesson,
    this.selectedDate,
    this.qiymet,
    this.errorMessage,
    this.isEditing = false,
    this.initialExam,
  });

  ExamFormState copyWith({
    ExamFormStatus? status,
    List<Student>? students,
    List<Lesson>? lessons,
    Student? selectedStudent,
    Lesson? selectedLesson,
    DateTime? selectedDate,
    int? qiymet,
    String? errorMessage,
  }) {
    return ExamFormState(
      status: status ?? this.status,
      students: students ?? this.students,
      lessons: lessons ?? this.lessons,
      selectedStudent: selectedStudent ?? this.selectedStudent,
      selectedLesson: selectedLesson ?? this.selectedLesson,
      selectedDate: selectedDate ?? this.selectedDate,
      qiymet: qiymet ?? this.qiymet,
      errorMessage: errorMessage,
      isEditing: isEditing,
      initialExam: initialExam,
    );
  }

  @override
  List<Object?> get props => [
    status,
    students,
    lessons,
    selectedStudent,
    selectedLesson,
    selectedDate,
    qiymet,
    errorMessage,
    isEditing,
    initialExam,
  ];
}
