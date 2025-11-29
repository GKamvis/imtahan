part of 'exam_list_cubit.dart';

enum ExamListStatus { initial, loading, success, failure }

class ExamListState extends Equatable {
  final ExamListStatus status;
  final List<Exam> exams;
  final String? errorMessage;
  final String? filterDescription;

  const ExamListState({
    this.status = ExamListStatus.initial,
    this.exams = const [],
    this.errorMessage,
    this.filterDescription,
  });

  ExamListState copyWith({
    ExamListStatus? status,
    List<Exam>? exams,
    String? errorMessage,
    String? filterDescription,
  }) {
    return ExamListState(
      status: status ?? this.status,
      exams: exams ?? this.exams,
      errorMessage: errorMessage ?? this.errorMessage,
      filterDescription: filterDescription ?? this.filterDescription,
    );
  }

  @override
  List<Object?> get props => [status, exams, errorMessage, filterDescription];
}
