import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro_kariera/const/app_colors.dart';

class AnimatedFabMenu extends StatefulWidget {
  const AnimatedFabMenu({super.key});

  @override
  State<AnimatedFabMenu> createState() => _AnimatedFabMenuState();
}

class _AnimatedFabMenuState extends State<AnimatedFabMenu> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildSocialButton(FontAwesomeIcons.telegram, "Telegram", 0, () {
          html.window.open('https://t.me/491606838896', '_blank');
        }),
        _buildSocialButton(FontAwesomeIcons.whatsapp, "WhatsApp", 1, () {
          final msg = Uri.encodeComponent("Доброго дня! Хочу консультацію.");
          html.window.open('https://wa.me/491606838896?text=$msg', '_blank');
        }),
        _buildSocialButton(FontAwesomeIcons.instagram, "Instagram", 2, () {
          html.window.open(
            'https://www.instagram.com/jobcoach_valeriia',
            '_blank',
          );
        }),
        _buildSocialButton(Icons.mail_outline, "Email", 3, () {
          html.window.open('mailto:Valeriia.kulakova@gmx.de', '_blank');
        }),
        FloatingActionButton(
          shape: BeveledRectangleBorder(
            side: BorderSide(width: 1, color: AppColors.secondaryLight),
          ),
          backgroundColor: Colors.grey.shade200,
          onPressed: () => setState(() => isOpen = !isOpen),
          heroTag: "main",
          child: Icon(isOpen ? Icons.close : Icons.message_outlined),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    IconData icon,
    String label,
    int index,
    VoidCallback onPressed,
  ) {
    return AnimatedSlide(
      offset: isOpen ? Offset.zero : Offset(0, 1),
      duration: Duration(milliseconds: 200 + index * 50),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: isOpen ? 1.0 : 0.0,
        duration: Duration(milliseconds: 200 + index * 50),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: FloatingActionButton(
            shape: BeveledRectangleBorder(
              side: BorderSide(width: 1, color: AppColors.secondaryLight),
            ),
            backgroundColor: Colors.grey.shade200,
            onPressed: onPressed,
            heroTag: label,
            mini: true,
            child: FaIcon(icon, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
