class ApiException implements Exception {
  final String message;
  final int? httpStatus;

  /// 서버가 내려주는 "code" 같은 앱 레벨 에러코드(있으면)
  final int? appStatusCode;

  /// 서버 응답 바디 원문(있으면) - 스펙 불일치/파싱 이슈 확인용
  final Object? raw;

  /// 디버깅을 위해 요청 정보도 같이 들고 있으면 편함
  final String? path;
  final String? method;

  const ApiException({
    required this.message,
    this.httpStatus,
    this.appStatusCode,
    this.raw,
    this.path,
    this.method,
  });

  @override
  String toString() {
    return 'ApiException(message: $message, httpStatus: $httpStatus, appStatusCode: $appStatusCode, method: $method, path: $path, raw: $raw)';
  }
}
