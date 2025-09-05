import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_kariera/const/app_colors.dart';
import 'package:pro_kariera/l10n/app_localizations.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:pro_kariera/firebase/firestore_content_service.dart';

class HowIWork extends StatelessWidget {
  const HowIWork({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1200;
    return isMobile ? const MobileHowIWork() : const DesktopHowIWork();
  }
}

// --------- DESKTOP ---------
class DesktopHowIWork extends StatefulWidget {
  const DesktopHowIWork({super.key});

  @override
  _DesktopHowIWorkState createState() => _DesktopHowIWorkState();
}

class _DesktopHowIWorkState extends State<DesktopHowIWork>
    with TickerProviderStateMixin {
  late final AnimationController _lineController;
  late final Animation<double> _leftWidth;
  late final Animation<double> _rightWidth;
  late final List<AnimationController> _blockControllers;

  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _leftWidth = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeInOut),
    );
    _rightWidth = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeInOut),
    );
    _blockControllers = List.generate(
      4,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    await _lineController.forward();
    for (final controller in _blockControllers) {
      if (!mounted) return;
      await controller.forward();
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  void dispose() {
    _lineController.dispose();
    for (final c in _blockControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    final appLang = Localizations.localeOf(context).languageCode;
    final localeKey = appLang == 'uk' ? 'ua' : appLang;

    return StreamBuilder<Map<String, dynamic>>(
      stream: FirestoreContentService.instance.watchHowItWorks(localeKey),
      builder: (context, snapshot) {
        final data = snapshot.data ?? {};
        final title = data['howItWorksTitle'] ?? t.howItWorksTitle;
        final step1Title = data['step1Title'] ?? t.step1Title;
        final step1Desc = data['step1Desc'] ?? t.step1Desc;
        final step2Title = data['step2Title'] ?? t.step2Title;
        final step2Desc = data['step2Desc'] ?? t.step2Desc;
        final step3Title = data['step3Title'] ?? t.step3Title;
        final step3Desc = data['step3Desc'] ?? t.step3Desc;
        final step4Title = data['step4Title'] ?? t.step4Title;
        final step4Desc = data['step4Desc'] ?? t.step4Desc;

        return VisibilityDetector(
          key: const Key('desktop-how-i-work'),
          onVisibilityChanged: (info) {
            if (!_hasAnimated && info.visibleFraction > 0.3) {
              _hasAnimated = true;
              _startAnimations();
            }
          },
          child: SizedBox(
            width: screenWidth,
            height: 800.h,
            child: Stack(
              children: [
                Positioned(
                  top: 50.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _lineController,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        Positioned(
                          bottom: 390.h,
                          left: 0,
                          child: Container(
                            width: screenWidth * _leftWidth.value,
                            height: 20.h,
                            color: AppColors.secondaryLight,
                          ),
                        ),
                        Positioned(
                          bottom: 390.h,
                          right: 0,
                          child: Container(
                            width: screenWidth * _rightWidth.value,
                            height: 20.h,
                            color: AppColors.secondaryLight,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                _buildBlock(
                  0,
                  left: 80.w,
                  bottom: 475.h,
                  number: '1',
                  title: step1Title,
                  description: step1Desc,
                ),
                _buildBlock(
                  1,
                  left: 480.w,
                  bottom: 125.h,
                  number: '2',
                  title: step2Title,
                  description: step2Desc,
                ),
                _buildBlock(
                  2,
                  left: 880.w,
                  bottom: 475.h,
                  number: '3',
                  title: step3Title,
                  description: step3Desc,
                ),
                _buildBlock(
                  3,
                  left: 1280.w,
                  bottom: 125.h,
                  number: '4',
                  title: step4Title,
                  description: step4Desc,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBlock(
    int index, {
    required double left,
    required double bottom,
    required String number,
    required String title,
    required String description,
  }) {
    final controller = _blockControllers[index];

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Positioned(
          left: left,
          bottom: bottom,
          child: Opacity(
            opacity: controller.value,
            child: Transform.scale(
              scale: controller.value,
              child: Container(
                width: 400.w,
                height: 200.h,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: AppColors.secondaryLight),
                  color: Colors.grey.shade200,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Text(
                        number,
                        style: GoogleFonts.rubik(
                          fontSize: 80.sp,
                          letterSpacing: 1.5.w,
                          height: 1.1,
                          color: AppColors.secondaryLight,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            description,
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// --------- MOBILE ---------
class MobileHowIWork extends StatefulWidget {
  const MobileHowIWork({super.key});

  @override
  State<MobileHowIWork> createState() => _MobileHowIWorkState();
}

class _MobileHowIWorkState extends State<MobileHowIWork>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _fadeAnimations;
  late final List<Animation<double>> _scaleAnimations;

  bool _hasAnimated = false;

  final int stepCount = 4;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      stepCount,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );

    _fadeAnimations = _controllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut))
        .toList();

    _scaleAnimations = _controllers
        .map(
          (c) => Tween<double>(
            begin: 0.9,
            end: 1.0,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut)),
        )
        .toList();
  }

  Future<void> _startAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final appLang = Localizations.localeOf(context).languageCode;
    final localeKey = appLang == 'uk' ? 'ua' : appLang;

    return StreamBuilder<Map<String, dynamic>>(
      stream: FirestoreContentService.instance.watchHowItWorks(localeKey),
      builder: (context, snapshot) {
        final data = snapshot.data ?? {};
        final title = data['howItWorksTitle'] ?? t.howItWorksTitle;
        final step1Title = data['step1Title'] ?? t.step1Title;
        final step1Desc = data['step1Desc'] ?? t.step1Desc;
        final step2Title = data['step2Title'] ?? t.step2Title;
        final step2Desc = data['step2Desc'] ?? t.step2Desc;
        final step3Title = data['step3Title'] ?? t.step3Title;
        final step3Desc = data['step3Desc'] ?? t.step3Desc;
        final step4Title = data['step4Title'] ?? t.step4Title;
        final step4Desc = data['step4Desc'] ?? t.step4Desc;

        final steps = [
          {'number': '1', 'title': step1Title, 'desc': step1Desc},
          {'number': '2', 'title': step2Title, 'desc': step2Desc},
          {'number': '3', 'title': step3Title, 'desc': step3Desc},
          {'number': '4', 'title': step4Title, 'desc': step4Desc},
        ];

        return VisibilityDetector(
          key: const Key('mobile-how-i-work'),
          onVisibilityChanged: (info) {
            if (!_hasAnimated && info.visibleFraction > 0.3) {
              _hasAnimated = true;
              _startAnimations();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                for (int i = 0; i < steps.length; i++)
                  FadeTransition(
                    opacity: _fadeAnimations[i],
                    child: ScaleTransition(
                      scale: _scaleAnimations[i],
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.secondaryLight),
                            color: Colors.grey.shade200,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Text(
                                steps[i]['number']!,
                                style: GoogleFonts.rubik(
                                  fontSize: 40,
                                  color: AppColors.secondaryLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      steps[i]['title']!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      steps[i]['desc']!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
