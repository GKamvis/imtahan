import '../../domain/entities/student.dart';

class StudentModel extends Student {
  const StudentModel({
    required super.nomre,
    required super.adi,
    required super.soyadi,
    required super.sinif,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      nomre: int.parse(json['nomre'].toString()),
      adi: json['adi'] ?? '',
      soyadi: json['soyadi'] ?? '',
      sinif: int.parse(json['sinif'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomre': nomre,
      'adi': adi,
      'soyadi': soyadi,
      'sinif': sinif,
    };
  }
}
