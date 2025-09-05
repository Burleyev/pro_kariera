import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_kariera/const/app_colors.dart';
import 'package:pro_kariera/l10n/app_localizations.dart';
import 'package:pro_kariera/firebase/firestore_content_service.dart';
import 'package:pro_kariera/widgets/net_photo.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.onBookPressed});
  final VoidCallback onBookPressed;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final appLang = Localizations.localeOf(context).languageCode; // 'uk' | 'de'
    final localeKey = appLang == 'uk' ? 'ua' : appLang;

    // Фоллбэки на i18n
    final fallbacks = {
      'heroTitle': t.heroTitle,
      'heroSubtitle': t.heroSubtitle,
      'heroButton': t.heroButton,
    };

    return StreamBuilder<Map<String, dynamic>>(
      stream: FirestoreContentService.instance.watchHero(localeKey),
      builder: (context, snap) {
        final data = (snap.data ?? const <String, dynamic>{});
        final title = (data['heroTitle'] as String?) ?? fallbacks['heroTitle']!;
        final subtitle =
            (data['heroSubtitle'] as String?) ?? fallbacks['heroSubtitle']!;
        final buttonText =
            (data['heroButton'] as String?) ?? fallbacks['heroButton']!;
        final heroImageUrl = (data['heroImageUrl'] as String?)?.trim() ?? '';

        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            if (screenWidth >= 1200) {
              return _HeroDesktop(
                title: title,
                subtitle: subtitle,
                buttonText: buttonText,
                imageUrl: heroImageUrl,
                screenWidth: screenWidth,
                onBookPressed: onBookPressed,
              );
            } else {
              return _HeroMobile(
                title: title,
                subtitle: subtitle,
                buttonText: buttonText,
                imageUrl: heroImageUrl,
                onBookPressed: onBookPressed,
              );
            }
          },
        );
      },
    );
  }
}

class _HeroDesktop extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String imageUrl;
  final double screenWidth;
  final VoidCallback onBookPressed;

  const _HeroDesktop({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imageUrl,
    required this.screenWidth,
    required this.onBookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 40.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: screenWidth * 0.5,
            height: 600.h,
            child: Stack(
              children: [
                Positioned(
                  left: screenWidth * 0.05,
                  top: 5.h,
                  child: Container(
                    width: screenWidth * 0.25,
                    height: 300.h,
                    color: AppColors.secondaryLight,
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.19,
                  top: 30.h,
                  child: SizedBox(
                    height: 500.h,

                    child: NetPhoto(
                      url: imageUrl,
                      fallback: "assets/fotoHeroDes.jpeg",
                      h: 500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 40.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.rubik(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    height: 1.1,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: onBookPressed,
                  child: Text(
                    buttonText,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.warmAccent,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMobile extends StatelessWidget {
  const _HeroMobile({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imageUrl,
    required this.onBookPressed,
  });
  final String title;
  final String subtitle;
  final String buttonText;
  final String imageUrl;
  final VoidCallback onBookPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NetPhoto(url: imageUrl, fallback: "assets/fotoHeroDes.jpeg", h: 300),

          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onBookPressed,
            child: Text(
              buttonText,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.warmAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
