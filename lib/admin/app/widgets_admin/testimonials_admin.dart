import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pro_kariera/const/cloudinary.dart';
import 'package:pro_kariera/services/cloudinary_service.dart';

import 'package:pro_kariera/widgets/net_photo.dart';

/// Dummy _InlineEditableText and _LanguageSwitcher for context.
/// Replace with your actual implementations.
class _InlineEditableText extends StatelessWidget {
  final String text;
  final String hint;
  final TextStyle? textStyle;
  final bool multiLine;
  final ValueChanged<String> onSubmitted;
  const _InlineEditableText({
    required this.text,
    required this.hint,
    required this.onSubmitted,
    this.textStyle,
    this.multiLine = false,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: text);
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: hint),
      style: textStyle,
      maxLines: multiLine ? null : 1,
      onSubmitted: onSubmitted,
      onEditingComplete: () => onSubmitted(controller.text),
    );
  }
}

class _LanguageSwitcher extends StatelessWidget {
  final String current; // 'uk' | 'de'
  final ValueChanged<String> onSelect;
  const _LanguageSwitcher({
    required this.current,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => onSelect('uk'),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: current == 'uk' ? 2 : 0),
            ),
            child: Column(
              children: const [
                ColoredBox(
                  color: Colors.lightBlue,
                  child: SizedBox(height: 10.5, width: 40),
                ),
                ColoredBox(
                  color: Color(0xFFFFEB3B),
                  child: SizedBox(height: 10.5, width: 40),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Text('|'),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () => onSelect('de'),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: current == 'de' ? 2 : 0),
            ),
            child: Column(
              children: const [
                ColoredBox(
                  color: Colors.black,
                  child: SizedBox(height: 7, width: 40),
                ),
                ColoredBox(
                  color: Colors.red,
                  child: SizedBox(height: 7, width: 40),
                ),
                ColoredBox(
                  color: Colors.yellow,
                  child: SizedBox(height: 7, width: 40),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TestimonialsAdmin extends StatefulWidget {
  const TestimonialsAdmin({super.key});

  @override
  State<TestimonialsAdmin> createState() => _TestimonialsAdminState();
}

class _TestimonialsAdminState extends State<TestimonialsAdmin> {
  String _uiLang = 'uk';
  bool _collapsed = false;
  String get _docLocale => _uiLang == 'uk' ? 'ua' : 'de';

  Future<void> _save(Map<String, dynamic> values) async {
    await FirebaseFirestore.instance.collection('content').doc(_docLocale).set({
      'testimonials': values,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.reviews_outlined),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(_collapsed ? Icons.expand_more : Icons.expand_less),
                onPressed: () => setState(() => _collapsed = !_collapsed),
              ),
              const Spacer(),
              _LanguageSwitcher(
                current: _uiLang,
                onSelect: (c) => setState(() => _uiLang = c),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Testimonials (inline)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _collapsed
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const Text('Блок скрыт — нажмите стрелку'),
            secondChild: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('content')
                      .doc(_docLocale)
                      .snapshots(),
                  builder: (context, snap) {
                    final map = snap.data?.data() ?? const <String, dynamic>{};
                    final data = Map<String, dynamic>.from(
                      (map['testimonials'] as Map?) ?? {},
                    );

                    Future<void> saveField(String key, dynamic value) async {
                      await _save({key: value});
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Сохранено: $key')),
                      );
                    }

                    final title = data['testimonialsTitle'] ?? '';
                    // Remove title for reviews map
                    final reviews = Map<String, dynamic>.from(data)
                      ..remove('testimonialsTitle');

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InlineEditableText(
                          text: title,
                          hint: 'testimonialsTitle',
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          onSubmitted: (v) => saveField('testimonialsTitle', v),
                        ),
                        const SizedBox(height: 12),
                        for (final entry in reviews.entries) ...[
                          Row(
                            children: [
                              Expanded(
                                child: _InlineEditableText(
                                  text: entry.value['name'] ?? '',
                                  hint: 'name',
                                  onSubmitted: (v) {
                                    final m = Map<String, dynamic>.from(
                                      entry.value,
                                    );
                                    m['name'] = v;
                                    saveField(entry.key, m);
                                  },
                                ),
                              ),
                            ],
                          ),
                          _InlineEditableText(
                            text: entry.value['comment'] ?? '',
                            hint: 'comment',
                            multiLine: true,
                            onSubmitted: (v) {
                              final m = Map<String, dynamic>.from(entry.value);
                              m['comment'] = v;
                              saveField(entry.key, m);
                            },
                          ),
                          _InlineEditableText(
                            text: (entry.value['stars'] ?? '').toString(),
                            hint: 'stars',
                            onSubmitted: (v) {
                              final m = Map<String, dynamic>.from(entry.value);
                              m['stars'] = v;
                              saveField(entry.key, m);
                            },
                          ),
                          // Avatar preview + upload
                          Builder(
                            builder: (context) {
                              final currentUrl =
                                  (entry.value['avatarUrl'] ??
                                          entry.value['avatar'] ??
                                          '')
                                      .toString();
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Preview with same shadow/rounding
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey.shade200,
                                      image: currentUrl.isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(currentUrl),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: currentUrl.isEmpty
                                        ? const Icon(
                                            Icons.person,
                                            size: 32,
                                            color: Colors.black54,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      try {
                                        final picked = await FilePicker.platform
                                            .pickFiles(
                                              type: FileType.image,
                                              allowMultiple: false,
                                              withData: true,
                                            );
                                        if (picked == null ||
                                            picked.files.isEmpty)
                                          return;
                                        final f = picked.files.first;
                                        if (f.bytes == null) return;
                                        final cloud = CloudinaryService(
                                          cloudName: kCloudinaryCloudName,
                                          uploadPreset: kCloudinaryUploadPreset,
                                        );
                                        final uploaded = await cloud
                                            .uploadBytes(
                                              bytes: f.bytes!,
                                              fileName: f.name,
                                              folder: 'prokariera/testimonials',
                                            );
                                        final m = Map<String, dynamic>.from(
                                          entry.value,
                                        );
                                        m['avatarUrl'] = uploaded.url;
                                        m['avatarId'] = uploaded.publicId;
                                        // оставляем старое поле avatar как резерв, но основной показ по avatarUrl
                                        await saveField(entry.key, m);
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Аватар загружен'),
                                          ),
                                        );
                                      } catch (e) {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Ошибка загрузки: $e',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.upload),
                                    label: const Text('Загрузить аватар'),
                                  ),
                                ],
                              );
                            },
                          ),
                          const Divider(height: 24),
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
