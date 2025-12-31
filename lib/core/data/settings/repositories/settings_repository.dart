import 'package:consignment/core/data/settings/datasources/settings_remote_data_source.dart';

import 'package:consignment/core/data/settings/domain/settings_my_info.dart';
import 'package:consignment/core/data/settings/domain/settings_notice.dart';

class SettingsRepository {
  final SettingsRemoteDataSource remote;

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
