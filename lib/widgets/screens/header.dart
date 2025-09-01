import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_kariera/const/app_colors.dart';
import 'package:pro_kariera/l10n/app_localizations.dart';
import 'package:pro_kariera/main.dart';

class Header extends StatelessWidget {
  final void Function(String) onItemSelected;
  const Header({required this.onItemSelected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final lang = Localizations.localeOf(context).languageCode;

    // Локальные подписи без добавления ключей в i18n:
    final homeLabel = (lang == 'de') ? 'Start' : 'Головна';
    final faqLabel = (lang == 'de') ? 'Häufige Fragen' : 'Часті запитання';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Логотип → к hero
          GestureDetector(
            onTap: () => onItemSelected('hero'),
            child: Image.asset(
              'assets/logo/proKarieraLogo.png',
              width: screenWidth >= 1200 ? 150 : 100,
              height: screenWidth >= 1200 ? 150 : 100,
            ),
          ),
          const Spacer(),

          if (screenWidth >= 1200)
            Row(
              children: [
                _HeaderItem(
                  title: homeLabel,
                  onTap: () => onItemSelected('hero'),
                ),
                _HeaderItem(
                  title: t.menuAbout,
                  onTap: () => onItemSelected('about'),
                ),
                _HeaderItem(
                  title: t.menuServices,
                  onTap: () => onItemSelected('services'),
                ),
                _HeaderItem(
                  title: t.priceTitle,
                  onTap: () => onItemSelected('price'),
                ),
                _HeaderItem(
                  title: t.menuAvgs,
                  onTap: () => onItemSelected('avgs'),
                ),
                _HeaderItem(
                  title: t.menuHowItWorks,
                  onTap: () => onItemSelected('how'),
                ),
                _HeaderItem(
                  title: t.menuTestimonials,
                  onTap: () => onItemSelected('testimonials'),
                ),
                _HeaderItem(
                  title: faqLabel,
                  onTap: () => onItemSelected('faq'),
                ),
                _HeaderItem(
                  title: t.menuContact,
                  onTap: () => onItemSelected('contact'),
                ),
              ],
            )
          else
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, size: 28),
              onSelected: onItemSelected,
              itemBuilder: (_) => [
                PopupMenuItem(value: 'hero', child: Text(homeLabel)),
                PopupMenuItem(value: 'about', child: Text(t.menuAbout)),
                PopupMenuItem(value: 'services', child: Text(t.menuServices)),
                PopupMenuItem(value: 'price', child: Text(t.priceTitle)),
                PopupMenuItem(value: 'avgs', child: Text(t.menuAvgs)),
                PopupMenuItem(value: 'how', child: Text(t.menuHowItWorks)),
                PopupMenuItem(
                  value: 'testimonials',
                  child: Text(t.menuTestimonials),
                ),
                PopupMenuItem(value: 'faq', child: Text(faqLabel)),

                PopupMenuItem(value: 'contact', child: Text(t.menuContact)),
              ],
            ),
          SizedBox(width: 24.w),
          const _LanguageSwitcher(),
        ],
      ),
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
