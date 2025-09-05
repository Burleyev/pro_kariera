import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pro_kariera/admin/app/widgets_admin/messages_admin.dart';
import 'package:pro_kariera/const/app_colors.dart';
import 'package:pro_kariera/const/theme.dart';
import 'package:pro_kariera/firebase_options.dart';
import 'package:pro_kariera/l10n/app_localizations.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:ui' as ui;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:pro_kariera/widgets/screens/main_scafold.dart';
import 'package:pro_kariera/admin/admin_entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AppRoot());
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  static _AppRootState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppRootState>();

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  Locale? _locale;
  Future<void> _testRead() async {
    final snap = await FirebaseFirestore.instance
        .collection('content')
        .doc('ua')
        .get();
    print('content/ua exists=${snap.exists} data=${snap.data()}');
  }

  @override
  void initState() {
    super.initState();

    _initializeLocale();
    _firestoreHealthCheck();
    _testRead();
  }

  Future<void> _firestoreHealthCheck() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('health')
          .doc('check')
          .get();
      if (doc.exists) {
        print('✅ Firestore доступен: ${doc.data()}');
      } else {
        print('⚠️ Firestore доступен, но документа нет.');
      }
    } catch (e) {
      print('❌ Ошибка Firestore: $e');
    }
  }

  void _initializeLocale() {
    try {
      final saved = html.window.localStorage['selected_lang'];
      if (saved == 'uk' || saved == 'de') {
        _locale = Locale(saved!);
        return;
      }
      final sys = ui.PlatformDispatcher.instance.locale.languageCode;
      if (sys == 'uk' || sys == 'de') {
        _locale = Locale(sys);
      }
    } catch (e) {
      _locale = const Locale('uk');
    }
  }

  void setLocale(Locale locale) {
    setState(() => _locale = locale);
    html.window.localStorage['selected_lang'] = locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProKariera',
      theme: proKarieraTheme,
      locale: _locale ?? const Locale('de'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      routes: {
        '/admin': (_) => const AdminEntry(),
        '/admin/messages': (_) => const MessagesAdminPage(),
      },
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            if (_locale == null) LanguageSelectionOverlay(onSelect: setLocale),
          ],
        );
      },
      home: const MainScaffold(),
    );
  }
}

class LanguageSelectionOverlay extends StatelessWidget {
  final void Function(Locale) onSelect;
  const LanguageSelectionOverlay({required this.onSelect, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black45,
        child: Center(
          child: Card(
            color: Colors.grey.shade200,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 2, color: AppColors.secondaryLight),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Оберіть мову\nSprache wählen',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () => onSelect(const Locale('uk')),
                      child: const Text('Українська'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () => onSelect(const Locale('de')),
                      child: const Text('Deutsch'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
