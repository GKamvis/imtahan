import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lesson_repository.dart';

part 'lesson_form_state.dart';

class LessonFormCubit extends Cubit<LessonFormState> {
  final LessonRepository repository;

  LessonFormCubit({
    required this.repository,
    Lesson? initialLesson,
  }) : super(
    LessonFormState(
      isEditing: initialLesson != null,
      initialLesson: initialLesson,
      dersKodu: initialLesson?.dersKodu,
      dersAdi: initialLesson?.dersAdi,
      sinif: initialLesson?.sinif.toString(),
      muellimAdi: initialLesson?.muellimAdi,
      muellimSoyadi: initialLesson?.muellimSoyadi,
    ),
  );

  void changeDersKodu(String v) => emit(state.copyWith(dersKodu: v));
  void changeDersAdi(String v) => emit(state.copyWith(dersAdi: v));
  void changeSinif(String v) => emit(state.copyWith(sinif: v));
  void changeMuellimAdi(String v) => emit(state.copyWith(muellimAdi: v));
  void changeMuellimSoyadi(String v) =>
      emit(state.copyWith(muellimSoyadi: v));

  Future<void> submit() async {
    if (state.dersKodu == null ||
        state.dersAdi == null ||
        state.sinif == null ||
        state.dersKodu!.isEmpty ||
        state.dersAdi!.isEmpty ||
        state.sinif!.isEmpty) {
      emit(state.copyWith(
        status: LessonFormStatus.failure,
        errorMessage: 'Dərs kodu, adı və sinif boş ola bilməz.',
      ));
      return;
    }

    emit(state.copyWith(status: LessonFormStatus.submitting));

    try {
      final lesson = Lesson(
        dersKodu: state.dersKodu!,
        dersAdi: state.dersAdi!,
        sinif: int.parse(state.sinif!),
        muellimAdi: state.muellimAdi ?? '',
        muellimSoyadi: state.muellimSoyadi ?? '',
      );

      if (state.isEditing) {
        await repository.updateLesson(lesson);
      } else {
        await repository.createLesson(lesson);
      }

      emit(state.copyWith(status: LessonFormStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: LessonFormStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
