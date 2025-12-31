import 'package:consignment/core/data/settlement/domain/settlement_wallet.dart';

class SettlementWalletDto {
  final int? currentBalance;

  const SettlementWalletDto({
    this.currentBalance,
  });

  factory SettlementWalletDto.fromJson(Map<String, dynamic> json) {
    return SettlementWalletDto(
      currentBalance: json['currentBalance'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentBalance': currentBalance,
    };
  }

  SettlementWallet toEntity() {
    return SettlementWallet(
      currentBalance: currentBalance ?? 0,
    );
  }
}
