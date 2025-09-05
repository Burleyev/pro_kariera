import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_kariera/admin/app/widgets_admin/hero_admin.dart';

// Assumes _InlineEditableText and _LanguageSwitcher are already defined elsewhere in your project.

class PriceAdmin extends StatefulWidget {
  const PriceAdmin({super.key});
  @override
  State<PriceAdmin> createState() => _PriceAdminState();
}

class _PriceAdminState extends State<PriceAdmin> {
  String _uiLang = 'uk';
  bool _collapsed = false;
  String get _docLocale => _uiLang == 'uk' ? 'ua' : 'de';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.euro),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(_collapsed ? Icons.expand_more : Icons.expand_less),
                onPressed: () => setState(() => _collapsed = !_collapsed),
              ),
              const Spacer(),
              LanguageSwitcher(
                current: _uiLang,
                onSelect: (c) => setState(() => _uiLang = c),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Price (inline)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _collapsed
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const Text('Price скрыт — нажмите стрелку'),
            secondChild: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('content')
                      .doc(_docLocale)
                      .snapshots(),
                  builder: (context, snap) {
                    final data = snap.data?.data() ?? {};
                    final price = Map<String, dynamic>.from(
                      data['Price'] as Map? ?? {},
                    );

                    Future<void> saveField(String key, String val) async {
                      await FirebaseFirestore.instance
                          .collection('content')
                          .doc(_docLocale)
                          .set({
                            'Price': {key: val},
                          }, SetOptions(merge: true));
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Сохранено: $key')),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InlineEditableText(
                          text: price['priceTitle'] ?? '',
                          hint: 'priceTitle',
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          onSubmitted: (v) => saveField('priceTitle', v),
                        ),
                        const SizedBox(height: 12),
                        InlineEditableText(
                          text: price['priceCard'] ?? '',
                          hint: 'priceCard',
                          multiLine: true,
                          onSubmitted: (v) => saveField('priceCard', v),
                        ),
                        const SizedBox(height: 12),
                        InlineEditableText(
                          text: price['azavNote'] ?? '',
                          hint: 'azavNote',
                          multiLine: true,
                          onSubmitted: (v) => saveField('azavNote', v),
                        ),
                        const SizedBox(height: 12),
                        InlineEditableText(
                          text: price['heroButton'] ?? '',
                          hint: 'heroButton',
                          isButton: true,
                          onSubmitted: (v) => saveField('heroButton', v),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
