// // lib/funkcional/language_prompt.dart
// import 'package:flutter/material.dart';
// import 'package:pro_kariera/const/theme.dart';
// import 'package:pro_kariera/widgets/main_app.dart';
// import 'package:universal_html/html.dart' as html;
// import 'dart:ui' as ui;
// import 'package:flutter_localizations/flutter_localizations.dart';
// // <-- импортируем MainApp

// class LanguagePromptApp extends StatefulWidget {
//   const LanguagePromptApp({super.key});

//   @override
//   State<LanguagePromptApp> createState() => _LanguagePromptAppState();
// }

// class _LanguagePromptAppState extends State<LanguagePromptApp> {
//   Locale? _locale;
//   bool _dialogShown = false;

//   @override
//   void initState() {
//     super.initState();
//     final saved = html.window.localStorage['selected_lang'];
//     if (saved == 'uk' || saved == 'de') {
//       _locale = Locale(saved!);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Попытка подхватить системный язык, если ещё нет локали
//     if (_locale == null) {
//       final sys = ui.PlatformDispatcher.instance.locale.languageCode;
//       if (sys == 'uk' || sys == 'de') {
//         _setLocale(Locale(sys));
//       }
//     }

//     return MaterialApp(
//       title: 'ProKariera',
//       theme: proKarieraTheme,
//       locale: _locale,
//       supportedLocales: const [Locale('uk'), Locale('de')],
//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       home: Builder(
//         builder: (ctx) {
//           // здесь MaterialApp уже есть, и локализации загружены
//           if (_locale == null && !_dialogShown) {
//             _dialogShown = true;
//             WidgetsBinding.instance.addPostFrameCallback((_) async {
//               final choice = await showDialog<Locale>(
//                 context: ctx,
//                 barrierDismissible: false,
//                 builder: (_) => const _LanguageSelectionDialog(),
//               );
//               if (choice != null) _setLocale(choice);
//             });
//           }
//           if (_locale == null) {
//             // ждем выбор
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           }
//           // когда локаль известна — рендерим MainApp
//           return const MainApp();
//         },
//       ),
//       debugShowCheckedModeBanner: false,
//     );
//   }

//   void _setLocale(Locale locale) {
//     setState(() => _locale = locale);
//     html.window.localStorage['selected_lang'] = locale.languageCode;
//   }
// }

// class _LanguageSelectionDialog extends StatelessWidget {
//   const _LanguageSelectionDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Оберіть мову / Sprache wählen'),
//       content: const Text(
//         'Ваша система має іншу мову. Будь ласка, оберіть інтерфейс:',
//         textAlign: TextAlign.center,
//       ),
//       actionsAlignment: MainAxisAlignment.center,
//       actions: [
//         ElevatedButton(
//           onPressed: () => Navigator.of(context).pop(const Locale('uk')),
//           child: const Text('Українська'),
//         ),
//         ElevatedButton(
//           onPressed: () => Navigator.of(context).pop(const Locale('de')),
//           child: const Text('Deutsch'),
//         ),
//       ],
//     );
//   }
// }
