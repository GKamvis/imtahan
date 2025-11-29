import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/exam.dart';
import '../../domain/repositories/exam_repository.dart';

part 'exam_list_state.dart';

class ExamListCubit extends Cubit<ExamListState> {
  final ExamRepository repository;

  ExamListCubit(this.repository) : super(const ExamListState());

  Future<void> loadAll() async {
    emit(state.copyWith(status: ExamListStatus.loading));
    try {
      final exams = await repository.getExams();
      emit(state.copyWith(
        status: ExamListStatus.success,
        exams: exams,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ExamListStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadByStudent(int sagirdNomresi) async {
    emit(state.copyWith(status: ExamListStatus.loading));
    try {
      final exams = await repository.getExamsByStudent(sagirdNomresi);
      emit(state.copyWith(
        status: ExamListStatus.success,
        exams: exams,
        filterDescription: 'Şagird №$sagirdNomresi',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ExamListStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadByLesson(String dersKodu) async {
    emit(state.copyWith(status: ExamListStatus.loading));
    try {
      final exams = await repository.getExamsByLesson(dersKodu);
      emit(state.copyWith(
        status: ExamListStatus.success,
        exams: exams,
        filterDescription: 'Dərs $dersKodu',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ExamListStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
