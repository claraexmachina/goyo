// 기도 설정 모델

class PrayerSettings {
  final String? intention; // 청원 내용
  final DateTime? startDate; // 시작일

  PrayerSettings({
    this.intention,
    this.startDate,
  });

  // 마지막일 계산 (시작일로부터 54일째)
  DateTime? get endDate {
    if (startDate == null) return null;
    return startDate!.add(const Duration(days: 53)); // 시작일이 1일이므로 53일 추가
  }

  // 오늘이 몇일째인지 계산 (KST 기준)
  int? get currentDay {
    if (startDate == null) return null;
    final now = DateTime.now();
    final kstNow = now.toUtc().add(const Duration(hours: 9));
    final kstStartDate = DateTime(startDate!.year, startDate!.month, startDate!.day);
    final kstToday = DateTime(kstNow.year, kstNow.month, kstNow.day);

    final difference = kstToday.difference(kstStartDate).inDays;
    if (difference < 0) return null; // 아직 시작 전
    if (difference >= 54) return null; // 이미 끝남
    return difference + 1; // 시작일이 1일
  }

  // 청원 기도인지 감사 기도인지 (1-27일: 청원, 28-54일: 감사)
  bool get isPetition {
    final day = currentDay;
    if (day == null) return true;
    return day <= 27;
  }

  // 기도 유형 문자열
  String get prayerType {
    return isPetition ? '청원' : '감사';
  }

  // 설정이 완료되었는지 확인
  bool get isConfigured {
    return intention != null && intention!.isNotEmpty && startDate != null;
  }

  // 기도가 진행 중인지 확인
  bool get isInProgress {
    final day = currentDay;
    return day != null && day >= 1 && day <= 54;
  }

  // JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'intention': intention,
      'startDate': startDate?.toIso8601String(),
    };
  }

  // JSON에서 생성
  factory PrayerSettings.fromJson(Map<String, dynamic> json) {
    return PrayerSettings(
      intention: json['intention'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
    );
  }

  // 복사본 생성
  PrayerSettings copyWith({
    String? intention,
    DateTime? startDate,
  }) {
    return PrayerSettings(
      intention: intention ?? this.intention,
      startDate: startDate ?? this.startDate,
    );
  }
}
