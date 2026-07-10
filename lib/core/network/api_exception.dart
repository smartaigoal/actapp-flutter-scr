class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  ApiException({
    required this.message,
    this.statusCode,
    this.error,
  });

  @override
  String toString() => message;
}
