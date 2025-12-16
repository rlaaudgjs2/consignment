import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consignment/src/features/dispatch/viewmodels/dispatch_view_model.dart';
import 'package:consignment/src/features/dispatch/widgets/dispatch_detail_view.dart';

class DispatchPage extends StatelessWidget {
  const DispatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DispatchViewModel>();

    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Text(
          viewModel.errorMessage!,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF828282),
          ),
        ),
      );
    }

    final dispatch = viewModel.dispatch;

    if (dispatch == null) {
      return const Center(
        child: Text(
          '배차 된 오더가 없습니다.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF828282),
          ),
        ),
      );
    }

    return DispatchDetailView(
      dispatch: dispatch,
      onTapNavi: viewModel.onTapNavi,
      onTapComplete: viewModel.onTapComplete,
      onTapCancelDispatch: viewModel.onTapCancelDispatch,
    );
  }
}
