part of 'student_list_cubit.dart';

enum StudentListStatus { initial, loading, success, failure }

class StudentListState extends Equatable {
  final StudentListStatus status;
  final List<Student> students;
  final String? errorMessage;

  const StudentListState({
    this.status = StudentListStatus.initial,
    this.students = const [],
    this.errorMessage,
  });

  StudentListState copyWith({
    StudentListStatus? status,
    List<Student>? students,
    String? errorMessage,
  }) {
    return StudentListState(
      status: status ?? this.status,
      students: students ?? this.students,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, students, errorMessage];
}
