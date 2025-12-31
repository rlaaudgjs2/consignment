import '../domain/settlement_withdraw_result.dart';

class SettlementWithdrawSmsResultDto {
  final bool success;
  final String message;
  final int smsFeeAmount;

  const SettlementWithdrawSmsResultDto({
    required this.success,
    required this.message,
    required this.smsFeeAmount,
  });

  SettlementWithdrawSmsResult toEntity() {
    return SettlementWithdrawSmsResult(
      success: success,
      message: message,
      smsFeeAmount: smsFeeAmount,
    );
  }

  factory SettlementWithdrawSmsResultDto.fromJson(Map<String, dynamic> json) {
    return SettlementWithdrawSmsResultDto(
      success: (json['success'] ?? false) as bool,
      message: (json['message'] ?? '') as String,
      smsFeeAmount: (json['smsFeeAmount'] ?? 20) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'smsFeeAmount': smsFeeAmount,
    };
  }
}
