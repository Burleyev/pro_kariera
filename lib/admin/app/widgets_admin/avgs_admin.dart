import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pro_kariera/const/cloudinary.dart';
import 'package:pro_kariera/services/cloudinary_service.dart';

/// Инлайн-редактор секции AVGS (content/{locale}/AVGS)
/// Редактирует:
///  - avgsStatusTitle
///  - avgsStatusText
///  - titlesUk / answersUk (для uk)
///  - titlesDe / answersDe (для de)
class AvgsAdmin extends StatefulWidget {
  const AvgsAdmin({super.key});

  @override
  State<AvgsAdmin> createState() => _AvgsAdminState();
}

class _AvgsAdminState extends State<AvgsAdmin> {
  String _uiLang = 'uk'; // ui языка админки (uk|de)
  bool _collapsed = false;

  String get _docLocale => _uiLang == 'uk' ? 'ua' : 'de';
  String get _titlesKey => _uiLang == 'de' ? 'titlesDe' : 'titlesUk';
  String get _answersKey => _uiLang == 'de' ? 'answersDe' : 'answersUk';

  Future<void> _saveMap(Map<String, dynamic> m) async {
    await FirebaseFirestore.instance.collection('content').doc(_docLocale).set({
      'AVGS': m,
    }, SetOptions(merge: true));
  }

  Future<void> _savePairLists(List<String> titles, List<String> answers) async {
    await _saveMap({_titlesKey: titles, _answersKey: answers});
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Збережено: FAQ-список AVGS')));
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
              const Icon(Icons.help_outline),
              const SizedBox(width: 8),
              IconButton(
                tooltip: _collapsed ? 'Развернуть' : 'Свернуть',
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
            'AVGS (inline)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _collapsed
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const Text('AVGS скрыт — нажмите стрелку'),
            secondChild: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('content')
                      .doc(_docLocale)
                      .snapshots(),
                  builder: (context, snap) {
                    final data = snap.data?.data() ?? <String, dynamic>{};
                    final avgs = Map<String, dynamic>.from(
                      data['AVGS'] as Map? ?? {},
                    );

                    final statusTitle =
                        (avgs['avgsStatusTitle'] as String?) ?? '';
                    final statusText =
                        (avgs['avgsStatusText'] as String?) ?? '';

                    final titles = ((avgs[_titlesKey] as List?) ?? const [])
                        .map((e) => e?.toString() ?? '')
                        .toList();
                    final answers = ((avgs[_answersKey] as List?) ?? const [])
                        .map((e) => e?.toString() ?? '')
                        .toList();

                    final String imageUrl =
                        (avgs['imageUrl'] as String?)?.trim() ?? '';
                    final String imageId =
                        (avgs['imageId'] as String?)?.trim() ?? '';

                    Future<void> saveField(String key, String val) async {
                      await _saveMap({key: val});
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Сохранено: $key')),
                      );
                    }

                    void addItem() {
                      final t = List<String>.from(titles)..add('');
                      final a = List<String>.from(answers)..add('');
                      _savePairLists(t, a);
                    }

                    void removeItem(int index) {
                      if (index < 0 || index >= titles.length) return;
                      final t = List<String>.from(titles)..removeAt(index);
                      final a = index < answers.length
                          ? (List<String>.from(answers)..removeAt(index))
                          : List<String>.from(answers);
                      _savePairLists(t, a);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Одно изображение для секции AVGS
                        _InlineImagePicker(
                          label: 'Изображение AVGS',
                          currentUrl: imageUrl,
                          onUploaded: (url, publicId) async {
                            await _saveMap({
                              'imageUrl': url,
                              'imageId': publicId,
                            });
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Изображение AVGS загружено'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text('Статусная плашка'),
                        const SizedBox(height: 8),
                        _InlineEditableText(
                          text: statusTitle,
                          hint: 'avgsStatusTitle',
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          onSubmitted: (v) => saveField('avgsStatusTitle', v),
                        ),
                        const SizedBox(height: 6),
                        _InlineEditableText(
                          text: statusText,
                          hint: 'avgsStatusText',
                          multiLine: true,
                          onSubmitted: (v) => saveField('avgsStatusText', v),
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            Text(
                              'FAQ (${_uiLang.toUpperCase()})',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: addItem,
                              icon: const Icon(Icons.add),
                              label: const Text('Добавить вопрос'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (titles.isEmpty && answers.isEmpty)
                          const Text(
                            'Пока пусто. Нажмите «Добавить вопрос».',
                            style: TextStyle(color: Colors.grey),
                          ),

                        // Пары Q/A
                        for (
                          int i = 0;
                          i <
                              (titles.length > answers.length
                                  ? titles.length
                                  : answers.length);
                          i++
                        )
                          _FaqRow(
                            index: i,
                            q: i < titles.length ? titles[i] : '',
                            a: i < answers.length ? answers[i] : '',
                            onQSubmit: (v) {
                              final t = List<String>.from(titles);
                              if (i < t.length)
                                t[i] = v;
                              else
                                t.add(v);
                              _savePairLists(t, answers);
                            },
                            onASubmit: (v) {
                              final a = List<String>.from(answers);
                              if (i < a.length)
                                a[i] = v;
                              else
                                a.add(v);
                              _savePairLists(titles, a);
                            },
                            onRemove: () => removeItem(i),
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

class _FaqRow extends StatelessWidget {
  final int index;
  final String q;
  final String a;
  final ValueChanged<String> onQSubmit;
  final ValueChanged<String> onASubmit;
  final VoidCallback onRemove;
  const _FaqRow({
    required this.index,
    required this.q,
    required this.a,
    required this.onQSubmit,
    required this.onASubmit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${index + 1}.', style: const TextStyle(color: Colors.grey)),
              const SizedBox(width: 8),
              Expanded(
                child: _InlineEditableText(
                  text: q,
                  hint: 'Вопрос',
                  onSubmitted: onQSubmit,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Удалить',
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _InlineEditableText(
            text: a,
            hint: 'Ответ',
            multiLine: true,
            onSubmitted: onASubmit,
          ),
        ],
      ),
    );
  }
}

/// Мини-инлайн-редактор текста (как в других админ-виджетах)
class _InlineEditableText extends StatefulWidget {
  final String text;
  final String? hint;
  final TextStyle? textStyle;
  final bool multiLine;
  final bool isButton;
  final ValueChanged<String> onSubmitted;

  const _InlineEditableText({
    required this.text,
    this.hint,
    this.textStyle,
    this.multiLine = false,
    this.isButton = false,
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
      if (!_focus.hasFocus && _editing) _finish();
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
    widget.onSubmitted(_c.text.trim());
  }

  @override
  Widget build(BuildContext context) {
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
        folder: 'prokariera/avgs',
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
