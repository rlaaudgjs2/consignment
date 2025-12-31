import 'package:consignment/core/data/settlement/domain/settlement_withdraw_sms_result.dart';

class SettlementWithdrawSmsResultDto {
  final bool success;
  final String message;
  final int smsFeeAmount;

  const SettlementWithdrawSmsResultDto({
    required this.success,
    required this.message,
    required this.smsFeeAmount,
  });

  factory SettlementWithdrawSmsResultDto.fromJson(Map<String, dynamic> json) {
    return SettlementWithdrawSmsResultDto(
      success: (json['success'] as bool?) ?? false,
      message: (json['message'] as String?) ?? '',
      smsFeeAmount: (json['smsFeeAmount'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'smsFeeAmount': smsFeeAmount,
    };
  }

  SettlementWithdrawSmsResult toEntity() {
    return SettlementWithdrawSmsResult(
      success: success,
      message: message,
      smsFeeAmount: smsFeeAmount,
    );
  }
}
