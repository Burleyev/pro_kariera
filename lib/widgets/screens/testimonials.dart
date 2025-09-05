import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_kariera/const/app_colors.dart';
import 'package:pro_kariera/l10n/app_localizations.dart';
import 'package:pro_kariera/firebase/firestore_content_service.dart';

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
    final appLang = Localizations.localeOf(context).languageCode;
    final localeKey = appLang == 'uk' ? 'ua' : appLang;

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirestoreContentService.instance.watchTestimonials(localeKey),
      builder: (context, snap) {
        final reviews = snap.data ?? [];
        if (reviews.isEmpty) return const SizedBox.shrink();

        final reviewObjs = reviews
            .where((r) {
              final lang = (r['lang'] as String?)?.toLowerCase() ?? '';
              return lang.isEmpty || lang == localeKey.toLowerCase();
            })
            .map(
              (r) => Review(
                name: r['name'] ?? '',
                avatar:
                    ((r['avatarUrl'] as String?)?.trim().isNotEmpty ?? false)
                    ? (r['avatarUrl'] as String)
                    : (((r['avatar'] as String?)?.trim().isNotEmpty ?? false)
                          ? (r['avatar'] as String)
                          : 'assets/avatar/fallback.png'),
                stars: int.tryParse(r['stars']?.toString() ?? '5') ?? 5,
                comment: r['comment'] ?? '',
              ),
            )
            .take(4)
            .toList();

        return Center(
          child: Column(
            children: [
              Text(
                t.testimonialsTitle,
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 20 : 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: isMobile ? 24.h : 50.h),
              isMobile
                  ? Column(
                      children: reviewObjs
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
                      children: reviewObjs
                          .map((review) => ReviewTile(review: review))
                          .toList(),
                    ),
            ],
          ),
        );
      },
    );
  }
}

ImageProvider<Object> _imageProviderFrom(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return NetworkImage(path);
  }
  return AssetImage(path);
}

Widget _avatarWidget(String path, double radius) {
  final size = radius * 2;
  final isNet = path.startsWith('http://') || path.startsWith('https://');
  // Debug (optional):
  try {
    log('avatar path: ' + path);
  } catch (_) {}

  if (isNet) {
    return ClipOval(
      child: Image.network(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        // graceful fallback on error
        errorBuilder: (_, __, ___) => ClipOval(
          child: Image.asset(
            'assets/avatar/fallback.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
  return ClipOval(
    child: Image.asset(
      (path.isNotEmpty ? path : 'assets/avatar/fallback.png'),
      width: size,
      height: size,
      fit: BoxFit.cover,
    ),
  );
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
          _avatarWidget(review.avatar, 40.r),
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
                  _avatarWidget(widget.review.avatar, 40),
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
            _avatarWidget(widget.review.avatar, 40),
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
