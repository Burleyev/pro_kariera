import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactAdmin extends StatefulWidget {
  const ContactAdmin({super.key});
  @override
  State<ContactAdmin> createState() => _ContactAdminState();
}

class _ContactAdminState extends State<ContactAdmin> {
  String _uiLang = 'uk';
  bool _collapsed = false;
  String get _docLocale => _uiLang == 'uk' ? 'ua' : 'de';

  Future<void> _saveField(String key, String value) async {
    await FirebaseFirestore.instance.collection('content').doc(_docLocale).set({
      'contact': {key: value},
    }, SetOptions(merge: true));
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
              const Icon(Icons.contact_mail_outlined),
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
            'Contact (inline)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _collapsed
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const Text('Contact скрыт — нажмите стрелку'),
            secondChild: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('content')
                      .doc(_docLocale)
                      .snapshots(),
                  builder: (context, snap) {
                    final data = snap.data?.data() ?? const {};
                    final contact = Map<String, dynamic>.from(
                      data['contact'] as Map? ?? {},
                    );
                    String g(String k) => contact[k]?.toString() ?? '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InlineEditableText(
                          text: g('contactTitle'),
                          hint: 'contactTitle',
                          onSubmitted: (v) => _saveField('contactTitle', v),
                        ),
                        const SizedBox(height: 12),
                        _InlineEditableText(
                          text: g('contactNameLabel'),
                          hint: 'contactNameLabel',
                          onSubmitted: (v) => _saveField('contactNameLabel', v),
                        ),
                        const SizedBox(height: 12),
                        _InlineEditableText(
                          text: g('contactEmailLabel'),
                          hint: 'contactEmailLabel',
                          onSubmitted: (v) =>
                              _saveField('contactEmailLabel', v),
                        ),
                        const SizedBox(height: 12),
                        _InlineEditableText(
                          text: g('contactMessageLabel'),
                          hint: 'contactMessageLabel',
                          onSubmitted: (v) =>
                              _saveField('contactMessageLabel', v),
                        ),
                        const SizedBox(height: 12),
                        _InlineEditableText(
                          text: g('contactSendButton'),
                          hint: 'contactSendButton',
                          onSubmitted: (v) =>
                              _saveField('contactSendButton', v),
                        ),
                        const Divider(height: 24),
                        _InlineEditableText(
                          text: g('contactEmail'),
                          hint: 'contactEmail',
                          onSubmitted: (v) => _saveField('contactEmail', v),
                        ),
                        const SizedBox(height: 12),
                        _InlineEditableText(
                          text: g('contactPhone'),
                          hint: 'contactPhone',
                          onSubmitted: (v) => _saveField('contactPhone', v),
                        ),
                        const SizedBox(height: 12),
                        _InlineEditableText(
                          text: g('contactInfoTitle'),
                          hint: 'contactInfoTitle',
                          onSubmitted: (v) => _saveField('contactInfoTitle', v),
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
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
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
