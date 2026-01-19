import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/prayer_settings.dart';
import '../services/prayer_service.dart';
import 'prayer_settings_screen.dart';
import 'mystery_screen.dart';
import 'main_prayers_screen.dart';
import '../data/joyful_mysteries.dart';
import '../data/luminous_mysteries.dart';
import '../data/sorrowful_mysteries.dart';
import '../data/glorious_mysteries.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PrayerService _prayerService = PrayerService();
  PrayerSettings _settings = PrayerSettings();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _prayerService.loadSettings();
    setState(() {
      _settings = settings;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.black,
            strokeWidth: 1.5,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // 앱 타이틀
                Center(
                  child: Column(
                    children: [
                      Text(
                        '고요',
                        style: GoogleFonts.notoSansKr(
                          fontSize: 32,
                          fontWeight: FontWeight.w200,
                          color: Colors.black87,
                          letterSpacing: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 24,
                        height: 1,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // 오늘 날짜 카드
                _buildDateCard(),
                const SizedBox(height: 16),

                // 기도 안내 메시지
                _buildPrayerGuide(),
                const SizedBox(height: 24),

                // 진행 상황 바
                _buildProgressBar(),
                const SizedBox(height: 32),

                // 기도 상세 설정 버튼
                _buildSettingsButton(),
                const SizedBox(height: 40),

                // 신비 버튼들
                _buildMysteryButtons(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha:0.04),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              color: Colors.black54,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _prayerService.getTodayWeekdayKorean(),
                  style: GoogleFonts.notoSansKr(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _prayerService.getTodayFormatted().replaceAll(
                      ' ${_prayerService.getTodayWeekdayKorean()}', ''),
                  style: GoogleFonts.notoSansKr(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerGuide() {
    if (!_settings.isConfigured) {
      return _buildGuideCard(
        icon: Icons.edit_outlined,
        text: '기도 설정을 완료하고\n54일 묵주기도를 시작하세요.',
        isEmptyState: true,
      );
    }

    final currentDay = _settings.currentDay;
    final mystery = _prayerService.getTodayMystery();
    final prayerType = _settings.prayerType;

    if (currentDay == null) {
      // 기도 기간이 아닌 경우 (아직 시작 전이거나 이미 끝남)
      final now = DateTime.now().toUtc().add(const Duration(hours: 9));
      final startDate = _settings.startDate!;

      if (now.isBefore(startDate)) {
        return _buildGuideCard(
          icon: Icons.schedule_outlined,
          text: '${_prayerService.formatDate(startDate)}부터\n54일 묵주기도가 시작됩니다.',
        );
      } else {
        return _buildGuideCard(
          icon: Icons.check_circle_outline,
          text: '54일 묵주기도가 완료되었습니다.\n새로운 기도를 시작하려면 설정을 수정해주세요.',
          isComplete: true,
        );
      }
    }

    return Column(
      children: [
        Text(
          '오늘은 묵주기도 $currentDay일째',
          style: GoogleFonts.notoSansKr(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$prayerType 기도 · $mystery',
          style: GoogleFonts.notoSansKr(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildGuideCard({
    required IconData icon,
    required String text,
    bool isEmptyState = false,
    bool isComplete = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isComplete
                  ? Colors.green.withValues(alpha:0.1)
                  : Colors.black.withValues(alpha:0.04),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: isComplete ? Colors.green : Colors.black45,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: GoogleFonts.notoSansKr(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final currentDay = _settings.currentDay ?? 0;
    final progress = currentDay / 54;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '진행 상황',
                style: GoogleFonts.notoSansKr(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha:0.04),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$currentDay / 54일',
                  style: GoogleFonts.notoSansKr(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.black87, Colors.black54],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentDay <= 27 ? '청원 기도' : '감사 기도',
                style: GoogleFonts.notoSansKr(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black38,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}% 완료',
                style: GoogleFonts.notoSansKr(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha:0.15)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PrayerSettingsScreen(),
              ),
            );
            _loadSettings();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.settings_outlined,
                size: 20,
                color: Colors.black.withValues(alpha:0.6),
              ),
              const SizedBox(width: 10),
              Text(
                '기도 상세 설정',
                style: GoogleFonts.notoSansKr(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMysteryButtons() {
    final todayMystery = _prayerService.getTodayMystery();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            '기도문',
            style: GoogleFonts.notoSansKr(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildMysteryButton(
          '환희의 신비',
          subtitle: '월요일 · 토요일',
          isHighlighted: todayMystery == '환희의 신비',
          onPressed: () => _navigateToMystery('환희의 신비'),
        ),
        const SizedBox(height: 12),
        _buildMysteryButton(
          '빛의 신비',
          subtitle: '목요일',
          isHighlighted: todayMystery == '빛의 신비',
          onPressed: () => _navigateToMystery('빛의 신비'),
        ),
        const SizedBox(height: 12),
        _buildMysteryButton(
          '고통의 신비',
          subtitle: '화요일 · 금요일',
          isHighlighted: todayMystery == '고통의 신비',
          onPressed: () => _navigateToMystery('고통의 신비'),
        ),
        const SizedBox(height: 12),
        _buildMysteryButton(
          '영광의 신비',
          subtitle: '수요일 · 일요일',
          isHighlighted: todayMystery == '영광의 신비',
          onPressed: () => _navigateToMystery('영광의 신비'),
        ),
        const SizedBox(height: 12),
        _buildMysteryButton(
          '주요 기도문',
          subtitle: '사도신경, 주님의 기도, 성모송 등',
          isHighlighted: false,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MainPrayersScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMysteryButton(
    String title, {
    required String subtitle,
    required bool isHighlighted,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:isHighlighted ? 0.15 : 0.04),
            blurRadius: isHighlighted ? 15 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.notoSansKr(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color:
                                  isHighlighted ? Colors.white : Colors.black87,
                            ),
                          ),
                          if (isHighlighted) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha:0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '오늘',
                                style: GoogleFonts.notoSansKr(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.notoSansKr(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: isHighlighted
                              ? Colors.white60
                              : Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isHighlighted ? Colors.white54 : Colors.black26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToMystery(String mysteryType) {
    List<Map<String, String>> mysteries;
    String title;

    switch (mysteryType) {
      case '환희의 신비':
        mysteries = JoyfulMysteries.mysteries;
        title = JoyfulMysteries.title;
        break;
      case '빛의 신비':
        mysteries = LuminousMysteries.mysteries;
        title = LuminousMysteries.title;
        break;
      case '고통의 신비':
        mysteries = SorrowfulMysteries.mysteries;
        title = SorrowfulMysteries.title;
        break;
      case '영광의 신비':
        mysteries = GloriousMysteries.mysteries;
        title = GloriousMysteries.title;
        break;
      default:
        mysteries = JoyfulMysteries.mysteries;
        title = JoyfulMysteries.title;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MysteryScreen(
          title: title,
          mysteries: mysteries,
          isPetition: _settings.isPetition,
        ),
      ),
    );
  }
}
