import 'api_exception.dart';

class ApiResponse<T> {
  final int statusCode;
  final String message;
  final T? data;

  const ApiResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, {
        required T Function(Object? json) dataParser,
      }) {
    return ApiResponse<T>(
      statusCode: (json['statusCode'] as num?)?.toInt() ?? -1,
      message: (json['message'] as String?) ?? '',
      data: dataParser(json['data']),
    );
  }

  /// 서버 규칙: statusCode == 0 이 성공이라고 가정
  T requireSuccessData() {
    if (statusCode != 0) {
      throw ApiException(
        message: message.isNotEmpty ? message : '요청 처리에 실패했습니다.',
        appStatusCode: statusCode,
      );
    }
    if (data == null) {
      throw const ApiException(message: '응답 data가 비어있습니다.');
    }
    return data as T;
  }
}
