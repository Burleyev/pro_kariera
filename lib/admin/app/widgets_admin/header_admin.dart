import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pro_kariera/const/cloudinary.dart';
import '../../../services/cloudinary_service.dart';

/// Админ-редактор шапки: редактирует content/{locale}/HeaderMenu
class HeaderAdmin extends StatefulWidget {
  const HeaderAdmin({super.key});

  @override
  State<HeaderAdmin> createState() => _HeaderAdminState();
}

class _HeaderAdminState extends State<HeaderAdmin> {
  String _uiLang = 'uk'; // язык интерфейса админки (uk|de)
  bool _collapsed = false; // свернуть/развернуть форму
  bool _inlineMode =
      true; // режим "как на сайте": клик по тексту = редактирование

  String get _docLocale => _uiLang == 'uk' ? 'ua' : 'de'; // документ Firestore

  // Список полей HeaderMenu, которые редактируем
  static const _fields = <String, String>{
    'menuHero': 'Головна / Start',
    'menuAbout': 'Про мене / Über mich',
    'menuServices': 'Послуги / Dienstleistungen',
    'menuPrice': 'Вартість / Preise',
    'menuAvgs': 'AVGS',
    'menuHowItWorks': 'Етапи / Ablauf',
    'menuTestimonials': 'Відгуки / Referenzen',
    'menuFaq': 'Часті запитання / FAQ',
    'menuContact': 'Контакти / Kontakt',
  };

  Future<void> _save(Map<String, dynamic> values) async {
    await FirebaseFirestore.instance.collection('content').doc(_docLocale).set({
      'HeaderMenu': values,
    }, SetOptions(merge: true));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Збережено у Firestore')));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Верхняя панель
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
              _LanguageSwitcher(
                current: _uiLang,
                onSelect: (code) => setState(() => _uiLang = code),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Text(
            'Меню сайта / Site Menu',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          Row(
            children: [
              const Icon(Icons.visibility, size: 18),
              const SizedBox(width: 6),
              const Text('Редактирование по месту (только меню)'),
              const SizedBox(width: 8),
              Switch(
                value: _inlineMode,
                onChanged: (v) => setState(() => _inlineMode = v),
              ),
            ],
          ),
          const SizedBox(height: 8),

          SizedBox(height: 16.h),

          // Форма редактирования HeaderMenu (сворачиваемая)
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _collapsed
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Меню сайта скрыто — нажмите стрелку, чтобы развернуть',
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
                    final header = Map<String, dynamic>.from(
                      (data['HeaderMenu'] as Map?) ?? {},
                    );

                    final currentValues = <String, String>{};
                    for (final key in _fields.keys) {
                      currentValues[key] = (header[key] as String?) ?? '';
                    }

                    // Инлайн-превью как на сайте: кликаем по пункту и редактируем его
                    final List<Widget> inlinePreview = _inlineMode
                        ? <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFB3D7F5),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _fields.keys.map((key) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: _InlineEditableText(
                                        text: currentValues[key]!,
                                        hint: key,
                                        onSubmitted: (newText) async {
                                          if (newText.trim() ==
                                              currentValues[key]!.trim())
                                            return;
                                          if (!mounted) return;
                                          setState(
                                            () => currentValues[key] = newText,
                                          );
                                          await FirebaseFirestore.instance
                                              .collection('content')
                                              .doc(_docLocale)
                                              .set({
                                                'HeaderMenu': {key: newText},
                                              }, SetOptions(merge: true));
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text('Сохранено: $key'),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ]
                        : const <Widget>[];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InlineImagePicker(
                          currentUrl: header['logoUrl'] as String?,
                          onUpload: (newUrl) async {
                            await FirebaseFirestore.instance
                                .collection('content')
                                .doc(_docLocale)
                                .set({
                                  'HeaderMenu': {'logoUrl': newUrl},
                                }, SetOptions(merge: true));
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Логотип загружен')),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        ...inlinePreview,
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

class _LanguageSwitcher extends StatelessWidget {
  final String current; // 'uk' | 'de'
  final ValueChanged<String> onSelect;
  const _LanguageSwitcher({required this.current, required this.onSelect});

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

class _InlineEditableText extends StatefulWidget {
  final String text;
  final String? hint;
  final ValueChanged<String> onSubmitted;
  const _InlineEditableText({
    required this.text,
    this.hint,
    required this.onSubmitted,
  });

  @override
  State<_InlineEditableText> createState() => _InlineEditableTextState();
}

class _InlineEditableTextState extends State<_InlineEditableText> {
  bool _editing = false;
  late TextEditingController _c;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _c = TextEditingController(text: widget.text);
    _focus.addListener(() {
      if (!_focus.hasFocus && _editing) {
        _finish();
      }
    });
  }

  @override
  void didUpdateWidget(covariant _InlineEditableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text && !_editing) {
      _c.text = widget.text;
    }
  }

  void _finish() {
    setState(() => _editing = false);
    final value = _c.text.trim();
    widget.onSubmitted(value);
  }

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      return SizedBox(
        width: 220,
        child: TextField(
          controller: _c,
          focusNode: _focus,
          autofocus: true,
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
        ),
      );
    }
    return InkWell(
      onTap: () => setState(() {
        _editing = true;
        _focus.requestFocus();
      }),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(
          _c.text.isEmpty ? (widget.hint ?? '') : _c.text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
  final String? currentUrl;
  final ValueChanged<String> onUpload;
  const _InlineImagePicker({this.currentUrl, required this.onUpload});

  @override
  State<_InlineImagePicker> createState() => _InlineImagePickerState();
}

class _InlineImagePickerState extends State<_InlineImagePicker> {
  bool _uploading = false;

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes == null) return;

    setState(() => _uploading = true);
    try {
      final cloud = CloudinaryService(
        cloudName: kCloudinaryCloudName,
        uploadPreset: kCloudinaryUploadPreset,
      );
      final uploaded = await cloud.uploadBytes(
        bytes: file.bytes!,
        fileName: file.name,
        folder: 'prokariera/logo',
      );
      widget.onUpload(uploaded.url);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка загрузки: $e')));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.currentUrl != null && widget.currentUrl!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              height: 60,
              width: 60,
              child: Image.network(widget.currentUrl!, fit: BoxFit.contain),
            ),
          ),
        ElevatedButton.icon(
          onPressed: _uploading ? null : _pickAndUpload,
          icon: _uploading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.upload_file),
          label: const Text('Загрузить логотип'),
        ),
      ],
    );
  }
}
