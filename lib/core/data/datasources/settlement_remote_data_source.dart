import 'package:consignment/core/data/datasources/test_data.dart';
import 'package:consignment/core/data/models/settlement_daily_summary_dto.dart';
import 'package:consignment/core/data/models/settlement_transaction_detail_dto.dart';
import 'package:consignment/core/data/models/settlement_transaction_dto.dart';
import 'package:consignment/core/data/models/settlement_wallet_dto.dart';
import 'package:consignment/core/data/models/settlement_withdraw_info_dto.dart';
import 'package:consignment/core/data/models/settlement_withdraw_session_dto.dart';
import 'package:consignment/core/data/models/settlement_withdraw_sms_result_dto.dart';
import 'package:consignment/core/data/models/settlement_withdraw_submit_result_dto.dart';

/// Settlement(정산) 전용 RemoteDataSource
///
/// 현재는 TestData 기반 구현.
/// 추후 실제 API 연결 시 이 파일 내부 구현만 교체하면 됨.
class SettlementRemoteDataSource {
  const SettlementRemoteDataSource();

  Future<SettlementDailySummaryDto> fetchDailySummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return TestData.dailySummaryMock;
  }

  Future<List<SettlementTransactionDto>> fetchTransactions({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return TestData.transactionsMock;
  }

  Future<SettlementTransactionDetailDto> fetchTransactionDetail({
    required String id,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return TestData.transactionDetailMock(id);
  }

  Future<SettlementWalletDto> fetchWallet({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return TestData.walletMock;
  }

  // -------------------------
  // Withdraw Flow
  // -------------------------
  Future<SettlementWithdrawInfoDto> fetchWithdrawInfo() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return TestData.withdrawInfoMock();
  }

  Future<SettlementWithdrawSessionDto> createWithdrawSession({
    required int amount,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return TestData.withdrawSessionMock(amount);
  }

  Future<SettlementWithdrawSmsResultDto> requestWithdrawSms({
    required String sessionId,
    required String phoneNumber,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return TestData.withdrawSmsMock(phoneNumber);
  }

  Future<SettlementWithdrawSubmitResultDto> submitWithdraw({
    required String sessionId,
    required String phoneNumber,
    required String code,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return TestData.withdrawSubmitMock(code);
  }
}
