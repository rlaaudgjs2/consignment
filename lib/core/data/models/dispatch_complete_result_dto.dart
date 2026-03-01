class DispatchCompleteResultDto {
  final int dispatcherId;
  final int transporterId;

  const DispatchCompleteResultDto({
    required this.dispatcherId,
    required this.transporterId,
  });

  factory DispatchCompleteResultDto.fromJson(Map<String, dynamic> json) {
    return DispatchCompleteResultDto(
      dispatcherId: (json['dispatcherId'] as num?)?.toInt() ?? 0,
      transporterId: (json['transporterId'] as num?)?.toInt() ?? 0,
    );
  }
}
