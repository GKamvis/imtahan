part of 'lesson_form_cubit.dart';

enum LessonFormStatus { initial, submitting, success, failure }

class LessonFormState extends Equatable {
  final LessonFormStatus status;
  final bool isEditing;
  final Lesson? initialLesson;

  final String? dersKodu;
  final String? dersAdi;
  final String? sinif;
  final String? muellimAdi;
  final String? muellimSoyadi;

  final String? errorMessage;

  const LessonFormState({
    this.status = LessonFormStatus.initial,
    this.isEditing = false,
    this.initialLesson,
    this.dersKodu,
    this.dersAdi,
    this.sinif,
    this.muellimAdi,
    this.muellimSoyadi,
    this.errorMessage,
  });

  LessonFormState copyWith({
    LessonFormStatus? status,
    String? dersKodu,
    String? dersAdi,
    String? sinif,
    String? muellimAdi,
    String? muellimSoyadi,
    String? errorMessage,
  }) {
    return LessonFormState(
      status: status ?? this.status,
      isEditing: isEditing,
      initialLesson: initialLesson,
      dersKodu: dersKodu ?? this.dersKodu,
      dersAdi: dersAdi ?? this.dersAdi,
      sinif: sinif ?? this.sinif,
      muellimAdi: muellimAdi ?? this.muellimAdi,
      muellimSoyadi: muellimSoyadi ?? this.muellimSoyadi,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isEditing,
    initialLesson,
    dersKodu,
    dersAdi,
    sinif,
    muellimAdi,
    muellimSoyadi,
    errorMessage,
  ];
}
