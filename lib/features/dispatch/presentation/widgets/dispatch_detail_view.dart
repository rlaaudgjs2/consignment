// features/dispatch/presentation/widgets/dispatch_detail_view.dart
import 'package:flutter/material.dart';
import 'package:consignment/features/dispatch/domain/entities/dispatch.dart';
import 'package:consignment/features/dispatch/presentation/widgets/dispatch_header_section.dart';
import 'package:consignment/features/dispatch/presentation/widgets/dispatch_info_section.dart';
import 'package:consignment/features/dispatch/presentation/widgets/dispatch_middle_buttons.dart';
import 'package:consignment/features/dispatch/presentation/widgets/dispatch_bottom_buttons.dart';

class DispatchDetailView extends StatelessWidget {
  final Dispatch dispatch;
  final VoidCallback onTapNavi;
  final VoidCallback onTapComplete;
  final VoidCallback onTapCancelDispatch;

  const DispatchDetailView({
    super.key,
    required this.dispatch,
    required this.onTapNavi,
    required this.onTapComplete,
    required this.onTapCancelDispatch,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double horizontalPadding = 24;
    const double gap = 16;
    final double buttonWidth =
        (screenWidth - horizontalPadding * 2 - gap) / 2;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DispatchHeaderSection(dispatch: dispatch),
                const SizedBox(height: 20),
                DispatchInfoSection(dispatch: dispatch),
                const SizedBox(height: 24),
                const DispatchMiddleButtons(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: DispatchBottomButtons(
            buttonWidth: buttonWidth,
            gap: gap,
            onTapNavi: onTapNavi,
            onTapComplete: onTapComplete,
          ),
        ),
      ],
    );
  }
}
