# 고요 (Goyo)

54일 묵주기도를 위한 Flutter 앱입니다.

## 소개

고요는 가톨릭 신자들이 54일 묵주기도를 체계적으로 바칠 수 있도록 돕는 앱입니다. 54일 묵주기도는 27일간의 청원 기도와 27일간의 감사 기도로 구성됩니다.

## 주요 기능

- **54일 기도 진행 추적**: 시작일 설정 후 자동으로 현재 몇 일째인지 계산
- **청원/감사 기도 구분**: 1-27일은 청원 기도, 28-54일은 감사 기도로 자동 전환
- **요일별 신비 안내**: 오늘 바쳐야 할 신비를 자동으로 표시
  - 월요일/토요일: 환희의 신비
  - 화요일/금요일: 고통의 신비
  - 수요일/일요일: 영광의 신비
  - 목요일: 빛의 신비
- **기도문 제공**: 사도신경, 주님의 기도, 성모송 등 주요 기도문 포함
- **기도 의향 설정**: 개인 청원 내용 저장 및 관리

## 기술 스택

- **Framework**: Flutter 3.10+
- **Language**: Dart
- **State Management**: StatefulWidget
- **Local Storage**: shared_preferences
- **Typography**: Google Fonts (Noto Sans KR)

## 시작하기

### 요구사항

- Flutter SDK 3.10.7 이상
- Dart SDK 3.10.7 이상

### 설치

```bash
# 의존성 설치
flutter pub get

# 앱 실행
flutter run
```

## 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── data/
│   ├── prayers.dart          # 주요 기도문 데이터
│   ├── joyful_mysteries.dart # 환희의 신비
│   ├── luminous_mysteries.dart # 빛의 신비
│   ├── sorrowful_mysteries.dart # 고통의 신비
│   └── glorious_mysteries.dart # 영광의 신비
├── models/
│   └── prayer_settings.dart  # 기도 설정 모델
├── services/
│   └── prayer_service.dart   # 기도 관련 비즈니스 로직
└── screens/
    ├── splash_screen.dart    # 스플래시 화면
    ├── home_screen.dart      # 홈 화면
    ├── prayer_settings_screen.dart # 기도 설정 화면
    ├── prayer_edit_screen.dart # 기도 편집 화면
    ├── mystery_screen.dart   # 신비 상세 화면
    └── main_prayers_screen.dart # 주요 기도문 화면
```

## 라이선스

이 프로젝트는 개인 사용 목적으로 제작되었습니다.
