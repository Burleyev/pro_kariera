import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro_kariera/const/app_colors.dart';
import 'package:pro_kariera/l10n/app_localizations.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';
import 'package:pro_kariera/firebase/firestore_content_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _msgC = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _msgC.dispose();
    super.dispose();
  }

  Future<void> _launchUri(Uri uri) async {
    final lang = Localizations.localeOf(context).languageCode;
    final failUk = 'Не вдалося відкрити посилання';
    final failDe = 'Link konnte nicht geöffnet werden';
    final failMsg = (lang == 'de') ? failDe : failUk;

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failMsg)));
    }
  }

  Future<void> _sendFormMail(String to) async {
    if (!_formKey.currentState!.validate()) return;

    final subject = Uri.encodeComponent('New message from ${_nameC.text}');
    final body = Uri.encodeComponent(
      'Name: ${_nameC.text}\nEmail: ${_emailC.text}\n\n${_msgC.text}',
    );
    final uri = Uri.parse('mailto:$to?subject=$subject&body=$body');
    await _launchUri(uri);
  }

  Future<void> _sendToInboxFirestore() async {
    if (!_formKey.currentState!.validate()) return;
    if (_sending) return;
    setState(() => _sending = true);
    try {
      final appLang = Localizations.localeOf(
        context,
      ).languageCode; // 'uk' | 'de'
      final localeKey = appLang == 'uk' ? 'ua' : appLang;
      await FirebaseFirestore.instance.collection('contactMessages').add({
        'name': _nameC.text.trim(),
        'email': _emailC.text.trim(),
        'message': _msgC.text.trim(),
        'locale': localeKey,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'new',
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Повідомлення надіслано')));
      _nameC.clear();
      _emailC.clear();
      _msgC.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Помилка: $e')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLang = Localizations.localeOf(context).languageCode; // 'uk' | 'de'
    final localeKey = appLang == 'uk' ? 'ua' : appLang;

    return StreamBuilder<Map<String, dynamic>>(
      stream: FirestoreContentService.instance.watchContact(localeKey),
      builder: (context, snap) {
        final t = AppLocalizations.of(context)!;
        final isMobile = MediaQuery.of(context).size.width < 1200;
        final data = snap.data ?? const <String, dynamic>{};

        // Тексты/ссылки из Firestore с фоллбэками на i18n и текущие значения
        final formTitle = (data['contactTitle'] as String?) ?? t.contactTitle;
        final email = (data['contactEmail'] as String?) ?? t.contactEmail;
        final phone = (data['contactPhone'] as String?) ?? t.contactPhone;
        final infoTitle =
            (data['contactInfoTitle'] as String?) ?? t.contactInfoTitle;
        final telegram =
            (data['contactTelegram'] as String?) ?? 'https://t.me/491606838896';
        final instagram =
            (data['contactInstagram'] as String?) ??
            'https://www.instagram.com/jobcoach_valeriia';
        final whatsappNumber =
            (data['contactWhatsApp'] as String?) ??
            phone; // можно хранить отдельно
        final whatsappMsg =
            (data['contactWhatsAppMsg'] as String?) ??
            'Доброго дня! Хочу консультацію.';

        // Дополнительные лейблы из Firestore (если заданы)
        final contactNameLabel =
            (data['contactNameLabel'] as String?) ?? t.contactNameLabel;
        final contactEmailLabel =
            (data['contactEmailLabel'] as String?) ?? t.contactEmailLabel;
        final contactMessageLabel =
            (data['contactMessageLabel'] as String?) ?? t.contactMessageLabel;
        final contactSendButton =
            (data['contactSendButton'] as String?) ?? t.contactSendButton;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 120,
            vertical: isMobile ? 48 : 80,
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildForm(
                      t,
                      isMobile,
                      formTitle: formTitle,
                      toEmail: email,
                      nameLabel: contactNameLabel,
                      emailLabel: contactEmailLabel,
                      messageLabel: contactMessageLabel,
                      sendButtonText: contactSendButton,
                    ),
                    const SizedBox(height: 48),
                    _buildInfo(
                      t,
                      infoTitle: infoTitle,
                      email: email,
                      phone: phone,
                      telegram: telegram,
                      instagram: instagram,
                      whatsappNumber: whatsappNumber,
                      whatsappMsg: whatsappMsg,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildForm(
                        t,
                        isMobile,
                        formTitle: formTitle,
                        toEmail: email,
                        nameLabel: contactNameLabel,
                        emailLabel: contactEmailLabel,
                        messageLabel: contactMessageLabel,
                        sendButtonText: contactSendButton,
                      ),
                    ),
                    const SizedBox(width: 100),
                    Expanded(
                      flex: 2,
                      child: _buildInfo(
                        t,
                        infoTitle: infoTitle,
                        email: email,
                        phone: phone,
                        telegram: telegram,
                        instagram: instagram,
                        whatsappNumber: whatsappNumber,
                        whatsappMsg: whatsappMsg,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildForm(
    AppLocalizations t,
    bool isMobile, {
    required String formTitle,
    required String toEmail,
    required String nameLabel,
    required String emailLabel,
    required String messageLabel,
    required String sendButtonText,
  }) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formTitle,
            style: GoogleFonts.rubik(
              fontSize: isMobile ? 22 : 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          _ContactInput(
            controller: _nameC,
            label: nameLabel,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          _ContactInput(
            controller: _emailC,
            label: emailLabel,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim());
              return ok ? null : 'Invalid email';
            },
          ),
          const SizedBox(height: 20),
          _ContactInput(
            controller: _msgC,
            label: messageLabel,
            maxLines: 5,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _sending ? null : _sendToInboxFirestore,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: _sending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(sendButtonText, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(
    AppLocalizations t, {
    required String infoTitle,
    required String email,
    required String phone,
    String? telegram,
    String? instagram,
    String? whatsappNumber,
    String? whatsappMsg,
  }) {
    final phoneDigits = (phone).replaceAll(RegExp(r'[^\d+]'), '');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          infoTitle,
          style: GoogleFonts.rubik(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        _ContactInfoRow(
          icon: Icons.email,
          text: email,
          onTap: () => _launchUri(Uri.parse('mailto:$email')),
        ),
        const SizedBox(height: 16),
        _ContactInfoRow(
          icon: Icons.phone,
          text: phone,
          onTap: () => _launchUri(Uri.parse('tel:$phoneDigits')),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            _SocialIcon(
              FontAwesomeIcons.telegram,
              onTap: () => _launchUri(
                Uri.parse(telegram ?? 'https://t.me/491606838896'),
              ),
            ),
            const SizedBox(width: 16),
            _SocialIcon(
              FontAwesomeIcons.whatsapp,
              onTap: () {
                final msg = Uri.encodeComponent(
                  whatsappMsg ?? 'Доброго дня! Хочу консультацію.',
                );
                final waDigits = (whatsappNumber ?? phone).replaceAll(
                  RegExp(r'[^\d+]'),
                  '',
                );
                html.window.open('https://wa.me/$waDigits?text=$msg', '_blank');
              },
            ),
            const SizedBox(width: 16),
            _SocialIcon(
              FontAwesomeIcons.instagram,
              onTap: () => _launchUri(
                Uri.parse(
                  instagram ?? 'https://www.instagram.com/jobcoach_valeriia',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ContactInput extends StatelessWidget {
  final String label;
  final int maxLines;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const _ContactInput({
    required this.label,
    this.maxLines = 1,
    this.controller,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(width: 2, color: AppColors.secondaryLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(width: 2, color: AppColors.secondaryLight),
        ),
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }
}

class _ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const _ContactInfoRow({required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(width: 12),
          SelectableText(text, style: GoogleFonts.rubik(fontSize: 16)),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIcon(this.icon, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, size: 28, color: AppColors.primary),
    );
  }
}
