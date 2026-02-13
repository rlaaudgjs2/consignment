class DispatchCancelResultDto {
  final int dispatcherId;

  const DispatchCancelResultDto({
    required this.dispatcherId,
  });

  factory DispatchCancelResultDto.fromJson(Map<String, dynamic> json) {
    return DispatchCancelResultDto(
      dispatcherId: (json['dispatcherId'] as num?)?.toInt() ?? 0,
    );
  }
}
