import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';

part 'student_form_state.dart';

class StudentFormCubit extends Cubit<StudentFormState> {
  final StudentRepository repository;

  StudentFormCubit({
    required this.repository,
    Student? initialStudent,
  }) : super(
    StudentFormState(
      isEditing: initialStudent != null,
      initialStudent: initialStudent,
      nomre: initialStudent?.nomre.toString(),
      adi: initialStudent?.adi,
      soyadi: initialStudent?.soyadi,
      sinif: initialStudent?.sinif.toString(),
    ),
  );

  void changeNomre(String value) {
    emit(state.copyWith(nomre: value));
  }

  void changeAdi(String value) {
    emit(state.copyWith(adi: value));
  }

  void changeSoyadi(String value) {
    emit(state.copyWith(soyadi: value));
  }

  void changeSinif(String value) {
    emit(state.copyWith(sinif: value));
  }

  Future<void> submit() async {
    if (state.nomre == null ||
        state.adi == null ||
        state.soyadi == null ||
        state.sinif == null ||
        state.nomre!.isEmpty ||
        state.adi!.isEmpty ||
        state.soyadi!.isEmpty ||
        state.sinif!.isEmpty) {
      emit(state.copyWith(
        status: StudentFormStatus.failure,
        errorMessage: "Bütün xanaları doldurun.",
      ));
      return;
    }

    emit(state.copyWith(status: StudentFormStatus.submitting));

    try {
      final student = Student(
        nomre: int.parse(state.nomre!),
        adi: state.adi!,
        soyadi: state.soyadi!,
        sinif: int.parse(state.sinif!),
      );

      if (state.isEditing) {
        await repository.updateStudent(student);
      } else {
        await repository.createStudent(student);
      }

      emit(state.copyWith(status: StudentFormStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: StudentFormStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
