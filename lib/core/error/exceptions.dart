class ServerException implements Exception {
  final String message;

  ServerException([this.message = 'Server xətası baş verdi']);

  @override
  String toString() => message;
}
