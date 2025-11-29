part of 'student_form_cubit.dart';

enum StudentFormStatus { initial, submitting, success, failure }

class StudentFormState extends Equatable {
  final StudentFormStatus status;

  final bool isEditing;
  final Student? initialStudent;

  final String? nomre;
  final String? adi;
  final String? soyadi;
  final String? sinif;

  final String? errorMessage;

  const StudentFormState({
    this.status = StudentFormStatus.initial,
    this.isEditing = false,
    this.initialStudent,
    this.nomre,
    this.adi,
    this.soyadi,
    this.sinif,
    this.errorMessage,
  });

  StudentFormState copyWith({
    StudentFormStatus? status,
    String? nomre,
    String? adi,
    String? soyadi,
    String? sinif,
    String? errorMessage,
  }) {
    return StudentFormState(
      status: status ?? this.status,
      isEditing: isEditing,
      initialStudent: initialStudent,
      nomre: nomre ?? this.nomre,
      adi: adi ?? this.adi,
      soyadi: soyadi ?? this.soyadi,
      sinif: sinif ?? this.sinif,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, isEditing, initialStudent, nomre, adi, soyadi, sinif, errorMessage];
}
