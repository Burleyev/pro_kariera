import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:pro_kariera/const/app_colors.dart';
import 'package:pro_kariera/l10n/app_localizations.dart';

class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1200;

    final title = t.servicesTitle;
    // Собираем статический список услуг из ARB (uk/de)
    final items = <_ServiceData>[];
    void addIfNotEmpty(String ttl, String dsc, IconData icon) {
      if (ttl.trim().isEmpty && dsc.trim().isEmpty) return;
      items.add(_ServiceData(title: ttl, text: dsc, icon: icon));
    }

    addIfNotEmpty(t.service1Title, t.service1Desc, Icons.construction);
    addIfNotEmpty(t.service2Title, t.service2Desc, Icons.handyman);
    addIfNotEmpty(t.service3Title, t.service3Desc, Icons.plumbing);
    addIfNotEmpty(t.service4Title, t.service4Desc, Icons.school_outlined);
    addIfNotEmpty(t.service5Title, t.service5Desc, Icons.trending_up);

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
  }

  IconData _getIconByIndex(int index) {
    switch (index) {
      case 1:
        return Icons.description_outlined;
      case 2:
        return Icons.record_voice_over;
      case 3:
        return Icons.assignment_turned_in;
      case 4:
        return Icons.school_outlined;
      case 5:
        return Icons.trending_up;

      default:
        return Icons.work_outline;
    }
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
