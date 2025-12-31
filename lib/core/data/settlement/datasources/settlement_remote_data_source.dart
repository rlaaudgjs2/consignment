import 'package:consignment/core/data/settlement/models/settlement_daily_summary_dto.dart';
import 'package:consignment/core/data/settlement/models/settlement_transaction_dto.dart';
import 'package:consignment/core/data/settlement/models/settlement_wallet_dto.dart';

import 'package:consignment/core/data/settlement/models/settlement_withdraw_info_dto.dart';
import 'package:consignment/core/data/settlement/models/settlement_withdraw_session_dto.dart';
import 'package:consignment/core/data/settlement/models/settlement_withdraw_sms_result_dto.dart';
import 'package:consignment/core/data/settlement/models/settlement_withdraw_submit_result_dto.dart';

abstract class SettlementRemoteDataSource {
  Future<SettlementDailySummaryDto> fetchDailySummary({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<SettlementTransactionDto>> fetchTransactions({
    required DateTime startDate,
    required DateTime endDate,
  });

  // ✅ 내 지갑: 잔액만
  Future<SettlementWalletDto> fetchWallet({
    required DateTime startDate,
    required DateTime endDate,
  });

  // ✅ 출금요청 화면 표시용 정보
  Future<SettlementWithdrawInfoDto> fetchWithdrawInfo();

  // ✅ “출금” 클릭 시 서버 세션 생성 (Prepare 흡수)
  Future<SettlementWithdrawSessionDto> createWithdrawSession({
    required int amount,
  });

  // ✅ SMS 인증 요청
  Future<SettlementWithdrawSmsResultDto> requestWithdrawSms({
    required String sessionId,
    required String phoneNumber,
  });

  // ✅ 인증번호 제출 + 출금 요청 확정
  Future<SettlementWithdrawSubmitResultDto> submitWithdraw({
    required String sessionId,
    required String phoneNumber,
    required String code,
  });
}

/// ✅ API 붙이기 전까지 사용할 Mock
class MockSettlementRemoteDataSource implements SettlementRemoteDataSource {
  @override
  Future<SettlementDailySummaryDto> fetchDailySummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));

    return const SettlementDailySummaryDto(
      callCount: 4,
      drivingFee: 360000,
      commissionFee: 72000,
      etcDeduction: 360109,
      totalDeposit: 408804,
      totalIncome: -72109,
    );
  }

  @override
  Future<List<SettlementTransactionDto>> fetchTransactions({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));

    return const [
      SettlementTransactionDto(date: '2025-11-09', amount: -8400, balance: 55414, description: '특정날자동공제'),
      SettlementTransactionDto(date: '2025-11-08', amount: -8400, balance: 63814, description: '특정날자동공제'),
      SettlementTransactionDto(date: '2025-11-07', amount: -8400, balance: 72214, description: '특정날자동공제'),
      SettlementTransactionDto(date: '2025-11-06', amount: 20000, balance: 80614, description: '타사입금'),
      SettlementTransactionDto(date: '2025-11-05', amount: -8400, balance: 60614, description: '특정날자동공제'),
      SettlementTransactionDto(date: '2025-11-04', amount: -459, balance: 69041, description: '산재보험'),
      SettlementTransactionDto(date: '2025-11-04', amount: -394, balance: 69473, description: '고용보험'),
      SettlementTransactionDto(date: '2025-11-06', amount: 28804, balance: 69867, description: '타사입금'),
    ];
  }

  @override
  Future<SettlementWalletDto> fetchWallet({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));

    // ✅ transactions 제거: 잔액만 내려줌
    return const SettlementWalletDto(
      currentBalance: 55414,
    );
  }

  @override
  Future<SettlementWithdrawInfoDto> fetchWithdrawInfo() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return SettlementWithdrawInfoDto(
      availableAmount: 50000,
      bankName: '카카오뱅크',
      maskedAccountNumber: '333318715****',
      depositorName: '김규원',
      unitAmount: 10000,
      feeAmount: 300,
    );
  }

  @override
  Future<SettlementWithdrawSessionDto> createWithdrawSession({
    required int amount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));

    return SettlementWithdrawSessionDto(
      sessionId: 'sess_${DateTime.now().millisecondsSinceEpoch}',
      bankName: '카카오뱅크',
      accountNumber: '3333187153307',
      depositorName: '김규원',
      amount: amount,
    );
  }

  @override
  Future<SettlementWithdrawSmsResultDto> requestWithdrawSms({
    required String sessionId,
    required String phoneNumber,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));

    final normalized = phoneNumber.replaceAll('-', '').trim();
    if (normalized.length < 10) {
      return const SettlementWithdrawSmsResultDto(
        success: false,
        message: '전화번호를 확인해주세요.',
        smsFeeAmount: 20,
      );
    }

    return const SettlementWithdrawSmsResultDto(
      success: true,
      message: 'SMS 인증번호를 발송했습니다.',
      smsFeeAmount: 20,
    );
  }

  @override
  Future<SettlementWithdrawSubmitResultDto> submitWithdraw({
    required String sessionId,
    required String phoneNumber,
    required String code,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (code.trim().length < 4) {
      return const SettlementWithdrawSubmitResultDto(
        success: false,
        message: '인증번호를 확인해주세요.',
        receiptId: null,
      );
    }

    return SettlementWithdrawSubmitResultDto(
      success: true,
      message: '출금 요청이 접수되었습니다.',
      receiptId: 'rcpt_${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}
