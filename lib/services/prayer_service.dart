import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_settings.dart';

class PrayerService {
  static const String _settingsKey = 'prayer_settings';

  // 설정 저장
  Future<void> saveSettings(PrayerSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(settings.toJson());
    await prefs.setString(_settingsKey, json);
  }

  // 설정 로드
  Future<PrayerSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_settingsKey);
    if (json == null) {
      return PrayerSettings();
    }
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return PrayerSettings.fromJson(map);
    } catch (e) {
      return PrayerSettings();
    }
  }

  // 오늘의 신비 가져오기 (요일 기준)
  // 월요일, 토요일: 환희의 신비
  // 목요일: 빛의 신비
  // 화요일, 금요일: 고통의 신비
  // 수요일, 일요일: 영광의 신비
  String getTodayMystery() {
    final now = DateTime.now();
    final kstNow = now.toUtc().add(const Duration(hours: 9));
    final weekday = kstNow.weekday; // 1 = 월요일, 7 = 일요일

    switch (weekday) {
      case 1: // 월요일
      case 6: // 토요일
        return '환희의 신비';
      case 4: // 목요일
        return '빛의 신비';
      case 2: // 화요일
      case 5: // 금요일
        return '고통의 신비';
      case 3: // 수요일
      case 7: // 일요일
        return '영광의 신비';
      default:
        return '환희의 신비';
    }
  }

  // 오늘의 요일 한국어로 가져오기
  String getTodayWeekdayKorean() {
    final now = DateTime.now();
    final kstNow = now.toUtc().add(const Duration(hours: 9));
    final weekday = kstNow.weekday;

    const weekdays = ['', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    return weekdays[weekday];
  }

  // 오늘 날짜 포맷팅 (KST)
  String getTodayFormatted() {
    final now = DateTime.now();
    final kstNow = now.toUtc().add(const Duration(hours: 9));
    return '${kstNow.year}년 ${kstNow.month}월 ${kstNow.day}일 ${getTodayWeekdayKorean()}';
  }

  // 날짜 포맷팅
  String formatDate(DateTime date) {
    return '${date.month}월 ${date.day}일 ${date.year}년';
  }
}
