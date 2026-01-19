class ApiException implements Exception {
  final String message;
  final int? httpStatus;
  final int? appStatusCode;

  const ApiException({
    required this.message,
    this.httpStatus,
    this.appStatusCode,
  });

  @override
  String toString() =>
      'ApiException(message: $message, httpStatus: $httpStatus, appStatusCode: $appStatusCode)';
}
