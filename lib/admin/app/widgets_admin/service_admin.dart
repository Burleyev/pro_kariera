import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_kariera/admin/app/widgets_admin/hero_admin.dart';
// Import or define _InlineEditableText and _LanguageSwitcher as needed.

class ServiceAdmin extends StatefulWidget {
  const ServiceAdmin({super.key});
  @override
  State<ServiceAdmin> createState() => _ServiceAdminState();
}

class _ServiceAdminState extends State<ServiceAdmin> {
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
              const Icon(Icons.build_outlined),
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
            'Services (inline)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _collapsed
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const Text('Services скрыты — нажмите стрелку'),
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
                    final services = Map<String, dynamic>.from(
                      data['services'] as Map? ?? {},
                    );

                    Future<void> saveField(String key, String val) async {
                      await FirebaseFirestore.instance
                          .collection('content')
                          .doc(_docLocale)
                          .set({
                            'services': {key: val},
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
                          text: services['servicesTitle'] ?? '',
                          hint: 'servicesTitle',
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          onSubmitted: (v) => saveField('servicesTitle', v),
                        ),
                        const SizedBox(height: 12),
                        for (var i = 1; i <= 5; i++) ...[
                          InlineEditableText(
                            text: services['service${i}Title'] ?? '',
                            hint: 'service${i}Title',
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                            onSubmitted: (v) =>
                                saveField('service${i}Title', v),
                          ),
                          const SizedBox(height: 4),
                          InlineEditableText(
                            text: services['service${i}Desc'] ?? '',
                            hint: 'service${i}Desc',
                            multiLine: true,
                            onSubmitted: (v) => saveField('service${i}Desc', v),
                          ),
                          const SizedBox(height: 12),
                        ],
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
