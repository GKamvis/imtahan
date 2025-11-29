import 'package:equatable/equatable.dart';

class Exam extends Equatable {
  final int id;
  final String dersKodu;
  final String? dersAdi;
  final int sagirdNomresi;
  final String? sagirdAdi;
  final String? sagirdSoyadi;
  final DateTime imtahanTarixi;
  final int qiymet;

  const Exam({
    required this.id,
    required this.dersKodu,
    this.dersAdi,
    required this.sagirdNomresi,
    this.sagirdAdi,
    this.sagirdSoyadi,
    required this.imtahanTarixi,
    required this.qiymet,
  });

  @override
  List<Object?> get props => [
    id,
    dersKodu,
    dersAdi,
    sagirdNomresi,
    sagirdAdi,
    sagirdSoyadi,
    imtahanTarixi,
    qiymet,
  ];
}
