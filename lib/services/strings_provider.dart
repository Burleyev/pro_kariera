import 'package:flutter/material.dart';
import 'package:pro_kariera/api/strapi_client.dart';
import 'package:pro_kariera/l10n/strapi_locales_loader.dart';
// твой loader с fallback'ами

class StringsController extends ChangeNotifier {
  final StrapiLocalesLoader loader;
  Map<String, String> _map = const {};
  Locale _locale = const Locale('de');

  StringsController(this.loader);

  Locale get locale => _locale;

  Future<void> load(Locale locale) async {
    _locale = locale;
    _map = await loader.loadAll(locale.languageCode);
    notifyListeners();
  }

  /// Берём значение из карты, если есть; иначе — даём дефолт,
  /// который ты передаёшь из AppLocalizations.
  String get(String key, String defaultValue) {
    final v = _map[key];
    if (v == null || v.trim().isEmpty) return defaultValue;
    return v;
  }
}

class StringsScope extends InheritedNotifier<StringsController> {
  const StringsScope({
    super.key,
    required StringsController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static StringsController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<StringsScope>();
    assert(scope != null, 'StringsScope not found');
    return scope!.notifier!;
  }

  @override
  bool updateShouldNotify(covariant InheritedNotifier oldWidget) => true;
}
