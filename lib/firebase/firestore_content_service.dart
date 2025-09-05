import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreContentService {
  FirestoreContentService._();
  static final instance = FirestoreContentService._();

  final _db = FirebaseFirestore.instance;

  // --- базовый документ ---
  Stream<Map<String, dynamic>> watchLocale(String locale) {
    return _db
        .collection('content')
        .doc(locale)
        .snapshots()
        .map((s) => s.data() ?? {});
  }

  // --- универсальные помощники ---

  /// Достаёт вложенное значение по пути вида 'AVGS.answersUk' или 'Price.priceTitle'
  Stream<T?> watchPath<T>(String locale, String path) {
    return watchLocale(locale).map((map) {
      dynamic cur = map;
      for (final seg in path.split('.')) {
        if (cur is Map && cur.containsKey(seg)) {
          cur = cur[seg];
        } else {
          return null;
        }
      }
      return cur as T?;
    });
  }

  /// Безопасное чтение списка строк (например, AVGS.answersUk, AVGS.titlesUk)
  Stream<List<String>> watchStringList(String locale, String path) {
    return watchPath<dynamic>(locale, path).map((value) {
      if (value is List) {
        return value.map((e) => e?.toString() ?? '').toList();
      }
      return const <String>[];
    });
  }

  /// Безопасное чтение Map (например, Price)
  Stream<Map<String, dynamic>> watchMap(String locale, String path) {
    return watchPath<dynamic>(locale, path).map((value) {
      if (value is Map<String, dynamic>) return value;
      if (value is Map) {
        return value.map((k, v) => MapEntry(k.toString(), v));
      }
      return <String, dynamic>{};
    });
  }

  // --- конкретные секции (что было) ---
  Stream<Map<String, dynamic>> watchHeaderMenu(String locale) =>
      watchMap(locale, 'HeaderMenu');

  Stream<Map<String, dynamic>> watchHero(String locale) =>
      watchMap(locale, 'Hero');

  Stream<Map<String, dynamic>> watchAboutMe(String locale) =>
      watchMap(locale, 'aboutMe');

  Stream<List<Map<String, dynamic>>> watchServices(String locale) {
    return watchMap(locale, 'services').map((m) {
      // У тебя services как map: service01Title: "...", service02Title: "..."
      // Превратим в список пар (ключ/значение), чтобы удобно отрисовывать.
      return m.entries.map((e) {
        return {'id': e.key, 'value': e.value};
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> watchTestimonials(String locale) {
    return watchLocale(locale).map((data) {
      final raw = data['testimonials'] as Map<String, dynamic>? ?? {};

      // Берём только те элементы, где значение — это Map (сам отзыв).
      final reviewEntries = raw.entries
          .where((e) => e.value is Map) // игнорируем 'testimonialsTitle' и т.п.
          .map(
            (e) => MapEntry(e.key, Map<String, dynamic>.from(e.value as Map)),
          )
          .toList();

      // Если захочешь управлять порядком — добавь поле 'order' в каждый отзыв.
      reviewEntries.sort((a, b) {
        final oa = (a.value['order'] ?? 1) as int;
        final ob = (b.value['order'] ?? 1) as int;
        if (oa != ob) return oa.compareTo(ob);
        return a.key.compareTo(b.key); // стабильность
      });

      return reviewEntries.take(4).map((e) {
        final v = e.value;
        return {
          'id': e.key,
          'avatar': v['avatar'] ?? '',
          'comment': v['comment'] ?? '',
          'name': v['name'] ?? '',
          'stars': v['stars'] ?? 5,
        };
      }).toList();
    });
  }

  Stream<Map<String, dynamic>> watchHowItWorks(String locale) =>
      watchMap(locale, 'howItWorks');

  Stream<Map<String, String>> watchFaq(String locale) {
    return watchMap(locale, 'faq').map((m) {
      return m.map((k, v) => MapEntry(k, v?.toString() ?? ''));
    });
  }

  Stream<Map<String, dynamic>> watchContact(String locale) =>
      watchMap(locale, 'contact');

  // --- ДОБАВЛЕНО: AVGS и Price ---

  /// Весь блок AVGS как Map (включая answersUk/titlesUk/avgsStatusText/...)
  Stream<Map<String, dynamic>> watchAvgs(String locale) =>
      watchMap(locale, 'AVGS');

  /// Только массив ответов (украинская версия)
  Stream<List<String>> watchAvgsAnswersUk(String locale) =>
      watchStringList(locale, 'AVGS.answersUk');

  /// Только массив заголовков (украинская версия)
  Stream<List<String>> watchAvgsTitlesUk(String locale) =>
      watchStringList(locale, 'AVGS.titlesUk');

  /// Блок Price целиком (azavNote, priceCard, priceTitle)
  Stream<Map<String, dynamic>> watchPrice(String locale) =>
      watchMap(locale, 'Price');

  /// Отдельные поля Price (пример)
  Stream<String?> watchPriceTitle(String locale) =>
      watchPath<String>(locale, 'Price.priceTitle');

  Stream<String?> watchPriceCard(String locale) =>
      watchPath<String>(locale, 'Price.priceCard');

  Stream<String?> watchAzavNote(String locale) =>
      watchPath<String>(locale, 'Price.azavNote');
}
