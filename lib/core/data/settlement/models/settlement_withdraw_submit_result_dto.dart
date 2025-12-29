import '../domain/settlement_withdraw_result.dart';

class SettlementWithdrawSubmitResultDto {
  final bool success;
  final String message;
  final String? receiptId;

  const SettlementWithdrawSubmitResultDto({
    required this.success,
    required this.message,
    required this.receiptId,
  });

  SettlementWithdrawSubmitResult toEntity() {
    return SettlementWithdrawSubmitResult(
      success: success,
      message: message,
      receiptId: receiptId,
    );
  }

  factory SettlementWithdrawSubmitResultDto.fromJson(Map<String, dynamic> json) {
    return SettlementWithdrawSubmitResultDto(
      success: (json['success'] ?? false) as bool,
      message: (json['message'] ?? '') as String,
      receiptId: json['receiptId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'receiptId': receiptId,
    };
  }
}
