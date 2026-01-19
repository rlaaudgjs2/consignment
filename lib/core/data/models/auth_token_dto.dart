class AuthTokenDto {
  final String accessToken;
  final String grantType;

  const AuthTokenDto({
    required this.accessToken,
    required this.grantType,
  });

  factory AuthTokenDto.fromJson(Map<String, dynamic> json) {
    return AuthTokenDto(
      accessToken: (json['accessToken'] as String?) ?? '',
      grantType: (json['grantType'] as String?) ?? '',
    );
  }
}
