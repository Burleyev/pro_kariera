import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_kariera/const/app_colors.dart';
import 'package:pro_kariera/l10n/app_localizations.dart';

class Testimonials extends StatelessWidget {
  const Testimonials({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: const ReviewWall(),
    );
  }
}

class ReviewWall extends StatelessWidget {
  const ReviewWall({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.of(context).size.width < 1200;

    return Center(
      child: Column(
        children: [
          Text(
            t.testimonialsTitle,
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 20.sp : 26.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: isMobile ? 24.h : 50.h),
          isMobile
              ? Column(
                  children: getReviews(context)
                      .map(
                        (review) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ReviewMobileCard(review: review),
                        ),
                      )
                      .toList(),
                )
              : Wrap(
                  spacing: 16.w,
                  runSpacing: 16.w,
                  children: getReviews(
                    context,
                  ).map((review) => ReviewTile(review: review)).toList(),
                ),
        ],
      ),
    );
  }
}

class ReviewMobileCard extends StatelessWidget {
  final Review review;
  const ReviewMobileCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.secondaryLight),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.secondaryLight,
            backgroundImage: AssetImage(review.avatar),
            radius: 40.r,
          ),
          SizedBox(height: 8.h),
          Text(
            review.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              review.stars,
              (i) => Icon(Icons.star, size: 16, color: Colors.amber),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            review.comment,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class ReviewTile extends StatefulWidget {
  final Review review;
  const ReviewTile({super.key, required this.review});

  @override
  State<ReviewTile> createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx - 50,
        top: offset.dy - 300,
        child: Material(
          elevation: 12,
          color: Colors.transparent,
          child: MouseRegion(
            onExit: (_) => _removeOverlay(),
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(color: AppColors.secondaryLight),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.secondaryLight,
                    backgroundImage: AssetImage(widget.review.avatar),
                    radius: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.review.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.review.stars,
                      (i) =>
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.review.comment,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _showOverlay(context),
      onExit: (_) => Future.delayed(
        const Duration(milliseconds: 100),
        () => _removeOverlay(),
      ),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: AppColors.secondaryLight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.secondaryLight,
              radius: 40,
              backgroundImage: AssetImage(widget.review.avatar),
            ),
            const SizedBox(height: 8),
            Text(widget.review.name, style: const TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.review.stars,
                (i) => const Icon(Icons.star, size: 16, color: Colors.amber),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===== модель и данные
class Review {
  final String name;
  final String avatar; // путь к локальному аватару
  final int stars; // 1..5
  final String comment;

  Review({
    required this.name,
    required this.avatar,
    required this.stars,
    required this.comment,
  });
}

List<Review> getReviews(BuildContext context) {
  final lang = Localizations.localeOf(context).languageCode;
  if (lang == 'de') {
    return [
      Review(
        name: 'Andrii S.',
        avatar: 'assets/avatar/image3.png',
        stars: 5,
        comment:
            'Ich habe mit Jobcoaching zusammengearbeitet und bin sehr zufrieden. '
            'Die Unterstützung war professionell, freundlich und immer hilfreich. '
            'Durch das Coaching habe ich eine tolle Arbeitsstelle gefunden. '
            'Vielen Dank – absolut empfehlenswert!',
      ),
      Review(
        name: 'Olena P.',
        avatar: 'assets/avatar/foto1.png',
        stars: 5,
        comment:
            'Es war sehr angenehm, mit Valeriia als Coach zu arbeiten. '
            'Wir haben gemeinsam viel erreicht, ohne ihre Hilfe hätte ich es nicht geschafft. '
            'Ich empfehle sie für ihren Fleiß und ihren kreativen Ansatz!',
      ),
      Review(
        name: 'Iryna K.',
        avatar: 'assets/avatar/image1.png',
        stars: 5,
        comment:
            'Professionelle Unterstützung bei der Erstellung von Lebenslauf und Interviewvorbereitung, '
            'plus moralische Unterstützung. Sie hat mir mit den Unterlagen für die Anerkennung geholfen. Vielen Dank!',
      ),
      Review(
        name: 'Maria T.',
        avatar: 'assets/avatar/image2.png',
        stars: 5,
        comment:
            'Arbeit wird an Erfolgen gemessen. Dank des Coachings haben mein Mann und ich Arbeit gefunden. '
            'Danke für die Motivation und den Glauben! Sehr zu empfehlen.',
      ),
    ];
  } else {
    return [
      Review(
        name: 'Андрій С.',
        avatar: 'assets/avatar/image3.png',
        stars: 5,
        comment:
            'Я працював із кар\'єрним коучингом і залишився дуже задоволений. '
            'Підтримка була професійною, дружньою та завжди корисною. '
            'Завдяки коучингу я знайшов чудову роботу. Дуже дякую – однозначно рекомендую!',
      ),
      Review(
        name: 'Олена П.',
        avatar: 'assets/avatar/foto1.png',
        stars: 5,
        comment:
            'Дуже приємно було працювати з Валерією як з коучем. '
            'Разом виконали багато роботи, без її допомоги я б не впоралась. '
            'Рекомендую за старанність і креативний підхід!',
      ),
      Review(
        name: 'Ірина К.',
        avatar: 'assets/avatar/image1.png',
        stars: 5,
        comment:
            'Професійний супровід у підготовці резюме та до співбесіди, плюс моральна підтримка. '
            'Допомогли з пакетом документів для визнання диплому. Щиро дякую!',
      ),
      Review(
        name: 'Марія Т.',
        avatar: 'assets/avatar/image2.png',
        stars: 5,
        comment:
            'Робота вимірюється досягненнями. Завдяки коучингу ми з чоловіком знайшли роботу. '
            'Дякую за мотивацію і віру! Рекомендую від щирого серця.',
      ),
    ];
  }
}
