import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_kariera/const/app_colors.dart';
import 'package:pro_kariera/l10n/app_localizations.dart';
import 'package:pro_kariera/widgets/photo_collage.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return _AboutMeDesktop(t: t);
        } else {
          return _AboutMeMobile(t);
        }
      },
    );
  }
}

class _AboutMeDesktop extends StatelessWidget {
  const _AboutMeDesktop({required this.t});

  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 600.h,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              // 🔹 ограничиваем колонку
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 660.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      t.introTitle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.rubik(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5.sp,
                        height: 1.1,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      t.introText,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.w,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      t.introText2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 100,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.w,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  Positioned(
                    right: 0,
                    child: Container(
                      width: 800.w,
                      height: 500.h,
                      color: Colors.transparent,
                    ),
                  ),
                  Positioned(right: 0, child: PhotoCollage()),
                  Positioned(right: 350.w, child: FlyInContainer()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlyInContainer extends StatefulWidget {
  const FlyInContainer({super.key});

  @override
  State<FlyInContainer> createState() => _FlyInContainerState();
}

class _FlyInContainerState extends State<FlyInContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  bool hasAnimated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(4.0, 0.0), // справа
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _startAnimation() {
    if (!hasAnimated) {
      _controller.forward();
      hasAnimated = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1200;

    return VisibilityDetector(
      key: const Key("fly-in-container"),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2) {
          _startAnimation();
        }
      },
      child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          padding: const EdgeInsets.all(16),
          width: isMobile ? double.infinity : 321.w,
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 421.w,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: isMobile
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t.advantagesTitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.rubik(
                  fontSize: isMobile ? 18 : 20.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                t.advantage,
                textAlign: TextAlign.start,
                softWrap: true,
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 13 : 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutMeMobile extends StatelessWidget {
  const _AboutMeMobile(this.t);
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 📷 Фото или коллаж
          PhotoCollage(),
          const SizedBox(height: 24),

          // Заголовок
          Container(
            color: Color.fromRGBO(245, 245, 245, 0.75),
            child: Column(
              children: [
                Text(
                  t.introTitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.rubik(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // Первый текст
                Text(
                  t.introText,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),

                // Второй текст
                Text(
                  t.introText2,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          FlyInContainer(), // 🔹 анимация блока
        ],
      ),
    );
  }
}
