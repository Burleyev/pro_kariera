import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pro_kariera/const/cloudinary.dart';
import '../../../services/cloudinary_service.dart';

class HeroAdmin extends StatefulWidget {
  const HeroAdmin({super.key});

  @override
  State<HeroAdmin> createState() => _HeroAdminState();
}

class _HeroAdminState extends State<HeroAdmin> {
  String _uiLang = 'uk';
  bool _collapsed = false;

  // Режим инлайн-редактирования (как на сайте)
  final bool _inlineOnly = true;

  String get _docLocale => _uiLang == 'uk' ? 'ua' : 'de';

  static const _fields = <String, String>{
    'heroTitle': 'Заголовок / Titel',
    'heroSubtitle': 'Подзаголовок / Untertitel',
    'heroButton': 'Кнопка / Button',
  };

  Future<void> _save(Map<String, dynamic> values) async {
    await FirebaseFirestore.instance.collection('content').doc(_docLocale).set({
      'Hero': values,
    }, SetOptions(merge: true));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Hero збережено у Firestore')));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.edit_note,
                  size: screenWidth >= 1200 ? 60 : 40,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: _collapsed ? 'Развернуть' : 'Свернуть',
                icon: Icon(_collapsed ? Icons.expand_more : Icons.expand_less),
                onPressed: () => setState(() => _collapsed = !_collapsed),
              ),
              const Spacer(),
              LanguageSwitcher(
                current: _uiLang,
                onSelect: (code) => setState(() => _uiLang = code),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Hero секция / Hero Section',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _collapsed
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Hero секция скрыта — нажмите стрелку, чтобы развернуть',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
            secondChild: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Color(0xFFB3D7F5)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('content')
                      .doc(_docLocale)
                      .snapshots(),
                  builder: (context, snap) {
                    final data = snap.data?.data() ?? const <String, dynamic>{};
                    final heroData = Map<String, dynamic>.from(
                      (data['Hero'] as Map?) ?? {},
                    );

                    final currentValues = <String, String>{};
                    for (final key in _fields.keys) {
                      currentValues[key] = (heroData[key] as String?) ?? '';
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Текущее изображение Hero + загрузка
                        _InlineImagePicker(
                          label: 'Изображение Hero',
                          currentUrl:
                              (heroData['heroImageUrl'] as String?) ?? '',
                          onUploaded: (url, publicId) async {
                            await FirebaseFirestore.instance
                                .collection('content')
                                .doc(_docLocale)
                                .set({
                                  'Hero': {
                                    'heroImageUrl': url,
                                    'heroImageId': publicId,
                                  },
                                }, SetOptions(merge: true));
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Загружено изображение Hero'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        // Инлайн-превью: редактирование прямо в макете Hero
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFB3D7F5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hero (inline)',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              InlineEditableText(
                                text: currentValues['heroTitle'] ?? '',
                                hint: 'heroTitle',
                                textStyle: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                                onSubmitted: (v) async {
                                  if (!mounted) return;
                                  setState(
                                    () => currentValues['heroTitle'] = v,
                                  );
                                  await FirebaseFirestore.instance
                                      .collection('content')
                                      .doc(_docLocale)
                                      .set({
                                        'Hero': {'heroTitle': v},
                                      }, SetOptions(merge: true));
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Збережено: heroTitle'),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              InlineEditableText(
                                text: currentValues['heroSubtitle'] ?? '',
                                hint: 'heroSubtitle',
                                textStyle: const TextStyle(fontSize: 16),
                                multiLine: true,
                                onSubmitted: (v) async {
                                  if (!mounted) return;
                                  setState(
                                    () => currentValues['heroSubtitle'] = v,
                                  );
                                  await FirebaseFirestore.instance
                                      .collection('content')
                                      .doc(_docLocale)
                                      .set({
                                        'Hero': {'heroSubtitle': v},
                                      }, SetOptions(merge: true));
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Збережено: heroSubtitle'),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  InlineEditableText(
                                    text: currentValues['heroButton'] ?? '',
                                    hint: 'heroButton',
                                    isButton: true,
                                    onSubmitted: (v) async {
                                      if (!mounted) return;
                                      setState(
                                        () => currentValues['heroButton'] = v,
                                      );
                                      await FirebaseFirestore.instance
                                          .collection('content')
                                          .doc(_docLocale)
                                          .set({
                                            'Hero': {'heroButton': v},
                                          }, SetOptions(merge: true));
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Збережено: heroButton',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
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

class LanguageSwitcher extends StatelessWidget {
  final String current;
  final ValueChanged<String> onSelect;
  const LanguageSwitcher({required this.current, required this.onSelect});

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
        SizedBox(width: 4.w),
        const Text('|'),
        SizedBox(width: 4.w),
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

class InlineEditableText extends StatefulWidget {
  final String text;
  final String? hint;
  final TextStyle? textStyle;
  final bool multiLine;
  final bool isButton;
  final ValueChanged<String> onSubmitted;

  const InlineEditableText({
    required this.text,
    this.hint,
    this.textStyle,
    this.multiLine = false,
    this.isButton = false,
    required this.onSubmitted,
    super.key,
  });

  @override
  State<InlineEditableText> createState() => _InlineEditableTextState();
}

class _InlineEditableTextState extends State<InlineEditableText> {
  bool _editing = false;
  late TextEditingController _c;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _c = TextEditingController(text: widget.text);
    _focus.addListener(() {
      if (!_focus.hasFocus && _editing) _finish();
    });
  }

  @override
  void didUpdateWidget(covariant InlineEditableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text && !_editing) {
      _c.text = widget.text;
    }
  }

  void _finish() {
    setState(() => _editing = false);
    widget.onSubmitted(_c.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isButton) {
      if (_editing) {
        return SizedBox(
          width: 220,
          height: 40,
          child: TextField(
            controller: _c,
            focusNode: _focus,
            autofocus: true,
            decoration: InputDecoration(
              hintText: widget.hint,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _finish(),
          ),
        );
      }
      return SizedBox(
        height: 40,
        child: InkWell(
          onTap: () => setState(() {
            _editing = true;
            _focus.requestFocus();
          }),
          borderRadius: BorderRadius.circular(6),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFB3D7F5)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Center(
                child: Text(
                  _c.text.isEmpty ? (widget.hint ?? '') : _c.text,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (_editing) {
      return TextField(
        controller: _c,
        focusNode: _focus,
        autofocus: true,
        maxLines: widget.multiLine ? null : 1,
        decoration: InputDecoration(
          hintText: widget.hint,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (_) => _finish(),
      );
    }

    return InkWell(
      onTap: () => setState(() {
        _editing = true;
        _focus.requestFocus();
      }),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Text(
          _c.text.isEmpty ? (widget.hint ?? '') : _c.text,
          style: widget.textStyle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    _focus.dispose();
    super.dispose();
  }
}

class _InlineImagePicker extends StatefulWidget {
  final String label;
  final String currentUrl;
  final void Function(String url, String publicId) onUploaded;
  const _InlineImagePicker({
    required this.label,
    required this.currentUrl,
    required this.onUploaded,
  });

  @override
  State<_InlineImagePicker> createState() => _InlineImagePickerState();
}

class _InlineImagePickerState extends State<_InlineImagePicker> {
  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 160,
                height: 90,
                child: widget.currentUrl.isEmpty
                    ? Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_outlined, size: 32),
                      )
                    : Image.network(widget.currentUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _uploading ? null : _pickAndUpload,
              icon: _uploading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload),
              label: Text(_uploading ? 'Загрузка…' : 'Загрузить'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickAndUpload() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      if (file.bytes == null) return;

      setState(() => _uploading = true);

      final cloud = CloudinaryService(
        cloudName: kCloudinaryCloudName,
        uploadPreset: kCloudinaryUploadPreset,
      );
      final uploaded = await cloud.uploadBytes(
        bytes: file.bytes!,
        fileName: file.name,
        folder: 'prokariera/hero',
      );
      if (!mounted) return;
      widget.onUploaded(uploaded.url, uploaded.publicId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка загрузки: $e')));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }
}
