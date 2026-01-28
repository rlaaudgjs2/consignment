import '../models/auth_token_dto.dart';
import '../network/api_client.dart';
import '../network/api_response.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokenDto> login({required String phone});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _client;

  const AuthRemoteDataSourceImpl(this._client);

  @override
  Future<AuthTokenDto> login({required String phone}) async {
    final res = await _client.post(
      '/api/v1/auth/transporter/login',
      data: <String, dynamic>{'phone': phone},
    );

    final body = res.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('응답 형식이 올바르지 않습니다.');
    }

    final parsed = ApiResponse<AuthTokenDto>.fromJson(
      body,
      dataParser: (Object? json) {
        if (json is Map<String, dynamic>) return AuthTokenDto.fromJson(json);
        // data가 null/다른 타입일 경우
        return const AuthTokenDto(accessToken: '', grantType: '');
      },
    );

    return parsed.requireSuccessData();
  }
}
