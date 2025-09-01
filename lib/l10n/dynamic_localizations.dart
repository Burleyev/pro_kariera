import 'package:flutter/widgets.dart';
import 'package:pro_kariera/api/strapi_client.dart';
import 'package:pro_kariera/l10n/app_localizations.dart';
import 'package:pro_kariera/l10n/strapi_locales_loader.dart'; // <- см. наш loader с fallback'ами

/// Динамические строки из Strapi с мягкими локальными заготовками.
/// Использование: DynamicLocalizations.of(context).get('menuAbout', t.menuAbout)
class DynamicLocalizations {
  final Locale locale;
  final Map<String, String> _map;

  DynamicLocalizations(this.locale, this._map);

  /// вернёт значение из Strapi-карты, либо fallback (обычно t.xxx)
  String get(String key, String fallback) {
    final v = _map[key];
    if (v == null || v.trim().isEmpty) return fallback;
    return v;
  }

  static DynamicLocalizations of(BuildContext context) {
    final inst = Localizations.of<DynamicLocalizations>(
      context,
      DynamicLocalizations,
    );
    assert(
      inst != null,
      'DynamicLocalizations not found. Add StrapiLocalizationsDelegate.',
    );
    return inst!;
  }
}

/// Делегат, который подгружает карту строк из Strapi (или локальные заготовки).
class StrapiLocalizationsDelegate
    extends LocalizationsDelegate<DynamicLocalizations> {
  final StrapiClient client;
  final StrapiLocalesLoader _loader;

  StrapiLocalizationsDelegate({required this.client})
    : _loader = StrapiLocalesLoader(client);

  @override
  bool isSupported(Locale locale) =>
      const ['uk', 'de', 'en'].contains(locale.languageCode);

  @override
  Future<DynamicLocalizations> load(Locale locale) async {
    // Собираем плоскую карту строк: сначала локальные заготовки,
    // затем перекрываем тем, что удалось получить из Strapi.
    final map = await _loader.loadAll(locale.languageCode);
    return DynamicLocalizations(locale, map);
  }

  @override
  bool shouldReload(covariant StrapiLocalizationsDelegate old) => false;
}
