import '../domain/settlement_withdraw_info.dart';

class SettlementWithdrawInfoDto {
  final int? availableAmount;
  final String? bankName;
  final String? maskedAccountNumber;
  final String? depositorName;
  final int? unitAmount;
  final int? feeAmount;

  SettlementWithdrawInfoDto({
    this.availableAmount,
    this.bankName,
    this.maskedAccountNumber,
    this.depositorName,
    this.unitAmount,
    this.feeAmount,
  });

  factory SettlementWithdrawInfoDto.fromJson(Map<String, dynamic> json) {
    return SettlementWithdrawInfoDto(
      availableAmount: json['availableAmount'] as int?,
      bankName: json['bankName'] as String?,
      maskedAccountNumber: json['maskedAccountNumber'] as String?,
      depositorName: json['depositorName'] as String?,
      unitAmount: json['unitAmount'] as int?,
      feeAmount: json['feeAmount'] as int?,
    );
  }

  SettlementWithdrawInfo toEntity() {
    return SettlementWithdrawInfo(
      availableAmount: availableAmount ?? 0,
      bankName: bankName ?? '',
      maskedAccountNumber: maskedAccountNumber ?? '',
      depositorName: depositorName ?? '',
      unitAmount: unitAmount ?? 10000,
      feeAmount: feeAmount ?? 300,
    );
  }
}
