// // import 'package:pro_kariera/api/strapi_client.dart';

// // /// Какие Single Types читаем в Strapi (UID'ы по API)
// // class _Types {
// //   static const header = 'header';
// //   static const home = 'home-page';
// //   static const about = 'about-me';
// //   static const advantage = 'advantage';
// //   static const contact = 'contact';
// //   static const avgs = 'help'; // AVGS-блок хранится в Single Type "Help"
// //   static const how = 'how-it-work'; // UID в Strapi именно с дефисами
// //   static const services = 'leistungen'; // немецкое название раздела услуг
// //   static const testimonial = 'testimonial'; // если понадобится
// // }

// // /// Утилиты для безопасного доступа к map/спискам
// // T? _as<T>(dynamic v) => v is T ? v : null;
// // Map<String, dynamic> _map(dynamic v) =>
// //     _as<Map<String, dynamic>>(v) ?? const {};
// // List<dynamic> _list(dynamic v) => _as<List<dynamic>>(v) ?? const [];

// // /// Грузит все нужные куски и собирает Map<String,String> для выбранной локали
// // class StrapiLocalesLoader {
// //   final StrapiClient client;

// //   StrapiLocalesLoader(this.client);

// //   /// Найти подпись пункта меню по ключу в header.navItems (repeatable component)
// //   String _navLabel(Map<String, dynamic> header, String key, String fallback) {
// //     final items = _list(header['navItems']);
// //     for (final raw in items) {
// //       final item = _map(raw);
// //       if (item['key'] == key) {
// //         final lbl = item['label'];
// //         if (lbl is String && lbl.trim().isNotEmpty) return lbl;
// //       }
// //     }
// //     return fallback;
// //   }

// //   /// Слить услуги из repeatable компонента services в плоские ключи service{N}Title/Desc
// //   Map<String, String> _servicesToFlat(Map<String, dynamic> leistungen) {
// //     final out = <String, String>{};
// //     final items = _list(leistungen['services']);
// //     for (final raw in items) {
// //       final s = _map(raw);
// //       final id = (s['servicesItem'] as String?)
// //           ?.trim(); // 'service1'..'service6'
// //       if (id == null || id.isEmpty) continue;
// //       final title = s['servicesTitle'] as String? ?? '';
// //       final desc = s['servicesDesc'] as String? ?? '';
// //       out['${id}Title'] = title;
// //       out['${id}Desc'] = desc;
// //     }
// //     return out;
// //   }

// //   Future<Map<String, String>> loadAll(String locale) async {
// //     // если в твоем Strapi включена i18n — передай locale внутрь getSingle
// //     final results = await Future.wait([
// //       client.getSingle(singleType: _Types.header, locale: locale),
// //       client.getSingle(singleType: _Types.home, locale: locale),
// //       client.getSingle(singleType: _Types.about, locale: locale),
// //       client.getSingle(singleType: _Types.advantage, locale: locale),
// //       client.getSingle(singleType: _Types.contact, locale: locale),
// //       client.getSingle(singleType: _Types.avgs, locale: locale),
// //       client.getSingle(singleType: _Types.how, locale: locale),
// //       client.getSingle(singleType: _Types.services, locale: locale),
// //     ]);

// //     final header = _map(results[0]);
// //     final home = _map(results[1]);
// //     final about = _map(results[2]);
// //     final advantage = _map(results[3]);
// //     final contact = _map(results[4]);
// //     final help = _map(results[5]); // AVGS блок
// //     final how = _map(results[6]);
// //     final leistungen = _map(results[7]);

// //     // плоский словарь для услуг
// //     final flatServices = _servicesToFlat(leistungen);

// //     return <String, String>{
// //       // ===== Header / Меню =====
// //       'appTitle': (header['appTitle'] as String?) ?? 'ProKariera',
// //       'menuAbout': _navLabel(header, 'about', 'Über mich'),
// //       'menuServices': _navLabel(header, 'services', 'Leistungen'),
// //       'menuAvgs': _navLabel(header, 'avgs', 'AVGS'),
// //       'menuHowItWorks': _navLabel(header, 'how', 'Etappen'),
// //       'menuTestimonials': _navLabel(header, 'testimonials', 'Testimonials'),
// //       'menuContact': _navLabel(header, 'contact', 'Kontakt'),

// //       // ===== Home (Hero) =====
// //       'heroTitle':
// //           (home['heroTitle'] as String?) ?? 'Karrierecoaching mit Herz',
// //       'heroSubtitle': (home['heroSubtitle'] as String?) ?? '',
// //       'heroButton': (home['heroButton'] as String?) ?? '',

// //       // ===== About Me (интро) =====
// //       'introTitle':
// //           (about['introTitle'] as String?) ?? 'Hallo! Ich bin Karrierecoach',
// //       'introText': (about['introText'] as String?) ?? '',
// //       'introText2': (about['introText2'] as String?) ?? '',

// //       // ===== Advantages =====
// //       'advantagesTitle':
// //           (advantage['advantagesTitle'] as String?) ?? 'Ihre Vorteile mit mir:',
// //       'advantage': (advantage['advantage'] as String?) ?? '',

// //       // ===== Leistungen / Services =====
// //       'servicesTitle':
// //           (leistungen['servicesTitle'] as String?) ?? 'Meine Leistungen',
// //       'service1Title': flatServices['service1Title'] ?? '',
// //       'service1Desc': flatServices['service1Desc'] ?? '',
// //       'service2Title': flatServices['service2Title'] ?? '',
// //       'service2Desc': flatServices['service2Desc'] ?? '',
// //       'service3Title': flatServices['service3Title'] ?? '',
// //       'service3Desc': flatServices['service3Desc'] ?? '',
// //       'service4Title': flatServices['service4Title'] ?? '',
// //       'service4Desc': flatServices['service4Desc'] ?? '',
// //       'service5Title': flatServices['service5Title'] ?? '',
// //       'service5Desc': flatServices['service5Desc'] ?? '',
// //       'service6Title': flatServices['service6Title'] ?? '',
// //       'service6Desc': flatServices['service6Desc'] ?? '',

// //       // ===== AVGS (Help) =====
// //       'avgsTitle':
// //           (help['avgsTitle'] as String?) ??
// //           'AVGS – Kostenlose Karriereberatung',
// //       'avgsText': (help['avgsText'] as String?) ?? '',
// //       'avgsHelp': (help['avgsHelp'] as String?) ?? 'Ich helfe Ihnen:',
// //       'avgsHelp1': (help['avgsHelp1'] as String?) ?? '',
// //       'avgsHelp2': (help['avgsHelp2'] as String?) ?? '',
// //       'avgsHelp3': (help['avgsHelp3'] as String?) ?? '',
// //       'avgsButton': (help['avgsButton'] as String?) ?? '',

// //       // ===== How it works =====
// //       'howItWorksTitle':
// //           (how['howItWorksTitle'] as String?) ??
// //           'So läuft unsere Zusammenarbeit ab',
// //       'step1Title': (how['step1Title'] as String?) ?? 'Anfrage',
// //       'step1Desc': (how['step1Desc'] as String?) ?? '',
// //       'step2Title': (how['step2Title'] as String?) ?? 'Beratung',
// //       'step2Desc': (how['step2Desc'] as String?) ?? '',
// //       'step3Title': (how['step3Title'] as String?) ?? 'Arbeit',
// //       'step3Desc': (how['step3Desc'] as String?) ?? '',
// //       'step4Title': (how['step4Title'] as String?) ?? 'Ergebnis',
// //       'step4Desc': (how['step4Desc'] as String?) ?? '',

// //       // ===== Contacts =====
// //       'testimonialsTitle':
// //           'Testimonials', // заголовок берём отдельно (если нужно — вынеси в Single Type)
// //       'contactTitle':
// //           (contact['contactTitle'] as String?) ?? 'Nachricht hinterlassen',
// //       'contactNameLabel':
// //           (contact['contactNameLabel'] as String?) ?? 'Ihr Name',
// //       'contactEmailLabel':
// //           (contact['contactEmailLabel'] as String?) ?? 'Ihre E-Mail',
// //       'contactMessageLabel':
// //           (contact['contactMessageLabel'] as String?) ?? 'Nachricht',
// //       'contactSendButton':
// //           (contact['contactSendButton'] as String?) ?? 'Senden',
// //       'contactInfoTitle':
// //           (contact['contactInfoTitle'] as String?) ?? 'Kontaktinformation',
// //       'contactEmail':
// //           (contact['contactEmail'] as String?) ?? 'hello@prokariera.de',
// //       'contactPhone': (contact['contactPhone'] as String?) ?? '+49 123 456 789',
// //     };
// //   }
// // }
// import 'package:pro_kariera/api/strapi_client.dart';

// /// Какие Single Types читаем в Strapi (UID'ы по API)
// class _Types {
//   static const header = 'header';
//   static const home = 'home-page';
//   static const about = 'about-me';
//   static const advantage = 'advantage';
//   static const contact = 'contact';
//   static const avgs = 'help'; // AVGS-блок хранится в Single Type "help"
//   static const how = 'how-it-work'; // UID в Strapi именно с дефисами
//   static const services = 'leistungen'; // раздел услуг
// }

// /// Утилиты для безопасного доступа к map/спискам
// T? _as<T>(dynamic v) => v is T ? v : null;
// Map<String, dynamic> _map(dynamic v) =>
//     _as<Map<String, dynamic>>(v) ?? const {};
// List<dynamic> _list(dynamic v) => _as<List<dynamic>>(v) ?? const [];

// String? _str(dynamic v) => v == null
//     ? null
//     : v is String
//     ? v
//     : v.toString();

// /// Грузит все нужные куски и собирает Map<String,String> для выбранной локали
// class StrapiLocalesLoader {
//   final StrapiClient client;
//   StrapiLocalesLoader(this.client);

//   /// Найти подпись пункта меню по ключу в header.navItems (repeatable component)
//   String _navLabel(Map<String, dynamic> header, String key, String fallback) {
//     final items = _list(header['navItems']);
//     for (final raw in items) {
//       final item = _map(raw);
//       final itemKey =
//           _str(item['key']) ?? _str(item['slug']) ?? _str(item['id']);
//       if (itemKey == key) {
//         final lbl = _str(item['label']);
//         if (lbl != null && lbl.trim().isNotEmpty) return lbl;
//       }
//     }
//     return fallback;
//   }

//   /// Слить услуги из repeatable компонента services в плоские ключи service{N}Title/Desc
//   /// Поддерживает два варианта:
//   ///   а) есть явный ключ servicesItem = 'service1'..'service6'
//   ///   б) нет ключа — тогда нумеруем по индексу (1..6)
//   Map<String, String> _servicesToFlat(Map<String, dynamic> leistungen) {
//     final out = <String, String>{};
//     final items = _list(leistungen['services']);
//     for (int i = 0; i < items.length; i++) {
//       final s = _map(items[i]);
//       final explicitId = _str(s['servicesItem']); // например 'service3'
//       final indexId = 'service${i + 1}';
//       final id = (explicitId != null && explicitId.trim().isNotEmpty)
//           ? explicitId
//           : indexId;

//       final title = _str(s['servicesTitle']) ?? _str(s['title']) ?? '';
//       final desc = _str(s['servicesDesc']) ?? _str(s['desc']) ?? '';

//       out['${id}Title'] = title;
//       out['${id}Desc'] = desc;
//     }
//     return out;
//   }

//   Future<Map<String, String>> loadAll(String locale) async {
//     // Если включён i18n, locale обязательно передаём в getSingle
//     final results = await Future.wait([
//       client.getSingle(singleType: _Types.header, locale: locale),
//       client.getSingle(singleType: _Types.home, locale: locale),
//       client.getSingle(singleType: _Types.about, locale: locale),
//       client.getSingle(singleType: _Types.advantage, locale: locale),
//       client.getSingle(singleType: _Types.contact, locale: locale),
//       client.getSingle(singleType: _Types.avgs, locale: locale),
//       client.getSingle(singleType: _Types.how, locale: locale),
//       client.getSingle(singleType: _Types.services, locale: locale),
//     ]);

//     final header = _map(results[0]);
//     final home = _map(results[1]);
//     final about = _map(results[2]);
//     final advantage = _map(results[3]);
//     final contact = _map(results[4]);
//     final help = _map(results[5]); // AVGS блок
//     final how = _map(results[6]);
//     final leistungen = _map(results[7]);

//     final flatServices = _servicesToFlat(leistungen);

//     return <String, String>{
//       // ===== Header / Меню =====
//       'appTitle': _str(header['appTitle']) ?? 'ProKariera',
//       'menuAbout': _navLabel(header, 'about', 'Über mich'),
//       'menuServices': _navLabel(header, 'services', 'Leistungen'),
//       'menuAvgs': _navLabel(header, 'avgs', 'AVGS'),
//       'menuHowItWorks': _navLabel(header, 'how', 'Etappen'),
//       'menuTestimonials': _navLabel(header, 'testimonials', 'Testimonials'),
//       'menuContact': _navLabel(header, 'contact', 'Kontakt'),

//       // ===== Home (Hero) =====
//       'heroTitle': _str(home['heroTitle']) ?? 'Karrierecoaching mit Herz',
//       'heroSubtitle': _str(home['heroSubtitle']) ?? '',
//       'heroButton': _str(home['heroButton']) ?? '',

//       // ===== About Me (интро) =====
//       'introTitle': _str(about['introTitle']) ?? 'Hallo! Ich bin Karrierecoach',
//       'introText': _str(about['introText']) ?? '',
//       'introText2': _str(about['introText2']) ?? '',

//       // ===== Advantages =====
//       'advantagesTitle':
//           _str(advantage['advantagesTitle']) ?? 'Ihre Vorteile mit mir:',
//       'advantage': _str(advantage['advantage']) ?? '',

//       // ===== Leistungen / Services =====
//       'servicesTitle': _str(leistungen['servicesTitle']) ?? 'Meine Leistungen',
//       'service1Title': flatServices['service1Title'] ?? '',
//       'service1Desc': flatServices['service1Desc'] ?? '',
//       'service2Title': flatServices['service2Title'] ?? '',
//       'service2Desc': flatServices['service2Desc'] ?? '',
//       'service3Title': flatServices['service3Title'] ?? '',
//       'service3Desc': flatServices['service3Desc'] ?? '',
//       'service4Title': flatServices['service4Title'] ?? '',
//       'service4Desc': flatServices['service4Desc'] ?? '',
//       'service5Title': flatServices['service5Title'] ?? '',
//       'service5Desc': flatServices['service5Desc'] ?? '',
//       'service6Title': flatServices['service6Title'] ?? '',
//       'service6Desc': flatServices['service6Desc'] ?? '',

//       // ===== AVGS (Help) =====
//       'avgsTitle':
//           _str(help['avgsTitle']) ?? 'AVGS – Kostenlose Karriereberatung',
//       'avgsText': _str(help['avgsText']) ?? '',
//       'avgsHelp': _str(help['avgsHelp']) ?? 'Ich helfe Ihnen:',
//       'avgsHelp1': _str(help['avgsHelp1']) ?? '',
//       'avgsHelp2': _str(help['avgsHelp2']) ?? '',
//       'avgsHelp3': _str(help['avgsHelp3']) ?? '',
//       'avgsButton': _str(help['avgsButton']) ?? '',

//       // ===== How it works =====
//       'howItWorksTitle':
//           _str(how['howItWorksTitle']) ?? 'So läuft unsere Zusammenarbeit ab',
//       'step1Title': _str(how['step1Title']) ?? 'Anfrage',
//       'step1Desc': _str(how['step1Desc']) ?? '',
//       'step2Title': _str(how['step2Title']) ?? 'Beratung',
//       'step2Desc': _str(how['step2Desc']) ?? '',
//       'step3Title': _str(how['step3Title']) ?? 'Arbeit',
//       'step3Desc': _str(how['step3Desc']) ?? '',
//       'step4Title': _str(how['step4Title']) ?? 'Ergebnis',
//       'step4Desc': _str(how['step4Desc']) ?? '',
//       // ===== Price / Kosten =====
//       // 'priceTitle':
//       //     _str(home['priceTitle']) ?? _str(help['priceTitle']) ?? 'Preis',
//       // 'priceCard': _str(home['priceCard']) ?? _str(help['priceCard']) ?? '',
//       // 'azavNote': _str(home['azavNote']) ?? _str(help['azavNote']) ?? '',

//       // // ===== AVGS-Status =====
//       // 'avgsStatusTitle': _str(help['avgsStatusTitle']) ?? 'AVGS-Status',
//       // 'avgsStatusText': _str(help['avgsStatusText']) ?? '',
//       // 'avgsStatusFaqTitle': _str(help['avgsStatusFaqTitle']) ?? '',
//       // 'avgsStatusFaqAnswer': _str(help['avgsStatusFaqAnswer']) ?? '',
//       // ===== FAQ =====
//       // 'faqTitle': _str(help['faqTitle']) ?? 'Häufige Fragen',
//       // 'faqQ1': _str(help['faqQ1']),
//       // 'faqA1': _str(help['faqA1']),
//       // 'faqQ2': _str(help['faqQ2']),
//       // 'faqA2': _str(help['faqA2']),
//       // 'faqQ3': _str(help['faqQ3']),
//       // 'faqA3': _str(help['faqA3']),
//       // 'faqQ4': _str(help['faqQ4']),
//       // 'faqA4': _str(help['faqA4']),
//       // 'faqQ5': _str(help['faqQ5']),
//       // 'faqA5': _str(help['faqA5']),
//       // 'faqQ6': _str(help['faqQ6']),
//       // 'faqA6': _str(help['faqA6']),

//       // ===== Contacts =====
//       'testimonialsTitle': _str(home['testimonialsTitle']) ?? 'Testimonials',
//       'contactTitle': _str(contact['contactTitle']) ?? 'Nachricht hinterlassen',
//       'contactNameLabel': _str(contact['contactNameLabel']) ?? 'Ihr Name',
//       'contactEmailLabel': _str(contact['contactEmailLabel']) ?? 'Ihre E-Mail',
//       'contactMessageLabel':
//           _str(contact['contactMessageLabel']) ?? 'Nachricht',
//       'contactSendButton': _str(contact['contactSendButton']) ?? 'Senden',
//       'contactInfoTitle':
//           _str(contact['contactInfoTitle']) ?? 'Kontaktinformation',
//       'contactEmail': _str(contact['contactEmail']) ?? 'hello@prokariera.de',
//       'contactPhone': _str(contact['contactPhone']) ?? '+49 123 456 789',
//     };
//   }
// }
import 'package:pro_kariera/api/strapi_client.dart';

/// Какие Single Types читаем в Strapi (UID'ы по API)
class _Types {
  static const header = 'header';
  static const home = 'home-page';
  static const about = 'about-me';
  static const advantage = 'advantage';
  static const contact = 'contact';
  static const avgs = 'help';
  static const how = 'how-it-work';
  static const services = 'leistungen'; // поменяй, если UID другой
}

/// -------- утилиты ----------
T? _as<T>(dynamic v) => v is T ? v : null;
Map<String, dynamic> _map(dynamic v) =>
    _as<Map<String, dynamic>>(v) ?? const {};
List<dynamic> _list(dynamic v) => _as<List<dynamic>>(v) ?? const [];
String? _str(dynamic v) => v == null ? null : (v is String ? v : v.toString());

Map<String, String> _mergeMaps(
  Map<String, String> base,
  Map<String, String> top,
) {
  // top перекрывает base
  return {...base, ...top};
}

/// -------- локальные заготовки (fallback) ----------
class LocalFallbacks {
  /// плоский словарь строк на случай отсутствия Strapi
  static Map<String, String> strings(String locale) {
    // очень короткие заготовки; при желании расширяй
    switch (locale) {
      case 'uk':
        return {
          // Header / меню
          'appTitle': 'ProKariera',
          'menuAbout': 'Про мене',
          'menuServices': 'Мої послуги',
          'menuAvgs': 'AVGS',
          'menuHowItWorks': 'Етапи',
          'menuTestimonials': 'Відгуки',
          'menuContact': 'Контакти',

          // Hero / Home
          'heroTitle': 'Кар\'єрний коучинг з турботою',
          'heroSubtitle': 'Робимо ваш шлях до роботи в Німеччині простішим',
          'heroButton': 'Зв’язатися',

          // About
          'introTitle': 'Вітаю! Я кар\'єрний коуч',
          'introText': '',
          'introText2': '',

          // Advantages
          'advantagesTitle': 'Чому зі мною зручно:',
          'advantage': '',

          // Services (6 заготовок)
          'servicesTitle': 'Мої послуги',
          'service1Title': 'Резюме та мотиваційні листи',
          'service1Desc': 'Оформлення документів за німецькими стандартами.',
          'service2Title': 'Підготовка до співбесіди',
          'service2Desc': 'Типові питання та впевнені відповіді.',
          'service3Title': 'Документи для Jobcenter/Agentur',
          'service3Desc': 'Заповнення анкет і бланків без помилок.',
          'service4Title': 'Anerkennung дипломів',
          'service4Desc': 'Поясню, що і куди подавати.',
          'service5Title': 'Стратегія пошуку роботи',
          'service5Desc': 'План дій під вашу ціль.',
          'service6Title': 'Супровід',
          'service6Desc': 'Поруч на всіх етапах.',

          // AVGS
          'avgsTitle': 'AVGS – безкоштовний коучинг',
          'avgsText': '',
          'avgsHelp': 'Я допоможу вам:',
          'avgsHelp1': '',
          'avgsHelp2': '',
          'avgsHelp3': '',
          'avgsButton': 'Дізнатися більше',

          // How it works
          'howItWorksTitle': 'Як ми працюємо',
          'step1Title': 'Запит',
          'step1Desc': '',
          'step2Title': 'Консультація',
          'step2Desc': '',
          'step3Title': 'Робота',
          'step3Desc': '',
          'step4Title': 'Результат',
          'step4Desc': '',

          // Contacts / Testimonials
          'testimonialsTitle': 'Відгуки',
          'contactTitle': 'Залишити повідомлення',
          'contactNameLabel': 'Ваше імʼя',
          'contactEmailLabel': 'Ваш email',
          'contactMessageLabel': 'Повідомлення',
          'contactSendButton': 'Надіслати',
          'contactInfoTitle': 'Контактна інформація',
          'contactEmail': 'hello@prokariera.de',
          'contactPhone': '+49 123 456 789',
        };
      default: // de / en и т.д.
        return {
          'appTitle': 'ProKariera',
          'menuAbout': 'Über mich',
          'menuServices': 'Leistungen',
          'menuAvgs': 'AVGS',
          'menuHowItWorks': 'Ablauf',
          'menuTestimonials': 'Testimonials',
          'menuContact': 'Kontakt',
          'heroTitle': 'Karrierecoaching mit Herz',
          'heroSubtitle': '',
          'heroButton': 'Kontakt',
          'introTitle': 'Hallo! Ich bin Karrierecoach',
          'advantagesTitle': 'Ihre Vorteile mit mir:',
          'servicesTitle': 'Meine Leistungen',
          'service1Title': 'Lebenslauf & Anschreiben',
          'service1Desc': 'Dokumente nach deutschen Standards.',
          'service2Title': 'Interview-Vorbereitung',
          'service2Desc': 'Typische Fragen & starke Antworten.',
          'service3Title': 'Jobcenter/Agentur Unterlagen',
          'service3Desc': 'Formulare korrekt und vollständig.',
          'service4Title': 'Anerkennung',
          'service4Desc': 'Schritte & benötigte Unterlagen.',
          'service5Title': 'Jobsuch-Strategie',
          'service5Desc': 'Plan passend zu Ihrem Ziel.',
          'service6Title': 'Begleitung',
          'service6Desc': 'Unterstützung auf allen Etappen.',
          'avgsTitle': 'AVGS – Kostenlose Karriereberatung',
          'avgsHelp': 'Ich helfe Ihnen:',
          'avgsButton': 'Mehr erfahren',
          'howItWorksTitle': 'So läuft unsere Zusammenarbeit ab',
          'step1Title': 'Anfrage',
          'step2Title': 'Beratung',
          'step3Title': 'Arbeit',
          'step4Title': 'Ergebnis',
          'testimonialsTitle': 'Testimonials',
          'contactTitle': 'Nachricht hinterlassen',
          'contactNameLabel': 'Ihr Name',
          'contactEmailLabel': 'Ihre E-Mail',
          'contactMessageLabel': 'Nachricht',
          'contactSendButton': 'Senden',
          'contactInfoTitle': 'Kontaktinformation',
          'contactEmail': 'hello@prokariera.de',
          'contactPhone': '+49 123 456 789',
        };
    }
  }
}

/// -------- основной загрузчик ----------
class StrapiLocalesLoader {
  final StrapiClient client;
  StrapiLocalesLoader(this.client);

  Future<Map<String, dynamic>> _getSingleSafe(String uid, String locale) async {
    try {
      final res = await client.getSingle(singleType: uid, locale: locale);
      return _map(res);
    } catch (_) {
      // можно ещё залогировать в консоль/Crashlytics
      return {};
    }
  }

  String _navLabel(Map<String, dynamic> header, String key, String fallback) {
    final items = _list(header['navItems']);
    for (final raw in items) {
      final item = _map(raw);
      final itemKey =
          _str(item['key']) ?? _str(item['slug']) ?? _str(item['id']);
      if (itemKey == key) {
        final lbl = _str(item['label']);
        if (lbl != null && lbl.trim().isNotEmpty) return lbl;
      }
    }
    return fallback;
  }

  Map<String, String> _servicesToFlat(Map<String, dynamic> leistungen) {
    final out = <String, String>{};
    final items = _list(leistungen['services']);
    for (int i = 0; i < items.length; i++) {
      final s = _map(items[i]);
      final explicitId = _str(s['servicesItem']); // 'service1'..'service6'
      final id = (explicitId != null && explicitId.trim().isNotEmpty)
          ? explicitId
          : 'service${i + 1}';
      final title = _str(s['servicesTitle']) ?? _str(s['title']) ?? '';
      final desc = _str(s['servicesDesc']) ?? _str(s['desc']) ?? '';
      out['${id}Title'] = title;
      out['${id}Desc'] = desc;
    }
    return out;
  }

  Future<Map<String, String>> loadAll(String locale) async {
    // 1) локальные дефолты — база
    final base = LocalFallbacks.strings(locale);

    // 2) пробуем достать из Strapi (каждый блок безопасно)
    final header = await _getSingleSafe(_Types.header, locale);
    final home = await _getSingleSafe(_Types.home, locale);
    final about = await _getSingleSafe(_Types.about, locale);
    final advantage = await _getSingleSafe(_Types.advantage, locale);
    final contact = await _getSingleSafe(_Types.contact, locale);
    final help = await _getSingleSafe(_Types.avgs, locale);
    final how = await _getSingleSafe(_Types.how, locale);
    final leistungen = await _getSingleSafe(_Types.services, locale);

    // 3) превращаем Strapi-данные в плоский словарь
    final fromStrapi = <String, String>{
      // Header
      if (_str(header['appTitle']) != null)
        'appTitle': _str(header['appTitle'])!,
      'menuAbout': _navLabel(header, 'about', base['menuAbout'] ?? 'About'),
      'menuServices': _navLabel(
        header,
        'services',
        base['menuServices'] ?? 'Services',
      ),
      'menuAvgs': _navLabel(header, 'avgs', base['menuAvgs'] ?? 'AVGS'),
      'menuHowItWorks': _navLabel(
        header,
        'how',
        base['menuHowItWorks'] ?? 'How',
      ),
      'menuTestimonials': _navLabel(
        header,
        'testimonials',
        base['menuTestimonials'] ?? 'Testimonials',
      ),
      'menuContact': _navLabel(
        header,
        'contact',
        base['menuContact'] ?? 'Contact',
      ),

      // Home
      if (_str(home['heroTitle']) != null)
        'heroTitle': _str(home['heroTitle'])!,
      if (_str(home['heroSubtitle']) != null)
        'heroSubtitle': _str(home['heroSubtitle'])!,
      if (_str(home['heroButton']) != null)
        'heroButton': _str(home['heroButton'])!,

      // About
      if (_str(about['introTitle']) != null)
        'introTitle': _str(about['introTitle'])!,
      if (_str(about['introText']) != null)
        'introText': _str(about['introText'])!,
      if (_str(about['introText2']) != null)
        'introText2': _str(about['introText2'])!,

      // Advantages
      if (_str(advantage['advantagesTitle']) != null)
        'advantagesTitle': _str(advantage['advantagesTitle'])!,
      if (_str(advantage['advantage']) != null)
        'advantage': _str(advantage['advantage'])!,

      // AVGS
      if (_str(help['avgsTitle']) != null)
        'avgsTitle': _str(help['avgsTitle'])!,
      if (_str(help['avgsText']) != null) 'avgsText': _str(help['avgsText'])!,
      if (_str(help['avgsHelp']) != null) 'avgsHelp': _str(help['avgsHelp'])!,
      if (_str(help['avgsHelp1']) != null)
        'avgsHelp1': _str(help['avgsHelp1'])!,
      if (_str(help['avgsHelp2']) != null)
        'avgsHelp2': _str(help['avgsHelp2'])!,
      if (_str(help['avgsHelp3']) != null)
        'avgsHelp3': _str(help['avgsHelp3'])!,
      if (_str(help['avgsButton']) != null)
        'avgsButton': _str(help['avgsButton'])!,

      // How it works
      if (_str(how['howItWorksTitle']) != null)
        'howItWorksTitle': _str(how['howItWorksTitle'])!,
      if (_str(how['step1Title']) != null)
        'step1Title': _str(how['step1Title'])!,
      if (_str(how['step1Desc']) != null) 'step1Desc': _str(how['step1Desc'])!,
      if (_str(how['step2Title']) != null)
        'step2Title': _str(how['step2Title'])!,
      if (_str(how['step2Desc']) != null) 'step2Desc': _str(how['step2Desc'])!,
      if (_str(how['step3Title']) != null)
        'step3Title': _str(how['step3Title'])!,
      if (_str(how['step3Desc']) != null) 'step3Desc': _str(how['step3Desc'])!,
      if (_str(how['step4Title']) != null)
        'step4Title': _str(how['step4Title'])!,
      if (_str(how['step4Desc']) != null) 'step4Desc': _str(how['step4Desc'])!,

      // Contacts
      if (_str(home['testimonialsTitle']) != null)
        'testimonialsTitle': _str(home['testimonialsTitle'])!,
      if (_str(contact['contactTitle']) != null)
        'contactTitle': _str(contact['contactTitle'])!,
      if (_str(contact['contactNameLabel']) != null)
        'contactNameLabel': _str(contact['contactNameLabel'])!,
      if (_str(contact['contactEmailLabel']) != null)
        'contactEmailLabel': _str(contact['contactEmailLabel'])!,
      if (_str(contact['contactMessageLabel']) != null)
        'contactMessageLabel': _str(contact['contactMessageLabel'])!,
      if (_str(contact['contactSendButton']) != null)
        'contactSendButton': _str(contact['contactSendButton'])!,
      if (_str(contact['contactInfoTitle']) != null)
        'contactInfoTitle': _str(contact['contactInfoTitle'])!,
      if (_str(contact['contactEmail']) != null)
        'contactEmail': _str(contact['contactEmail'])!,
      if (_str(contact['contactPhone']) != null)
        'contactPhone': _str(contact['contactPhone'])!,
    };

    // услуги отдельно (поверх)
    final fromServices = _servicesToFlat(leistungen);

    // 4) итог: локальные дефолты + Strapi
    final withBlocks = _mergeMaps(base, fromStrapi);
    final finalMap = _mergeMaps(withBlocks, fromServices);
    return finalMap;
  }
}
