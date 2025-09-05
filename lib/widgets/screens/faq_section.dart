import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_kariera/const/app_colors.dart';
import 'package:pro_kariera/l10n/app_localizations.dart';
import 'package:pro_kariera/firebase/firestore_content_service.dart';

class FaqSection extends StatefulWidget {
  const FaqSection({super.key});

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  int? _expandedIndex;

  void _toggleIndex(int index) {
    setState(() {
      _expandedIndex = (_expandedIndex == index) ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.of(context).size.width < 1000;

    final appLang = Localizations.localeOf(context).languageCode;
    final localeKey = appLang == 'uk' ? 'ua' : appLang;

    return StreamBuilder<Map<String, String>>(
      stream: FirestoreContentService.instance.watchFaq(localeKey),
      builder: (context, snapshot) {
        final faq = snapshot.data ?? {};
        // Собираем пары faqQ{N} → faqA{N}, игнорируя прочие ключи (например, faqTitle)
        final qRe = RegExp(r'^faqQ(\d+)$');
        final items = <FaqItem>[];

        final qEntries = faq.entries.where((e) => qRe.hasMatch(e.key)).toList()
          ..sort((a, b) {
            final ia = int.parse(qRe.firstMatch(a.key)!.group(1)!);
            final ib = int.parse(qRe.firstMatch(b.key)!.group(1)!);
            return ia.compareTo(ib);
          });

        for (final e in qEntries) {
          final idx = int.parse(qRe.firstMatch(e.key)!.group(1)!);
          final q = e.value;
          final a = faq['faqA$idx'] ?? '';
          if (q.toString().trim().isEmpty && a.toString().trim().isEmpty)
            continue;
          items.add(FaqItem(q, a));
        }

        // Если из БД ничего не пришло — используем фоллбэк из локализаций
        if (items.isEmpty) {
          items.addAll([
            FaqItem(t.faqQ1, t.faqA1),
            FaqItem(t.faqQ2, t.faqA2),
            FaqItem(t.faqQ3, t.faqA3),
            FaqItem(t.faqQ4, t.faqA4),
            FaqItem(t.faqQ5, t.faqA5),
            FaqItem(t.faqQ6, t.faqA6),
          ]);
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: isMobile
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Text(
                t.faqTitle,
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 22 : 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              ...List.generate(items.length, (index) {
                return _CustomFaqTile(
                  index: index,
                  item: items[index],
                  isOpen: _expandedIndex == index,
                  onToggle: () => _toggleIndex(index),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class FaqItem {
  final String question;
  final String answer;
  FaqItem(this.question, this.answer);
}

class _CustomFaqTile extends StatelessWidget {
  final int index;
  final FaqItem item;
  final bool isOpen;
  final VoidCallback onToggle;

  const _CustomFaqTile({
    required this.index,
    required this.item,
    required this.isOpen,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(245, 245, 245, 1),
        border: Border.all(
          color: const Color.fromRGBO(144, 202, 249, 1),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          if (isOpen)
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.question,
                      style: GoogleFonts.rubik(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 28,
                      color: AppColors.secondaryLight,
                    ),
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    item.answer,
                    style: GoogleFonts.rubik(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                crossFadeState: isOpen
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 180),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
