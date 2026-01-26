import 'package:flutter/foundation.dart';
import 'package:consignment/core/data/domain/settings_notice.dart';
import 'package:consignment/core/data/repositories/settings_repository.dart';

class SettingsNoticeViewModel extends ChangeNotifier {
  final SettingsRepository _repository;

  SettingsNoticeViewModel({
    required SettingsRepository repository,
  }) : _repository = repository {
    _init();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<SettingsNotice> _items = const [];
  List<SettingsNotice> get items => _items;

  int? _expandedIndex;
  int? get expandedIndex => _expandedIndex;

  Future<void> _init() async {
    await load();
  }

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = await _repository.fetchNotices();
    } catch (_) {
      _errorMessage = '공지사항 조회 중 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleExpanded(int index) {
    if (_expandedIndex == index) {
      _expandedIndex = null;
    } else {
      _expandedIndex = index;
    }
    notifyListeners();
  }
}
