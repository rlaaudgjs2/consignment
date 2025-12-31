// features/dispatch/presentation/pages/dispatch_page.dart
import 'package:flutter/material.dart';
import 'package:consignment/features/dispatch/domain/entities/dispatch.dart';
import 'package:consignment/features/dispatch/domain/repositories/dispatch_repository.dart';
import 'package:consignment/features/dispatch/data/repositories/dispatch_repository_impl.dart';
import 'package:consignment/features/dispatch/data/datasources/dispatch_remote_data_source.dart';
import 'package:consignment/features/dispatch/presentation/widgets/dispatch_detail_view.dart';

class DispatchPage extends StatefulWidget {
  const DispatchPage({super.key});

  @override
  State<DispatchPage> createState() => _DispatchPageState();
}

class _DispatchPageState extends State<DispatchPage> {
  late final DispatchRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = DispatchRepositoryImpl(
      remote: MockDispatchRemoteDataSource(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Dispatch?>(
      future: _repository.getCurrentDispatch(),
      builder: (context, snapshot) {
        // 1) 로딩 상태
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // 2) 에러 상태
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              '배차 정보를 불러오지 못했습니다.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF828282),
              ),
            ),
          );
        }

        // 3) 정상 데이터
        final dispatch = snapshot.data;

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
          onTapNavi: () {
            // TODO: 내비 연동(길안내) 기능 연결
          },
          onTapComplete: () {
            // TODO: 배차 완료 처리 API 연동
          },
          onTapCancelDispatch: () {
            // TODO: 배차 취소 API 연동
          },
        );
      },
    );
  }
}
