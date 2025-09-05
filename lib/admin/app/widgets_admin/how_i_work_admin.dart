import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HowIWorkAdmin extends StatefulWidget {
  const HowIWorkAdmin({super.key});

  @override
  State<HowIWorkAdmin> createState() => _HowIWorkAdminState();
}

class _HowIWorkAdminState extends State<HowIWorkAdmin> {
  String _uiLang = 'uk';
  bool _collapsed = false;
  String get _docLocale => _uiLang == 'uk' ? 'ua' : 'de';

  Future<void> _save(Map<String, dynamic> values) async {
    await FirebaseFirestore.instance.collection('content').doc(_docLocale).set({
      'howItWorks': values,
    }, SetOptions(merge: true));
  }

  Future<void> _saveField(String key, String value) async {
    await _save({key: value});
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Сохранено: $key')));
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
              const Icon(Icons.route_outlined),
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
            'How I Work (inline)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _collapsed
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const Text(
              'Блок скрыт — нажмите стрелку, чтобы развернуть',
            ),
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
                      (map['howItWorks'] as Map?) ?? {},
                    );

                    // Считываем значения (с пустыми дефолтами)
                    String g(String k) => (data[k] as String?) ?? '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Заголовок секции
                        _InlineEditableText(
                          text: g('howItWorksTitle'),
                          hint: 'howItWorksTitle',
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          onSubmitted: (v) => _saveField('howItWorksTitle', v),
                        ),
                        const SizedBox(height: 16),

                        // 4 шага: для каждого — Title + Desc
                        for (int i = 1; i <= 4; i++) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$i.',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _InlineEditableText(
                                      text: g('step${i}Title'),
                                      hint: 'step${i}Title',
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      onSubmitted: (v) =>
                                          _saveField('step${i}Title', v),
                                    ),
                                    const SizedBox(height: 6),
                                    _InlineEditableText(
                                      text: g('step${i}Desc'),
                                      hint: 'step${i}Desc',
                                      multiLine: true,
                                      onSubmitted: (v) =>
                                          _saveField('step${i}Desc', v),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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

/// Простой инлайн-редактор текста (как в других админ-виджетах)
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
