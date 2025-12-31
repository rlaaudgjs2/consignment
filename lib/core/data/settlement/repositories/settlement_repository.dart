import 'package:consignment/core/data/settlement/datasources/settlement_remote_data_source.dart';

import 'package:consignment/core/data/settlement/domain/settlement_daily_summary.dart';
import 'package:consignment/core/data/settlement/domain/settlement_transaction.dart';
import 'package:consignment/core/data/settlement/domain/settlement_transaction_detail.dart';
import 'package:consignment/core/data/settlement/domain/settlement_wallet.dart';

import 'package:consignment/core/data/settlement/domain/settlement_withdraw_info.dart';
import 'package:consignment/core/data/settlement/domain/settlement_withdraw_session.dart';
import 'package:consignment/core/data/settlement/domain/settlement_withdraw_sms_result.dart';
import 'package:consignment/core/data/settlement/domain/settlement_withdraw_submit_result.dart';

class SettlementRepository {
  final SettlementRemoteDataSource remote;

  SettlementRepository({
    required this.remote,
  });

  Future<SettlementDailySummary> fetchDailySummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final dto = await remote.fetchDailySummary(startDate: startDate, endDate: endDate);
    return dto.toEntity();
  }

  Future<List<SettlementTransaction>> fetchTransactions({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final dtos = await remote.fetchTransactions(startDate: startDate, endDate: endDate);
    return dtos.map((e) => e.toEntity()).toList();
  }

  /// ✅ 거래 상세(모달용)
  Future<SettlementTransactionDetail> fetchTransactionDetail({
    required String id,
  }) async {
    final dto = await remote.fetchTransactionDetail(id: id);
    return dto.toEntity();
  }

  Future<SettlementWallet> fetchWallet({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final dto = await remote.fetchWallet(startDate: startDate, endDate: endDate);
    return dto.toEntity();
  }

  // -------------------------
  // ✅ Withdraw Flow
  // -------------------------
  Future<SettlementWithdrawInfo> fetchWithdrawInfo() async {
    final dto = await remote.fetchWithdrawInfo();
    return dto.toEntity();
  }

  Future<SettlementWithdrawSession> createWithdrawSession({
    required int amount,
  }) async {
    final dto = await remote.createWithdrawSession(amount: amount);
    return dto.toEntity();
  }

  Future<SettlementWithdrawSmsResult> requestWithdrawSms({
    required String sessionId,
    required String phoneNumber,
  }) async {
    final dto = await remote.requestWithdrawSms(
      sessionId: sessionId,
      phoneNumber: phoneNumber,
    );
    return dto.toEntity();
  }

  Future<SettlementWithdrawSubmitResult> submitWithdraw({
    required String sessionId,
    required String phoneNumber,
    required String code,
  }) async {
    final dto = await remote.submitWithdraw(
      sessionId: sessionId,
      phoneNumber: phoneNumber,
      code: code,
    );
    return dto.toEntity();
  }
}
