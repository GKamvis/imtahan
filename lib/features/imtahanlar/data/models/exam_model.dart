import '../../domain/entities/exam.dart';

class ExamModel extends Exam {
  const ExamModel({
    required super.id,
    required super.dersKodu,
    super.dersAdi,
    required super.sagirdNomresi,
    super.sagirdAdi,
    super.sagirdSoyadi,
    required super.imtahanTarixi,
    required super.qiymet,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    // PHP JSON-da tarixi string kimi göndərir: "2025-01-20"
    final String dateStr = json['imtahan_tarixi']?.toString() ?? '';
    final DateTime date = DateTime.tryParse(dateStr) ?? DateTime.now();

    return ExamModel(
      id: int.parse(json['id'].toString()),
      dersKodu: json['ders_kodu'] ?? '',
      dersAdi: json['ders_adi'],
      sagirdNomresi: int.parse(
        (json['sagird_nomresi'] ?? json['sagird'] ?? '0').toString(),
      ),
      sagirdAdi: json['sagird_adi'],
      sagirdSoyadi: json['sagird_soyadi'],
      imtahanTarixi: date,
      qiymet: int.parse(json['qiymet'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ders_kodu': dersKodu,
      'sagird_nomresi': sagirdNomresi,
      'imtahan_tarixi':
      '${imtahanTarixi.year.toString().padLeft(4, '0')}-${imtahanTarixi.month.toString().padLeft(2, '0')}-${imtahanTarixi.day.toString().padLeft(2, '0')}',
      'qiymet': qiymet,
    };
  }
}
