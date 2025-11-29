import '../../domain/entities/lesson.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required super.dersKodu,
    required super.dersAdi,
    required super.sinif,
    required super.muellimAdi,
    required super.muellimSoyadi,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      dersKodu: json['ders_kodu'] ?? '',
      dersAdi: json['ders_adi'] ?? '',
      sinif: int.parse(json['sinif'].toString()),
      muellimAdi: json['muellim_adi'] ?? '',
      muellimSoyadi: json['muellim_soyadi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ders_kodu': dersKodu,
      'ders_adi': dersAdi,
      'sinif': sinif,
      'muellim_adi': muellimAdi,
      'muellim_soyadi': muellimSoyadi,
    };
  }
}
