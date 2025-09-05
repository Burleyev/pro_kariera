import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqAdmin extends StatefulWidget {
  const FaqAdmin({super.key});

  @override
  State<FaqAdmin> createState() => _FaqAdminState();
}

class _FaqAdminState extends State<FaqAdmin> {
  String _uiLang = 'uk';
  bool _collapsed = false;
  String get _docLocale => _uiLang == 'uk' ? 'ua' : 'de';

  Future<void> _save(Map<String, dynamic> values) async {
    await FirebaseFirestore.instance.collection('content').doc(_docLocale).set({
      'faq': values,
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
              const Icon(Icons.question_answer_outlined),
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
            'FAQ (inline)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _collapsed
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const Text('FAQ скрыт — нажмите стрелку'),
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
                      (map['faq'] as Map?) ?? {},
                    );

                    final title = data['faqTitle'] ?? '';

                    // Собираем пары Q/A в массив для упрощения операций
                    final List<Map<String, String>> pairs = [];
                    int i = 1;
                    while (data.containsKey('faqQ$i') ||
                        data.containsKey('faqA$i')) {
                      pairs.add({
                        'q': (data['faqQ$i'] ?? '').toString(),
                        'a': (data['faqA$i'] ?? '').toString(),
                      });
                      i++;
                    }

                    Future<void> saveTitle(String v) async {
                      await _save({'faqTitle': v});
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Сохранено: faqTitle')),
                      );
                    }

                    Future<void> saveQ(int index, String v) async {
                      final key = 'faqQ${index + 1}';
                      await _save({key: v});
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Сохранено: $key')),
                      );
                    }

                    Future<void> saveA(int index, String v) async {
                      final key = 'faqA${index + 1}';
                      await _save({key: v});
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Сохранено: $key')),
                      );
                    }

                    Future<void> addItem() async {
                      final next = pairs.length + 1;
                      await _save({'faqQ$next': '', 'faqA$next': ''});
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Добавлен новый вопрос')),
                      );
                    }

                    Future<void> removeItem(int index) async {
                      // Пересобираем карту faq с пере-нумерацией без удаляемого элемента
                      final Map<String, dynamic> newFaq = {};
                      if (title.isNotEmpty) newFaq['faqTitle'] = title;
                      int write = 1;
                      for (int j = 0; j < pairs.length; j++) {
                        if (j == index) continue;
                        newFaq['faqQ$write'] = pairs[j]['q'] ?? '';
                        newFaq['faqA$write'] = pairs[j]['a'] ?? '';
                        write++;
                      }
                      final docRef = FirebaseFirestore.instance
                          .collection('content')
                          .doc(_docLocale);
                      // 1) Полностью удалить поле 'faq', чтобы не осталось старых ключей
                      await docRef.update({'faq': FieldValue.delete()});
                      // 2) Записать пересобранное поле 'faq'
                      await docRef.set({
                        'faq': newFaq,
                      }, SetOptions(merge: true));
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Вопрос удалён')),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InlineEditableText(
                          text: title,
                          hint: 'faqTitle',
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          onSubmitted: (v) => saveTitle(v),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              'Список вопросов',
                              style: TextStyle(fontWeight: FontWeight.w600),
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
                        if (pairs.isEmpty)
                          const Text(
                            'Пока пусто. Нажмите «Добавить вопрос».',
                            style: TextStyle(color: Colors.grey),
                          ),

                        for (int idx = 0; idx < pairs.length; idx++) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${idx + 1}.',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _InlineEditableText(
                                      text: pairs[idx]['q'] ?? '',
                                      hint: 'faqQ${idx + 1}',
                                      onSubmitted: (v) => saveQ(idx, v),
                                    ),
                                    const SizedBox(height: 4),
                                    _InlineEditableText(
                                      text: pairs[idx]['a'] ?? '',
                                      hint: 'faqA${idx + 1}',
                                      multiLine: true,
                                      onSubmitted: (v) => saveA(idx, v),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                tooltip: 'Удалить вопрос',
                                onPressed: () => removeItem(idx),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
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
    super.key,
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
  void didUpdateWidget(covariant _InlineEditableText old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text && !_editing) {
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
  final String current;
  final ValueChanged<String> onSelect;
  const _LanguageSwitcher({
    required this.current,
    required this.onSelect,
    super.key,
  });
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
