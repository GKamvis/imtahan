import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lesson_repository.dart';
part 'lesson_list_state.dart';


class LessonListCubit extends Cubit<LessonListState> {
  final LessonRepository repository;

  LessonListCubit(this.repository) : super(const LessonListState());

  Future<void> loadLessons() async {
    emit(state.copyWith(status: LessonListStatus.loading));

    try {
      final lessons = await repository.getLessons();
      emit(state.copyWith(
        status: LessonListStatus.success,
        lessons: lessons,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LessonListStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
