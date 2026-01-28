import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiBaseUrl => _require('API_BASE_URL');

  static Duration get connectTimeout {
    final ms = _int('CONNECT_TIMEOUT_MS', fallback: 10000);
    return Duration(milliseconds: ms);
  }

  static Duration get receiveTimeout {
    final ms = _int('RECEIVE_TIMEOUT_MS', fallback: 15000);
    return Duration(milliseconds: ms);
  }

  static String _require(String key) {
    final v = dotenv.env[key];
    if (v == null || v.trim().isEmpty) {
      throw StateError('Missing required env key: $key');
    }
    return v;
  }

  static int _int(String key, {required int fallback}) {
    final v = dotenv.env[key];
    if (v == null || v.trim().isEmpty) return fallback;
    return int.tryParse(v) ?? fallback;
  }
}
