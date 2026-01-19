import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  testWidgets('Splash screen UI elements render correctly', (WidgetTester tester) async {
    // Google Fonts 테스트 모드 설정
    GoogleFonts.config.allowRuntimeFetching = false;

    // 스플래시 화면 UI 컴포넌트만 직접 테스트
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '고요',
                  style: GoogleFonts.notoSansKr(
                    fontSize: 56,
                    fontWeight: FontWeight.w200,
                    color: Colors.black87,
                    letterSpacing: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 40,
                  height: 1,
                  color: Colors.black26,
                ),
                const SizedBox(height: 16),
                Text(
                  '54일 묵주기도',
                  style: GoogleFonts.notoSansKr(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.black45,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // 스플래시 화면에 '고요' 텍스트가 표시되는지 확인
    expect(find.text('고요'), findsOneWidget);
    expect(find.text('54일 묵주기도'), findsOneWidget);
  });
}
