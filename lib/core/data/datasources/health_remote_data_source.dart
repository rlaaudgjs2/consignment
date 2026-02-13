import '../network/api_client.dart';
import '../network/api_response.dart';

abstract class HealthRemoteDataSource {
  Future<String> ping();
}

class HealthRemoteDataSourceImpl implements HealthRemoteDataSource {
  final ApiClient _client;

  const HealthRemoteDataSourceImpl(this._client);

  @override
  Future<String> ping() async {
    final res = await _client.get('/health/ping');

    final body = res.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('응답 형식이 올바르지 않습니다.');
    }

    final parsed = ApiResponse<String>.fromJson(
      body,
      dataParser: (Object? json) => (json is String) ? json : '',
    );

    return parsed.requireSuccessData();
  }
}
