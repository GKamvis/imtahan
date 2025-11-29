import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  final String dersKodu;
  final String dersAdi;
  final int sinif;
  final String muellimAdi;
  final String muellimSoyadi;

  const Lesson({
    required this.dersKodu,
    required this.dersAdi,
    required this.sinif,
    required this.muellimAdi,
    required this.muellimSoyadi,
  });

  @override
  List<Object?> get props => [dersKodu, dersAdi, sinif, muellimAdi, muellimSoyadi];
}
