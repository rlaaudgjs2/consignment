import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/core/data/domain/order_call.dart';
import 'package:consignment/src/features/order/widgets/order_type_chip.dart';

import 'package:consignment/core/data/datasources/settings_remote_data_source.dart';
import 'package:consignment/core/data/repositories/settings_repository.dart';

import '../viewmodels/settings_my_info_viewmodel.dart';

class SettingsMyInfoPage extends StatelessWidget {
  const SettingsMyInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = SettingsRepository(remote: SettingsRemoteDataSource());

    return ChangeNotifierProvider<SettingsMyInfoViewModel>(
      create: (_) => SettingsMyInfoViewModel(repository: repo),
      child: const _SettingsMyInfoView(),
    );
  }
}

class _SettingsMyInfoView extends StatelessWidget {
  const _SettingsMyInfoView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsMyInfoViewModel>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18, color: cs.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '내 정보',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.0,
            color: cs.onSurface,
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
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: cs.error,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // -------------------------
              // 기사 정보
              // -------------------------
              const _SectionTitle(title: '기사 정보'),
              const SizedBox(height: 20),

              _KvRow(label: '전화번호', value: vm.driverPhoneNumber ?? '-'),
              const SizedBox(height: 14),
              _KvRow(label: '기사명', value: vm.driverName ?? '-'),
              const SizedBox(height: 14),
              _KvRow(label: '소속사무실', value: vm.officeName ?? '-'),
              const SizedBox(height: 14),

              _KvRow(
                label: '상황실 전화번호',
                value: vm.officePhoneNumber ?? '-',
                valueStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                  color: cs.primary,
                ),
                prefixIcon: Icon(Icons.call, size: 18, color: cs.primary),
              ),
              const SizedBox(height: 14),

              _KvRowWithAction(
                label: '기사 코드',
                value: vm.driverCode ?? '-',
                actionText: '재발급',
                onPressed: vm.isReissuingCode ? null : () => vm.reissueDriverCode(),
              ),

              const SizedBox(height: 16),
              Divider(height: 1, thickness: 1, color: theme.dividerColor),
              const SizedBox(height: 18),

              // -------------------------
              // 충전계좌 정보
              // -------------------------
              const _SectionTitle(title: '충전계좌 정보'),
              const SizedBox(height: 20),

              _KvRow(label: '충전 계좌번호', value: vm.chargeAccountNumber ?? '-'),
              const SizedBox(height: 14),
              _KvRow(label: '은행명', value: vm.chargeBankName ?? '-'),
              const SizedBox(height: 14),
              _KvRow(label: '예금주', value: vm.chargeDepositorName ?? '-'),

              const SizedBox(height: 16),
              Divider(height: 1, thickness: 1, color: theme.dividerColor),
              const SizedBox(height: 18),

              // -------------------------
              // 보험 정보
              // -------------------------
              const _SectionTitle(title: '보험 정보'),
              const SizedBox(height: 20),

              _KvRow(label: '가입자명', value: vm.insuranceOwnerName ?? '-'),
              const SizedBox(height: 16),

              if (vm.insurances.isEmpty)
                Text(
                  '등록된 보험 정보가 없습니다.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: cs.onSurface.withOpacity(0.6),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ],
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
        const SizedBox(height: 14),
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

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        height: 1.0,
        color: cs.onSurface,
      ),
    );
  }
}

class _KvRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;
  final Widget? prefixIcon;

  const _KvRow({
    required this.label,
    required this.value,
    this.valueStyle,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final labelStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 1.0,
      color: cs.onSurface.withOpacity(0.55),
    );

    final defaultValueStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      height: 1.0,
      color: cs.onSurface,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 110, child: Text(label, style: labelStyle)),
        Expanded(
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  value,
                  style: valueStyle ?? defaultValueStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KvRowWithAction extends StatelessWidget {
  final String label;
  final String value;
  final String actionText;
  final VoidCallback? onPressed;

  const _KvRowWithAction({
    required this.label,
    required this.value,
    required this.actionText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final labelStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 1.0,
      color: cs.onSurface.withOpacity(0.55),
    );

    final valueStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      height: 1.0,
      color: cs.onSurface,
    );

    return Row(
      children: [
        SizedBox(width: 110, child: Text(label, style: labelStyle)),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: valueStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 34,
                child: OutlinedButton(
                  onPressed: onPressed,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cs.primary,
                    side: BorderSide(color: cs.primary, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  child: Text(
                    actionText,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
