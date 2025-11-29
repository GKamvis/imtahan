part of 'lesson_list_cubit.dart';

enum LessonListStatus { initial, loading, success, failure }

class LessonListState extends Equatable {
  final LessonListStatus status;
  final List<Lesson> lessons;
  final String? errorMessage;

  const LessonListState({
    this.status = LessonListStatus.initial,
    this.lessons = const [],
    this.errorMessage,
  });

  LessonListState copyWith({
    LessonListStatus? status,
    List<Lesson>? lessons,
    String? errorMessage,
  }) {
    return LessonListState(
      status: status ?? this.status,
      lessons: lessons ?? this.lessons,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, lessons, errorMessage];
}
