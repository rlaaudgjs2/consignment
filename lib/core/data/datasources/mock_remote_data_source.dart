import 'package:consignment/core/data/datasources/remote_data_source.dart';
import 'package:consignment/core/data/datasources/test_data.dart';
import 'package:consignment/core/data/models/dispatch_dto.dart';
import 'package:consignment/core/data/models/driving_history_dto.dart';
import 'package:consignment/core/data/models/driving_history_detail_dto.dart';
import 'package:consignment/core/data/models/order_call_dto.dart';
import 'package:consignment/core/data/models/settings_my_info_dto.dart';
import 'package:consignment/core/data/models/settings_notice_dto.dart';
import 'package:consignment/core/data/models/settlement_daily_summary_dto.dart';
import 'package:consignment/core/data/models/settlement_transaction_dto.dart';
import 'package:consignment/core/data/models/settlement_transaction_detail_dto.dart';
import 'package:consignment/core/data/models/settlement_wallet_dto.dart';
import 'package:consignment/core/data/models/settlement_withdraw_info_dto.dart';
import 'package:consignment/core/data/models/settlement_withdraw_session_dto.dart';
import 'package:consignment/core/data/models/settlement_withdraw_submit_result_dto.dart';
import 'package:consignment/core/data/models/settlement_withdraw_sms_result_dto.dart';

class MockRemoteDataSource implements RemoteDataSource {
  const MockRemoteDataSource();

  @override
  Future<List<DrivingHistoryDto>> fetchDrivingHistories({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return TestData.drivingHistoryList;
  }

  @override
  Future<DrivingHistoryDetailDto> fetchDrivingHistoryDetail({
    required String id,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return TestData.drivingHistoryDetailMap[id] ?? TestData.emptyDrivingHistoryDetail(id);
  }

  @override
  Future<DispatchDto?> fetchCurrentDispatch() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return TestData.dispatchMock();
  }

  @override
  Future<List<OrderCallDto>> fetchOrderCalls({required int maxDistanceKm}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final list = TestData.orderCallsMock();
    return list
        .where((dto) => (dto.distanceKm ?? double.infinity) <= maxDistanceKm)
        .toList();
  }

  @override
  Future<SettingsMyInfoDto> fetchMyInfo() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return TestData.myInfoMock();
  }

  @override
  Future<List<SettingsNoticeDto>> fetchNotices() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return TestData.noticesMock;
  }

  @override
  Future<SettlementDailySummaryDto> fetchDailySummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return TestData.dailySummaryMock;
  }

  @override
  Future<List<SettlementTransactionDto>> fetchTransactions({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return TestData.transactionsMock;
  }

  @override
  Future<SettlementTransactionDetailDto> fetchTransactionDetail({required String id}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return TestData.transactionDetailMock(id);
  }

  @override
  Future<SettlementWalletDto> fetchWallet({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return TestData.walletMock;
  }

  @override
  Future<SettlementWithdrawInfoDto> fetchWithdrawInfo() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return TestData.withdrawInfoMock();
  }

  @override
  Future<SettlementWithdrawSessionDto> createWithdrawSession({required int amount}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return TestData.withdrawSessionMock(amount);
  }

  @override
  Future<SettlementWithdrawSmsResultDto> requestWithdrawSms({
    required String sessionId,
    required String phoneNumber,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return TestData.withdrawSmsMock(phoneNumber);
  }

  @override
  Future<SettlementWithdrawSubmitResultDto> submitWithdraw({
    required String sessionId,
    required String phoneNumber,
    required String code,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return TestData.withdrawSubmitMock(code);
  }
}
