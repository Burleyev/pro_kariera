import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_kariera/const/app_colors.dart';
import 'package:pro_kariera/l10n/app_localizations.dart';
import 'package:pro_kariera/widgets/photo.dart';
import 'package:pro_kariera/widgets/net_photo.dart';
import 'package:pro_kariera/firebase/firestore_content_service.dart';

class Avgs extends StatefulWidget {
  const Avgs({super.key});

  @override
  State<Avgs> createState() => _AvgsState();
}

class _AvgsState extends State<Avgs> {
  int? _openIndex;

  void _handleToggle(int index) {
    setState(() {
      _openIndex = _openIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final isDe = lang == 'de';

    final appLang = Localizations.localeOf(context).languageCode; // 'uk' | 'de'
    final localeKey = appLang == 'uk' ? 'ua' : appLang;

    // Локальные фоллбэки на случай пустых данных из Firestore
    const titlesUkFallback = [
      '❓ Що таке AVGS?',
      '❓ Хто має право на AVGS?',
      '❓ Що покриває AVGS?',
      '❓ Як отримати AVGS?',
      '❓ Чи можна самостійно обрати коуча?',
    ];
    const titlesDeFallback = [
      '❓ Was ist AVGS?',
      '❓ Wer hat Anspruch auf AVGS?',
      '❓ Was deckt AVGS ab?',
      '❓ Wie beantragt man AVGS?',
      '❓ Kann man den Coach selbst wählen?',
    ];
    const answersUkFallback = [
      'AVGS (Aktivierungs- und Vermittlungsgutschein) — це ваучер від Jobcenter або Agentur für Arbeit, який дозволяє безкоштовно пройти коучинг, курс або отримати підтримку в пошуку роботи.',
      'AVGS можуть отримати безробітні, особи у відпустці по догляду за дитиною, новоприбулі, біженці та інші, хто шукає роботу.',
      'AVGS покриває коучинг, допомогу з резюме, підготовку до співбесід, підтримку з відкриттям бізнесу або визнанням дипломів.',
      'Потрібно звернутися до Jobcenter або Agentur für Arbeit, пояснити свою ціль та запитати про можливість отримання ваучера.',
      'Так, головне — щоб обраний коуч або організація мали сертифікат AZAV.',
    ];
    const answersDeFallback = [
      'AVGS (Aktivierungs- und Vermittlungsgutschein) ist ein Gutschein vom Jobcenter oder der Agentur für Arbeit, mit dem man kostenlos ein Coaching, einen Kurs oder Unterstützung bei der Jobsuche erhalten kann.',
      'Anspruch haben u. a. Arbeitslose, Personen in Elternzeit, Neuankömmlinge, Geflüchtete und andere Arbeitssuchende.',
      'AVGS deckt Coaching, Hilfe bei Bewerbungsunterlagen, Interviewvorbereitung, Gründungsberatung sowie Unterstützung bei der Anerkennung von Abschlüssen ab.',
      'Wenden Sie sich an das Jobcenter oder die Agentur für Arbeit, erklären Sie Ihr Ziel und fragen Sie nach einem AVGS.',
      'Ja, solange der gewählte Coach/Anbieter AZAV-zertifiziert ist.',
    ];

    return StreamBuilder<Map<String, dynamic>>(
      stream: FirestoreContentService.instance.watchAvgs(localeKey),
      builder: (context, snap) {
        final avgs = snap.data ?? const <String, dynamic>{};

        // Тексты статуса
        final statusTitle =
            (avgs['avgsStatusTitle'] as String?) ?? t.avgsStatusTitle;
        final statusText =
            (avgs['avgsStatusText'] as String?) ?? t.avgsStatusText;

        final imageUrl = (avgs['imageUrl'] as String?)?.trim() ?? '';

        // Массивы FAQ: пробуем язык интерфейса, если нет — берём украинскую версию, если и её нет — фоллбэк-константы
        List<String> _asStringList(dynamic v) => (v is List)
            ? v.map((e) => e?.toString() ?? '').toList()
            : const <String>[];

        List<String> titles = [];
        List<String> answers = [];

        if (appLang == 'de') {
          titles = _asStringList(avgs['titlesDe']);
          answers = _asStringList(avgs['answersDe']);
          if (titles.isEmpty) titles = _asStringList(avgs['titlesUk']);
          if (answers.isEmpty) answers = _asStringList(avgs['answersUk']);
          if (titles.isEmpty) titles = titlesDeFallback;
          if (answers.isEmpty) answers = answersDeFallback;
        } else {
          titles = _asStringList(avgs['titlesUk']);
          answers = _asStringList(avgs['answersUk']);
          if (titles.isEmpty) titles = titlesUkFallback;
          if (answers.isEmpty) answers = answersUkFallback;
        }

        final isMobile = MediaQuery.of(context).size.width < 1200;

        final textCol = ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isMobile ? 800 : 560),
          child: Column(
            crossAxisAlignment: isMobile
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Text(
                statusTitle,
                textAlign: isMobile ? TextAlign.center : TextAlign.start,
                style: GoogleFonts.rubik(
                  fontSize: isMobile ? 22 : 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(width: 2, color: AppColors.secondaryLight),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  textAlign: isMobile ? TextAlign.center : TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 13.5 : 14,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // FAQ-спойлеры из Firestore
              ...List.generate(
                (titles.length < answers.length)
                    ? titles.length
                    : answers.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _FaqSpoiler(
                    index: index,
                    isOpen: _openIndex == index,
                    onToggle: () => _handleToggle(index),
                    title: titles[index],
                    answer: answers[index],
                  ),
                ),
              ),
            ],
          ),
        );

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          padding: const EdgeInsets.all(24),
          constraints: BoxConstraints(minHeight: isMobile ? 0 : 780),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NetPhoto(
                      url: imageUrl,
                      fallback: 'assets/photo4.jpeg',
                      h: 400,
                    ),
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: textCol,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NetPhoto(
                      url: imageUrl,
                      fallback: 'assets/photo4.jpeg',
                      h: 780,
                    ),
                    const SizedBox(width: 24),
                    Expanded(child: textCol),
                  ],
                ),
        );
      },
    );
  }
}

class _FaqSpoiler extends StatelessWidget {
  final int index;
  final bool isOpen;
  final VoidCallback onToggle;
  final String title;
  final String answer;

  const _FaqSpoiler({
    required this.index,
    required this.isOpen,
    required this.onToggle,
    required this.title,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: AppColors.secondaryLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
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
                      child: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      answer,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        height: 1.6,
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
      ),
    );
  }
}
