class Formatters {
  const Formatters._();

  static String ymd(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// 1234567 -> "1,234,567"
  /// - signed=true면 음수는 "-1,234" 형태 유지
  static String money(int value, {bool signed = true}) {
    final absStr = value.abs().toString();
    final buf = StringBuffer();

    for (int i = 0; i < absStr.length; i++) {
      final idxFromEnd = absStr.length - i;
      buf.write(absStr[i]);

      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
        buf.write(',');
      }
    }

    final out = buf.toString();

    if (!signed) return out;
    return value < 0 ? '-$out' : out;
  }

  /// "1,234원" / "-1,234원"
  static String moneyWon(int value, {bool signed = true}) {
    return '${money(value, signed: signed)}원';
  }
}
