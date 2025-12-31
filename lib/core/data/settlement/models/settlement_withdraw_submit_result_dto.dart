import 'package:consignment/core/data/settlement/domain/settlement_withdraw_submit_result.dart';

class SettlementWithdrawSubmitResultDto {
  final bool success;
  final String message;
  final String? receiptId;

  const SettlementWithdrawSubmitResultDto({
    required this.success,
    required this.message,
    required this.receiptId,
  });

  factory SettlementWithdrawSubmitResultDto.fromJson(Map<String, dynamic> json) {
    return SettlementWithdrawSubmitResultDto(
      success: (json['success'] as bool?) ?? false,
      message: (json['message'] as String?) ?? '',
      receiptId: json['receiptId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'receiptId': receiptId,
    };
  }

  SettlementWithdrawSubmitResult toEntity() {
    return SettlementWithdrawSubmitResult(
      success: success,
      message: message,
      receiptId: receiptId,
    );
  }
}
