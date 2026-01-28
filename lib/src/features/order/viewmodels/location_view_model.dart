// lib/src/features/order/viewmodels/location_view_model.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:consignment/core/data/repositories/location_repository.dart';
import 'package:consignment/src/components/app_toast.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationRepository _repository;

  LocationViewModel({required LocationRepository repository})
      : _repository = repository;

  bool _isTracking = false;
  bool get isTracking => _isTracking;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  StreamSubscription<Position>? _sub;

  // 과도한 토스트를 막기 위한 간단한 스로틀(선택)
  DateTime? _lastToastAt;

  bool _canShowToast({Duration minGap = const Duration(seconds: 3)}) {
    final now = DateTime.now();
    if (_lastToastAt == null) {
      _lastToastAt = now;
      return true;
    }
    if (now.difference(_lastToastAt!) >= minGap) {
      _lastToastAt = now;
      return true;
    }
    return false;
  }

  /// RootTab 진입 직후 1회 호출:
  /// - 권한 확보
  /// - 현재 위치 1회 업데이트 (토스트로 성공/실패 표시)
  /// - 이후 스트림으로 주기 업데이트 (토스트는 스로틀로 너무 자주 안 뜨게)
  Future<void> startTracking(BuildContext context) async {
    if (_isTracking) return;

    _errorMessage = null;
    notifyListeners();

    final ok = await _ensurePermission(context);
    if (!ok) return;

    _isTracking = true;
    notifyListeners();

    // 1) 최초 1회 업데이트
    await _sendCurrentLocationOnce(context);

    // 2) 이후 스트림 업데이트
    await _sub?.cancel();
    _sub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50, // 50m 이동 시
      ),
    ).listen(
          (pos) async {
        try {
          await _repository.updateLocation(
            latitude: pos.latitude,
            longitude: pos.longitude,
          );

          // 스트림에서는 너무 자주 뜨면 방해되니 3초 스로틀
          if (_canShowToast(minGap: const Duration(seconds: 3))) {
            AppToast.show(
              context,
              '위치 업데이트 성공 (${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)})',
              duration: const Duration(seconds: 1),
            );
          }
        } catch (e) {
          // 실패도 너무 자주 뜨면 지저분해지니 동일하게 스로틀
          if (_canShowToast(minGap: const Duration(seconds: 3))) {
            AppToast.show(
              context,
              '위치 업데이트 실패: $e',
              duration: const Duration(seconds: 2),
            );
          }
        }
      },
      onError: (e) {
        _errorMessage = '위치 추적 중 오류가 발생했습니다.';
        notifyListeners();

        AppToast.show(
          context,
          '위치 스트림 오류: $e',
          duration: const Duration(seconds: 2),
        );
      },
    );
  }

  Future<void> stopTracking() async {
    _isTracking = false;
    await _sub?.cancel();
    _sub = null;
    notifyListeners();
  }

  Future<void> _sendCurrentLocationOnce(BuildContext context) async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await _repository.updateLocation(
        latitude: pos.latitude,
        longitude: pos.longitude,
      );

      AppToast.show(
        context,
        '초기 위치 업데이트 성공 (${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)})',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _errorMessage = '현재 위치를 가져오지 못했습니다.';
      notifyListeners();

      AppToast.show(
        context,
        '초기 위치 업데이트 실패: $e',
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// 권한/서비스 체크에서도 토스트로 즉시 확인 가능하게 처리
  Future<bool> _ensurePermission(BuildContext context) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _errorMessage = '위치 서비스가 꺼져 있습니다. 설정에서 켜주세요.';
      notifyListeners();

      AppToast.show(context, _errorMessage!, duration: const Duration(seconds: 2));
      return false;
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      _errorMessage = '위치 권한이 거부되었습니다.';
      notifyListeners();

      AppToast.show(context, _errorMessage!, duration: const Duration(seconds: 2));
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      _errorMessage = '위치 권한이 영구 거부되었습니다. 설정에서 허용해주세요.';
      notifyListeners();

      AppToast.show(context, _errorMessage!, duration: const Duration(seconds: 2));
      await Geolocator.openAppSettings();
      return false;
    }

    // iOS “항상 허용”은 단번에 강제 불가. 여기서는 OK로만 처리.
    AppToast.show(context, '위치 권한 확인 완료', duration: const Duration(seconds: 1));
    return true;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
