class AuthToken {
  final String accessToken;
  final String grantType;

  const AuthToken({
    required this.accessToken,
    required this.grantType,
  });

  String get authorizationHeaderValue => '$grantType $accessToken';
}
