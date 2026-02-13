import '../datasources/auth_remote_data_source.dart';
import '../datasources/token_local_data_source.dart';
import '../domain/auth_token.dart';

class AuthRepository {
  final AuthRemoteDataSource _remote;
  final TokenLocalDataSource _local;

  const AuthRepository({
    required AuthRemoteDataSource remote,
    required TokenLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  Future<AuthToken> login({required String phone}) async {
    final dto = await _remote.login(phone: phone);

    await _local.saveToken(
      accessToken: dto.accessToken,
      grantType: dto.grantType,
    );

    return AuthToken(
      accessToken: dto.accessToken,
      grantType: dto.grantType,
    );
  }
}
