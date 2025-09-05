import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_kariera/const/app_colors.dart';
import 'package:pro_kariera/l10n/app_localizations.dart';
import 'package:pro_kariera/firebase/firestore_content_service.dart';

class PriceSection extends StatelessWidget {
  const PriceSection({super.key, required this.onBookPressed});

  /// Что делать по клику на кнопку (напр. прокрутить к "contact")
  final VoidCallback onBookPressed;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 1200;

    final appLang = Localizations.localeOf(context).languageCode;
    final localeKey = appLang == 'uk' ? 'ua' : appLang;

    final fallbacks = {
      'priceTitle': t.priceTitle,
      'priceCard': t.priceCard,
      'azavNote': t.azavNote,
      'heroButton': t.heroButton,
    };

    return StreamBuilder<Map<String, dynamic>>(
      stream: FirestoreContentService.instance.watchPrice(localeKey),
      builder: (context, snapshot) {
        final data = snapshot.data ?? {};
        String getText(String key) =>
            (data[key] as String?) ?? fallbacks[key] ?? '';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1760),
              child: Column(
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.stretch,
                children: [
                  // Заголовок секции
                  Text(
                    getText('priceTitle'), // "Preis" / "Вартість"
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 20 : 26.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Акцентная карточка
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        width: 2,
                        color: AppColors.secondaryLight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 32,
                      vertical: isMobile ? 20 : 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Верх: текст и кнопка (в ряд на desktop, в колонку на mobile)
                        isMobile
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _PriceTextBlock(
                                    title: getText('priceCard'),
                                    note: getText('azavNote'),
                                    isMobile: isMobile,
                                  ),
                                  const SizedBox(height: 20),
                                  _PriceButton(
                                    isMobile: isMobile,
                                    onPressed: onBookPressed,
                                    text: getText('heroButton'),
                                  ),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // слева — текст
                                  Expanded(
                                    child: _PriceTextBlock(
                                      title: getText('priceCard'),
                                      note: getText('azavNote'),
                                      isMobile: isMobile,
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // справа — кнопка
                                  _PriceButton(
                                    isMobile: isMobile,
                                    onPressed: onBookPressed,
                                    text: getText('heroButton'),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PriceTextBlock extends StatelessWidget {
  const _PriceTextBlock({
    required this.title,
    required this.note,
    required this.isMobile,
  });

  final String title;
  final String note;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          title, // "Privates Coaching — 100 € (bis zu 90 Min.)"
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isMobile ? 16 : 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          note, // "AZAV-Zertifizierung im Prozess"
          style: TextStyle(
            fontSize: isMobile ? 13 : 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _PriceButton extends StatelessWidget {
  const _PriceButton({
    required this.isMobile,
    required this.onPressed,
    required this.text,
  });

  final bool isMobile;
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: isMobile ? double.infinity : 500),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
