import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_kariera/const/app_colors.dart';
import 'package:pro_kariera/l10n/app_localizations.dart';
import 'package:pro_kariera/widgets/photo.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.onBookPressed});
  final VoidCallback onBookPressed;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        if (screenWidth >= 1200) {
          return _HeroDesktop(
            t: t,
            screenWidth: screenWidth,
            onBookPressed: onBookPressed, // <-- передаём
          );
        } else {
          return _HeroMobile(
            onBookPressed: onBookPressed, // <-- передаём
          );
        }
      },
    );
  }
}

class _HeroDesktop extends StatelessWidget {
  final AppLocalizations t;
  final double screenWidth;
  final VoidCallback onBookPressed; // <-- объявили поле

  const _HeroDesktop({
    required this.t,
    required this.screenWidth,
    required this.onBookPressed, // <-- потребовали в конструкторе
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
                    child: Photo(asset: "assets/fotoHeroDes.jpeg", h: 500.h),
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
                  t.heroTitle,
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
                  t.heroSubtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: onBookPressed, // <-- работает
                  child: Text(
                    t.heroButton,
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
  const _HeroMobile({required this.onBookPressed});
  final VoidCallback onBookPressed;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Photo(asset: "assets/fotoHeroDes.jpeg", h: 300),
          const SizedBox(height: 24),
          Text(
            t.heroTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            t.heroSubtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onBookPressed, // <-- вызывем колбэк
            child: Text(
              t.heroButton,
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
