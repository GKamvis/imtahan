import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final int nomre;
  final String adi;
  final String soyadi;
  final int sinif;

  const Student({
    required this.nomre,
    required this.adi,
    required this.soyadi,
    required this.sinif,
  });

  @override
  List<Object?> get props => [nomre, adi, soyadi, sinif];
}
