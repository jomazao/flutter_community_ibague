class ServerException implements Exception {
  final String? message;
  final String? codeError;
  final int? status;

  ServerException({
    this.message,
    this.codeError,
    this.status,
  });
}
