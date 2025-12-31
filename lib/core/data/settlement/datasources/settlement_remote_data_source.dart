import 'package:consignment/core/data/settlement/models/settlement_daily_summary_dto.dart';
import 'package:consignment/core/data/settlement/models/settlement_transaction_dto.dart';
import 'package:consignment/core/data/settlement/models/settlement_transaction_detail_dto.dart';
import 'package:consignment/core/data/settlement/models/settlement_wallet_dto.dart';

import 'package:consignment/core/data/settlement/models/settlement_withdraw_info_dto.dart';
import 'package:consignment/core/data/settlement/models/settlement_withdraw_session_dto.dart';
import 'package:consignment/core/data/settlement/models/settlement_withdraw_sms_result_dto.dart';
import 'package:consignment/core/data/settlement/models/settlement_withdraw_submit_result_dto.dart';

import '../domain/settlement_transaction_detail.dart';

abstract class SettlementRemoteDataSource {
  Future<SettlementDailySummaryDto> fetchDailySummary({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<SettlementTransactionDto>> fetchTransactions({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// ✅ 거래 상세(모달용)
  Future<SettlementTransactionDetailDto> fetchTransactionDetail({
    required String id,
  });

  /// ✅ 내 지갑: 잔액만
  Future<SettlementWalletDto> fetchWallet({
    required DateTime startDate,
    required DateTime endDate,
  });

  // -------------------------
  // ✅ Withdraw Flow
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
      SettlementTransactionDto(
        id: 'tx_20251109_0',
        date: '2025-11-09',
        amount: -8400,
        balance: 55414,
        description: '특정날자동공제',
      ),
      SettlementTransactionDto(
        id: 'tx_20251108_0',
        date: '2025-11-08',
        amount: -8400,
        balance: 63814,
        description: '특정날자동공제',
      ),
      SettlementTransactionDto(
        id: 'tx_20251107_0',
        date: '2025-11-07',
        amount: -8400,
        balance: 72214,
        description: '특정날자동공제',
      ),
      SettlementTransactionDto(
        id: 'tx_20251106_0',
        date: '2025-11-06',
        amount: 20000,
        balance: 80614,
        description: '타사입금',
      ),
      SettlementTransactionDto(
        id: 'tx_20251105_0',
        date: '2025-11-05',
        amount: -8400,
        balance: 60614,
        description: '특정날자동공제',
      ),
      SettlementTransactionDto(
        id: 'tx_20251104_0',
        date: '2025-11-04',
        amount: -459,
        balance: 69041,
        description: '산재보험',
      ),
      SettlementTransactionDto(
        id: 'tx_20251104_1',
        date: '2025-11-04',
        amount: -394,
        balance: 69473,
        description: '고용보험',
      ),
      SettlementTransactionDto(
        id: 'tx_20251106_1',
        date: '2025-11-06',
        amount: 28804,
        balance: 69867,
        description: '타사입금',
      ),
    ];
  }

  @override
  Future<SettlementTransactionDetailDto> fetchTransactionDetail({
    required String id,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // ✅ 예시(운행수수료)
    if (id == 'tx_fee_SALM251124') {
      return const SettlementTransactionDetailDto(
        id: 'tx_fee_SALM251124',
        type: 'drivingFee',
        dateTimeText: '2025-11-24 11:48:55',
        titleText: '운행수수료',
        amountWon: -22000,
        balanceWon: 0,
        // 운행수수료 모달에 필요한 필드
        orderTypeText: '탁송',
        tags: ['즉후', '경유', '하이패스'],
        orderNo: 'SALM251124',
        startAddress: '부안상서면부장1길11',
        endAddress: '수원평동, 임광모터스',
        fareWon: 110000,
        // etc 모달에도 공용으로 표시 가능한 특이사항
        noteText: null,
      );
    }

    // ✅ 기타공제/총입금 등 “기타 상세”
    return SettlementTransactionDetailDto(
      id: id,
      type: 'etc',
      dateTimeText: '2025-11-24 11:48:55',
      titleText: '특정일자자동공제',
      amountWon: -8400,
      balanceWon: 0,
      orderTypeText: null,
      tags: const [],
      orderNo: null,
      startAddress: null,
      endAddress: null,
      fareWon: null,
      noteText: '보험료',
    );
  }

  @override
  Future<SettlementWalletDto> fetchWallet({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));

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
