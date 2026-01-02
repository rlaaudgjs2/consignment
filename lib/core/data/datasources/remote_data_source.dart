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

abstract class RemoteDataSource {
  // -------------------------
  // Complete (운행내역)
  // -------------------------
  Future<List<DrivingHistoryDto>> fetchDrivingHistories({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<DrivingHistoryDetailDto> fetchDrivingHistoryDetail({
    required String id,
  });

  // -------------------------
  // Dispatch (배차)
  // -------------------------
  Future<DispatchDto?> fetchCurrentDispatch();

  // -------------------------
  // Order (콜 목록)
  // -------------------------
  Future<List<OrderCallDto>> fetchOrderCalls({
    required int maxDistanceKm,
  });

  // -------------------------
  // Settings
  // -------------------------
  Future<SettingsMyInfoDto> fetchMyInfo();
  Future<List<SettingsNoticeDto>> fetchNotices();

  // -------------------------
  // Settlement (정산)
  // -------------------------
  Future<SettlementDailySummaryDto> fetchDailySummary({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<SettlementTransactionDto>> fetchTransactions({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<SettlementTransactionDetailDto> fetchTransactionDetail({
    required String id,
  });

  Future<SettlementWalletDto> fetchWallet({
    required DateTime startDate,
    required DateTime endDate,
  });

  // -------------------------
  // Withdraw Flow
  // -------------------------
  Future<SettlementWithdrawInfoDto> fetchWithdrawInfo();

  Future<SettlementWithdrawSessionDto> createWithdrawSession({
    required int amount,
  });

  Future<SettlementWithdrawSmsResultDto> requestWithdrawSms({
    required String sessionId,
    required String phoneNumber,
  });

  Future<SettlementWithdrawSubmitResultDto> submitWithdraw({
    required String sessionId,
    required String phoneNumber,
    required String code,
  });
}
