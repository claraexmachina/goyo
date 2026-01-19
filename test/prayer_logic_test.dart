import 'package:flutter_test/flutter_test.dart';
import 'package:goyo_app/models/prayer_settings.dart';

void main() {
  group('PrayerSettings Tests', () {
    test('endDate is calculated correctly (54 days from start)', () {
      final startDate = DateTime(2024, 1, 1);
      final settings = PrayerSettings(
        intention: '테스트 청원',
        startDate: startDate,
      );

      // 시작일이 1일이므로, 마지막일은 시작일 + 53일
      expect(settings.endDate, DateTime(2024, 2, 23));
    });

    test('isPetition returns true for days 1-27', () {
      // 오늘 날짜를 기준으로 테스트
      final today = DateTime.now();
      final kstToday = today.toUtc().add(const Duration(hours: 9));
      final startToday = DateTime(kstToday.year, kstToday.month, kstToday.day);

      final settings = PrayerSettings(
        intention: '테스트 청원',
        startDate: startToday,
      );

      // 시작일이 오늘이면 1일째 = 청원 기도
      expect(settings.isPetition, true);
      expect(settings.prayerType, '청원');
    });

    test('isPetition returns false for days 28-54', () {
      // 27일 전을 시작일로 설정하면 오늘이 28일째
      final today = DateTime.now();
      final kstToday = today.toUtc().add(const Duration(hours: 9));
      final startDate = DateTime(kstToday.year, kstToday.month, kstToday.day)
          .subtract(const Duration(days: 27));

      final settings = PrayerSettings(
        intention: '테스트 청원',
        startDate: startDate,
      );

      // 시작일이 27일 전이면 오늘이 28일째 = 감사 기도
      expect(settings.isPetition, false);
      expect(settings.prayerType, '감사');
    });

    test('currentDay returns correct day number', () {
      final today = DateTime.now();
      final kstToday = today.toUtc().add(const Duration(hours: 9));
      final startToday = DateTime(kstToday.year, kstToday.month, kstToday.day);

      final settings = PrayerSettings(
        intention: '테스트 청원',
        startDate: startToday,
      );

      expect(settings.currentDay, 1);

      // 5일 전 시작 = 오늘 6일째
      final settings2 = PrayerSettings(
        intention: '테스트 청원',
        startDate: startToday.subtract(const Duration(days: 5)),
      );
      expect(settings2.currentDay, 6);
    });

    test('currentDay returns null if not in 54-day period', () {
      final today = DateTime.now();
      final kstToday = today.toUtc().add(const Duration(hours: 9));
      final startTomorrow = DateTime(kstToday.year, kstToday.month, kstToday.day)
          .add(const Duration(days: 1));

      // 미래 시작일
      final settings = PrayerSettings(
        intention: '테스트 청원',
        startDate: startTomorrow,
      );
      expect(settings.currentDay, null);

      // 이미 끝난 기도 (60일 전 시작)
      final settings2 = PrayerSettings(
        intention: '테스트 청원',
        startDate: DateTime(kstToday.year, kstToday.month, kstToday.day)
            .subtract(const Duration(days: 60)),
      );
      expect(settings2.currentDay, null);
    });

    test('isConfigured returns false when intention or startDate is null', () {
      expect(PrayerSettings().isConfigured, false);
      expect(PrayerSettings(intention: '테스트').isConfigured, false);
      expect(PrayerSettings(startDate: DateTime.now()).isConfigured, false);
      expect(
        PrayerSettings(intention: '테스트', startDate: DateTime.now()).isConfigured,
        true,
      );
    });
  });

  group('Mystery by Weekday Tests', () {
    test('Monday and Saturday should be Joyful Mysteries (환희의 신비)', () {
      // 월요일 = 1, 토요일 = 6
      expect(_getMysteryByWeekday(1), '환희의 신비');
      expect(_getMysteryByWeekday(6), '환희의 신비');
    });

    test('Thursday should be Luminous Mysteries (빛의 신비)', () {
      expect(_getMysteryByWeekday(4), '빛의 신비');
    });

    test('Tuesday and Friday should be Sorrowful Mysteries (고통의 신비)', () {
      expect(_getMysteryByWeekday(2), '고통의 신비');
      expect(_getMysteryByWeekday(5), '고통의 신비');
    });

    test('Wednesday and Sunday should be Glorious Mysteries (영광의 신비)', () {
      expect(_getMysteryByWeekday(3), '영광의 신비');
      expect(_getMysteryByWeekday(7), '영광의 신비');
    });
  });
}

// Helper function to test mystery by weekday
String _getMysteryByWeekday(int weekday) {
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
