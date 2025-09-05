import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:pro_kariera/const/app_colors.dart';
import 'package:pro_kariera/l10n/app_localizations.dart';
import 'package:pro_kariera/firebase/firestore_content_service.dart';

class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1200;

    // Определяем локаль документа Firestore
    final appLang = Localizations.localeOf(context).languageCode; // 'uk' | 'de'
    final localeKey = appLang == 'uk' ? 'ua' : appLang;

    return StreamBuilder<Map<String, dynamic>>(
      stream: FirestoreContentService.instance.watchMap(localeKey, 'services'),
      builder: (context, snap) {
        final data = (snap.data ?? const <String, dynamic>{});

        // Заголовок секции: берём из Firestore или из локализаций
        final title = (data['servicesTitle'] as String?) ?? t.servicesTitle;

        // Собираем список услуг. Пытаемся брать пары service{N}Title/service{N}Desc
        final items = <_ServiceData>[];
        void addIfNotEmpty(String ttl, String dsc, IconData icon) {
          if (ttl.trim().isEmpty && dsc.trim().isEmpty) return;
          items.add(_ServiceData(title: ttl, text: dsc, icon: icon));
        }

        // Иконки по порядку (можешь потом заменить на свои)
        final icons = <IconData>[
          Icons.construction,
          Icons.handyman,
          Icons.plumbing,
          Icons.school_outlined,
          Icons.trending_up,
          Icons.check_circle_outline,
          Icons.build_circle_outlined,
          Icons.verified_user_outlined,
        ];

        // Пробуем заполнить до 8 карточек. Если в Firestore нет — используем ARB как запасной вариант (1..5)
        for (int i = 1; i <= 8; i++) {
          final ttlKey = 'service${i}Title';
          final dscKey = 'service${i}Desc';
          String ttl = (data[ttlKey] as String?) ?? '';
          String dsc = (data[dscKey] as String?) ?? '';

          if (ttl.isEmpty && dsc.isEmpty && i <= 5) {
            // фоллбэки из локализаций
            switch (i) {
              case 1:
                ttl = t.service1Title;
                dsc = t.service1Desc;
                break;
              case 2:
                ttl = t.service2Title;
                dsc = t.service2Desc;
                break;
              case 3:
                ttl = t.service3Title;
                dsc = t.service3Desc;
                break;
              case 4:
                ttl = t.service4Title;
                dsc = t.service4Desc;
                break;
              case 5:
                ttl = t.service5Title;
                dsc = t.service5Desc;
                break;
            }
          }

          if (ttl.isNotEmpty || dsc.isNotEmpty) {
            addIfNotEmpty(ttl, dsc, icons[(i - 1) % icons.length]);
          }
        }

        return Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 20 : 26.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ServicesCarousel(isMobile: isMobile, data: items),
            ],
          ),
        );
      },
    );
  }
}

class ServicesCarousel extends StatelessWidget {
  final bool isMobile;
  final List<_ServiceData> data;

  const ServicesCarousel({
    super.key,
    required this.isMobile,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    return isMobile
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i = 0; i < data.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: AnimatedServiceCard(
                        key: ValueKey('service-card-$i'),
                        isMobile: isMobile,
                        title: data[i].title,
                        text: data[i].text,
                        icon: data[i].icon,
                        delay: Duration(milliseconds: 100 * (i + 1)),
                      ),
                    ),
                  ),
              ],
            ),
          )
        : SizedBox(
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                children: [
                  for (int i = 0; i < data.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedServiceCard(
                        key: ValueKey('service-card-$i'),
                        isMobile: isMobile,
                        title: data[i].title,
                        text: data[i].text,
                        icon: data[i].icon,
                        delay: Duration(milliseconds: 200 * i),
                      ),
                    ),
                ],
              ),
            ),
          );
  }
}

class AnimatedServiceCard extends StatefulWidget {
  final String title;
  final String text;
  final Duration delay;
  final bool isMobile;
  final IconData icon;

  const AnimatedServiceCard({
    required this.title,
    required this.text,
    required this.delay,
    required this.isMobile,
    required this.icon,
    super.key,
  });

  @override
  State<AnimatedServiceCard> createState() => _AnimatedServiceCardState();
}

class _AnimatedServiceCardState extends State<AnimatedServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  bool _visibleYet = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: widget.isMobile ? Offset.zero : const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _startAnimation() {
    if (!_visibleYet) {
      _visibleYet = true;
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.title),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2) _startAnimation();
      },
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            width: MediaQuery.of(context).size.width < 1200 ? 320 : 280,
            height: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: AppColors.secondaryLight),
              color: Colors.grey.shade200,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Icon(
                  widget.icon,
                  size: MediaQuery.of(context).size.width < 1200 ? 40 : 48,
                  color: AppColors.secondaryLight,
                ),
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width < 1200
                        ? 14
                        : 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width < 1200
                        ? 10
                        : 12.sp,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceData {
  final String title;
  final String text;
  final IconData icon;

  _ServiceData({required this.title, required this.text, required this.icon});
}
