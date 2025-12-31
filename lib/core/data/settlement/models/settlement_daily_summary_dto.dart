import 'package:consignment/core/data/settlement/domain/settlement_daily_summary.dart';

class SettlementDailySummaryDto {
  final int? callCount;
  final int? drivingFee;
  final int? commissionFee;
  final int? etcDeduction;
  final int? totalDeposit;
  final int? totalIncome;

  const SettlementDailySummaryDto({
    this.callCount,
    this.drivingFee,
    this.commissionFee,
    this.etcDeduction,
    this.totalDeposit,
    this.totalIncome,
  });

  factory SettlementDailySummaryDto.fromJson(Map<String, dynamic> json) {
    return SettlementDailySummaryDto(
      callCount: json['callCount'] as int?,
      drivingFee: json['drivingFee'] as int?,
      commissionFee: json['commissionFee'] as int?,
      etcDeduction: json['etcDeduction'] as int?,
      totalDeposit: json['totalDeposit'] as int?,
      totalIncome: json['totalIncome'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callCount': callCount,
      'drivingFee': drivingFee,
      'commissionFee': commissionFee,
      'etcDeduction': etcDeduction,
      'totalDeposit': totalDeposit,
      'totalIncome': totalIncome,
    };
  }

  SettlementDailySummary toEntity() {
    return SettlementDailySummary(
      callCount: callCount ?? 0,
      drivingFee: drivingFee ?? 0,
      commissionFee: commissionFee ?? 0,
      etcDeduction: etcDeduction ?? 0,
      totalDeposit: totalDeposit ?? 0,
      totalIncome: totalIncome ?? 0,
    );
  }
}
