import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_kariera/const/app_colors.dart';
import 'package:pro_kariera/firebase/firestore_content_service.dart';
import 'package:pro_kariera/l10n/app_localizations.dart';
import 'package:pro_kariera/main.dart';

class Header extends StatelessWidget {
  final void Function(String) onItemSelected;
  const Header({required this.onItemSelected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    // В приложении локаль 'uk', а в Firestore документ называется 'ua'.
    final appLang = Localizations.localeOf(context).languageCode; // 'uk' | 'de'
    final localeKey = appLang == 'uk' ? 'ua' : appLang;

    // Фоллбэки (если в Firestore нет значений)
    final fallbacks = <String, String>{
      'menuHero': (appLang == 'de') ? 'Start' : 'Головна',
      'menuAbout': t.menuAbout,
      'menuServices': t.menuServices,
      'menuPrice': t.priceTitle,
      'menuAvgs': t.menuAvgs,
      'menuHowItWorks': t.menuHowItWorks,
      'menuTestimonials': t.menuTestimonials,
      'menuFaq': (appLang == 'de') ? 'Häufige Fragen' : 'Часті запитання',
      'menuContact': t.menuContact,
    };

    return StreamBuilder<Map<String, dynamic>>(
      stream: FirestoreContentService.instance.watchHeaderMenu(localeKey),
      builder: (context, snapshot) {
        final headerMap = (snapshot.data ?? const <String, dynamic>{});
        final String logoUrl = (headerMap['logoUrl'] as String?)?.trim() ?? '';
        String lbl(String key) =>
            (headerMap[key] as String?) ?? fallbacks[key]!;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Логотип → к hero
              GestureDetector(
                onTap: () => onItemSelected('hero'),
                child: SizedBox(
                  width: screenWidth >= 1200 ? 150 : 100,
                  height: screenWidth >= 1200 ? 150 : 100,
                  child: logoUrl.isNotEmpty
                      ? Image.network(
                          logoUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/logo/proKarieraLogo.png',
                            fit: BoxFit.contain,
                          ),
                        )
                      : Image.asset(
                          'assets/logo/proKarieraLogo.png',
                          fit: BoxFit.contain,
                        ),
                ),
              ),
              const Spacer(),

              if (screenWidth >= 1200)
                Row(
                  children: [
                    _HeaderItem(
                      title: lbl('menuHero'),
                      onTap: () => onItemSelected('hero'),
                    ),
                    _HeaderItem(
                      title: lbl('menuAbout'),
                      onTap: () => onItemSelected('about'),
                    ),
                    _HeaderItem(
                      title: lbl('menuServices'),
                      onTap: () => onItemSelected('services'),
                    ),
                    _HeaderItem(
                      title: lbl('menuPrice'),
                      onTap: () => onItemSelected('price'),
                    ),
                    _HeaderItem(
                      title: lbl('menuAvgs'),
                      onTap: () => onItemSelected('avgs'),
                    ),
                    _HeaderItem(
                      title: lbl('menuHowItWorks'),
                      onTap: () => onItemSelected('how'),
                    ),
                    _HeaderItem(
                      title: lbl('menuTestimonials'),
                      onTap: () => onItemSelected('testimonials'),
                    ),
                    _HeaderItem(
                      title: lbl('menuFaq'),
                      onTap: () => onItemSelected('faq'),
                    ),
                    _HeaderItem(
                      title: lbl('menuContact'),
                      onTap: () => onItemSelected('contact'),
                    ),
                  ],
                )
              else
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu, size: 28),
                  onSelected: onItemSelected,
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'hero', child: Text(lbl('menuHero'))),
                    PopupMenuItem(
                      value: 'about',
                      child: Text(lbl('menuAbout')),
                    ),
                    PopupMenuItem(
                      value: 'services',
                      child: Text(lbl('menuServices')),
                    ),
                    PopupMenuItem(
                      value: 'price',
                      child: Text(lbl('menuPrice')),
                    ),
                    PopupMenuItem(value: 'avgs', child: Text(lbl('menuAvgs'))),
                    PopupMenuItem(
                      value: 'how',
                      child: Text(lbl('menuHowItWorks')),
                    ),
                    PopupMenuItem(
                      value: 'testimonials',
                      child: Text(lbl('menuTestimonials')),
                    ),
                    PopupMenuItem(value: 'faq', child: Text(lbl('menuFaq'))),
                    PopupMenuItem(
                      value: 'contact',
                      child: Text(lbl('menuContact')),
                    ),
                  ],
                ),

              SizedBox(width: 24.w),
              const _LanguageSwitcher(),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _HeaderItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageSwitcher extends StatelessWidget {
  const _LanguageSwitcher();

  @override
  Widget build(BuildContext context) {
    final current = Localizations.localeOf(context).languageCode;

    void choose(String code) {
      AppRoot.of(context)?.setLocale(Locale(code));
    }

    return Row(
      children: [
        GestureDetector(
          onTap: () => choose('uk'),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: current == 'uk' ? 2 : 0),
            ),
            child: Column(
              children: [
                Container(color: Colors.lightBlue, height: 10.5, width: 40),
                Container(
                  color: Colors.yellowAccent.shade700,
                  height: 10.5,
                  width: 40,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 4.w),
        const Text('|'),
        SizedBox(width: 4.w),
        GestureDetector(
          onTap: () => choose('de'),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: current == 'de' ? 2 : 0),
            ),
            child: Column(
              children: [
                Container(color: Colors.black, height: 7, width: 40),
                Container(color: Colors.red, height: 7, width: 40),
                Container(color: Colors.yellow, height: 7, width: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
