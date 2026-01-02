import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/core/data/domain/order_call.dart';
import 'package:consignment/src/features/order/widgets/order_type_chip.dart';

import 'package:consignment/core/data/datasources/mock_remote_data_source.dart';
import 'package:consignment/core/data/repositories/settings_repository.dart';

import '../viewmodels/settings_my_info_viewmodel.dart';

class SettingsMyInfoPage extends StatelessWidget {
  const SettingsMyInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ 여기서 Provider를 올린다
    final repo = SettingsRepository(remote: MockRemoteDataSource());

    return ChangeNotifierProvider<SettingsMyInfoViewModel>(
      create: (_) => SettingsMyInfoViewModel(repository: repo),
      child: const _SettingsMyInfoView(),
    );
  }
}

class _SettingsMyInfoView extends StatelessWidget {
  const _SettingsMyInfoView();

  static const _bg = Color(0xFFFFFFFF);
  static const _text = Color(0xFF333333);
  static const _sub = Color(0xFF828282);
  static const _line = Color(0xFFEAEAEA);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsMyInfoViewModel>();

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: _text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '내 정보',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.0,
            color: _text,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (vm.errorMessage != null) ...[
                Text(
                  vm.errorMessage!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFE53935),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // -------------------------
              // 기사 정보
              // -------------------------
              const _SectionTitle(title: '기사 정보'),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  children: [
                    _KvRow(label: '전화번호', value: vm.driverPhoneNumber ?? '-'),
                    const SizedBox(height: 14),
                    _KvRow(label: '기사명', value: vm.driverName ?? '-'),
                    const SizedBox(height: 14),
                    _KvRow(label: '소속사무실', value: vm.officeName ?? '-'),
                    const SizedBox(height: 14),
                    const Divider(height: 1, thickness: 1, color: _line),
                    const SizedBox(height: 14),
                    _KvRow(
                      label: '상황실 전화번호',
                      value: vm.officePhoneNumber ?? '-',
                      valueStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                        color: Color(0xFFF2B36A),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // -------------------------
              // 충전계좌 정보
              // -------------------------
              const _SectionTitle(title: '충전계좌 정보'),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  children: [
                    _KvRow(label: '충전 계좌번호', value: vm.chargeAccountNumber ?? '-'),
                    const SizedBox(height: 14),
                    _KvRow(label: '은행명', value: vm.chargeBankName ?? '-'),
                    const SizedBox(height: 14),
                    _KvRow(label: '예금주', value: vm.chargeDepositorName ?? '-'),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // -------------------------
              // 보험 정보
              // -------------------------
              const _SectionTitle(title: '보험 정보'),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _KvRow(label: '가입자명', value: vm.insuranceOwnerName ?? '-'),
                    const SizedBox(height: 12),
                    const Divider(height: 1, thickness: 1, color: _line),
                    const SizedBox(height: 12),

                    if (vm.insurances.isEmpty)
                      const Text(
                        '등록된 보험 정보가 없습니다.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                          color: _sub,
                        ),
                      )
                    else
                      Column(
                        children: [
                          for (int i = 0; i < vm.insurances.length; i++) ...[
                            _InsuranceBlock(
                              typeLabel: vm.insurances[i].typeLabel,
                              startDate: vm.insurances[i].startDate,
                              endDate: vm.insurances[i].endDate,
                              companyName: vm.insurances[i].companyName,
                              policyNumber: vm.insurances[i].policyNumber,
                            ),
                            if (i != vm.insurances.length - 1) ...[
                              const SizedBox(height: 14),
                              const Divider(height: 1, thickness: 1, color: _line),
                              const SizedBox(height: 14),
                            ],
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InsuranceBlock extends StatelessWidget {
  final String typeLabel; // "대리" | "탁송"
  final String startDate;
  final String endDate;
  final String companyName;
  final String policyNumber;

  const _InsuranceBlock({
    required this.typeLabel,
    required this.startDate,
    required this.endDate,
    required this.companyName,
    required this.policyNumber,
  });

  @override
  Widget build(BuildContext context) {
    final orderType = _parseOrderType(typeLabel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrderTypeChip(type: orderType),
        const SizedBox(height: 12),
        _KvRow(label: '개시일자', value: startDate),
        const SizedBox(height: 14),
        _KvRow(label: '만료일자', value: endDate),
        const SizedBox(height: 14),
        _KvRow(label: '보험사', value: companyName),
        const SizedBox(height: 14),
        _KvRow(label: '증권번호', value: policyNumber),
      ],
    );
  }

  OrderType _parseOrderType(String label) {
    switch (label) {
      case '탁송':
        return OrderType.consign;
      case '대리':
        return OrderType.proxy;
      default:
        return OrderType.proxy;
    }
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        height: 1.0,
        color: Color(0xFF333333),
      ),
    );
  }
}

class _KvRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _KvRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  static const _labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: Color(0xFF9A9A9A),
  );

  static const _defaultValueStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    height: 1.0,
    color: Color(0xFF333333),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 110, child: Text(label, style: _labelStyle)),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: valueStyle ?? _defaultValueStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
