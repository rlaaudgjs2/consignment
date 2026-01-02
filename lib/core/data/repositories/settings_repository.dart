import 'package:consignment/core/data/datasources/remote_data_source.dart';

import 'package:consignment/core/data/domain/settings_my_info.dart';
import 'package:consignment/core/data/domain/settings_notice.dart';

class SettingsRepository {
  final RemoteDataSource remote;

  SettingsRepository({
    required this.remote,
  });

  Future<SettingsMyInfo> fetchMyInfo() async {
    final dto = await remote.fetchMyInfo();
    return dto.toEntity();
  }

  Future<List<SettingsNotice>> fetchNotices() async {
    final dtos = await remote.fetchNotices();
    return dtos.map((e) => e.toEntity()).toList();
  }
}
