import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/src/features/dispatch/viewmodels/dispatch_view_model.dart';
import 'package:consignment/src/features/dispatch/widgets/dispatch_detail_view.dart';
import 'package:consignment/core/data/repositories/dispatch_repository_impl.dart';

class DispatchPage extends StatelessWidget {
  const DispatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DispatchViewModel>(
      create: (ctx) => DispatchViewModel(
        repository: ctx.read<DispatchRepositoryImpl>(),
      ),
      child: const _DispatchPageBody(),
    );
  }
}

class _DispatchPageBody extends StatefulWidget {
  const _DispatchPageBody();

  @override
  State<_DispatchPageBody> createState() => _DispatchPageBodyState();
}

class _DispatchPageBodyState extends State<_DispatchPageBody> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DispatchViewModel>().loadCurrentDispatch(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DispatchViewModel>();

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Text(
          viewModel.errorMessage!,
          style: const TextStyle(fontSize: 16, color: Color(0xFF828282)),
          textAlign: TextAlign.center,
        ),
      );
    }

    final dispatch = viewModel.dispatch;

    if (dispatch == null) {
      return const Center(
        child: Text(
          '배차 된 오더가 없습니다.',
          style: TextStyle(fontSize: 16, color: Color(0xFF828282)),
        ),
      );
    }

    return DispatchDetailView(
      dispatch: dispatch,
      onTapNavi: () => viewModel.onTapNavi(context),
      onTapComplete: () => viewModel.onTapComplete(context),
      onTapCancelDispatch: () => viewModel.onTapCancelDispatch(context),
    );
  }
}
