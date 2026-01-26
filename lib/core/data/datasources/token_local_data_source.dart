import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenLocalDataSource {
  Future<void> saveToken({
    required String accessToken,
    required String grantType,
  });

  Future<String?> readAccessToken();
  Future<String?> readGrantType();

  Future<void> clear();
}

class SecureTokenLocalDataSource implements TokenLocalDataSource {
  static const _kAccessToken = 'accessToken';
  static const _kGrantType = 'grantType';

  final FlutterSecureStorage _storage;

  const SecureTokenLocalDataSource({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> saveToken({
    required String accessToken,
    required String grantType,
  }) async {
    await _storage.write(key: _kAccessToken, value: accessToken);
    await _storage.write(key: _kGrantType, value: grantType);
  }

  @override
  Future<String?> readAccessToken() async {
    return _storage.read(key: _kAccessToken);
  }

  @override
  Future<String?> readGrantType() async {
    return _storage.read(key: _kGrantType);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _kAccessToken);
    await _storage.delete(key: _kGrantType);
  }
}
