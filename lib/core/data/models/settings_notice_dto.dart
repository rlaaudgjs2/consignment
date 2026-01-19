import 'package:consignment/core/data/domain/settings_notice.dart';

class SettingsNoticeDto {
  final String? title;
  final String? date;
  final String? body;

  const SettingsNoticeDto({
    this.title,
    this.date,
    this.body,
  });

  factory SettingsNoticeDto.fromJson(Map<String, dynamic> json) {
    return SettingsNoticeDto(
      title: json['title'] as String?,
      date: json['date'] as String?,
      body: json['body'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'body': body,
    };
  }

  SettingsNotice toEntity() {
    return SettingsNotice(
      title: title ?? '',
      date: date ?? '',
      body: body ?? '',
    );
  }
}
