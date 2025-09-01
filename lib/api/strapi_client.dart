import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pro_kariera/const/api_strapi.dart';

class StrapiClient {
  final http.Client _http;
  StrapiClient({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  Future<Map<String, dynamic>> getSingle({
    required String singleType,
    required String locale,
    String populate = '*',
  }) async {
    final uri = Uri.parse(
      '${ApiStrapi.url}/$singleType',
    ).replace(queryParameters: {'locale': locale, 'populate': populate});

    final resp = await _http.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${ApiStrapi.token}',
        'Accept': 'application/json',
      },
    );

    // Проверяем, что это JSON (а не HTML-страница с ошибкой)
    final ct = resp.headers['content-type'] ?? '';
    if (!ct.contains('application/json')) {
      throw FormatException(
        'Non-JSON response for $singleType ($locale): $ct\nBody (first 200): ${resp.body.substring(0, resp.body.length.clamp(0, 200))}',
      );
    }

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(
        'Strapi $singleType ($locale) -> ${resp.statusCode}: ${resp.body}',
      );
    }

    final root = _toMap(jsonDecode(resp.body));
    final data = _toMap(root['data']);

    // v5: поля лежат прямо в data
    if (data.isNotEmpty && !data.containsKey('attributes')) {
      return Map<String, dynamic>.from(data);
    }

    // v4: поля лежат в data.attributes
    final attrs = _toMap(data['attributes']);
    return attrs;
  }

  // ---------- helpers ----------

  Map<String, dynamic> _toMap(dynamic v) {
    if (v == null) return <String, dynamic>{};
    if (v is Map<String, dynamic>) return v;
    if (v is Map) return Map<String, dynamic>.from(v);
    throw StateError('Expected Map, got ${v.runtimeType}');
  }

  List<Map<String, dynamic>> _toListOfMap(dynamic v) {
    if (v == null) return const [];
    if (v is List) return v.map(_toMap).toList();
    throw StateError('Expected List, got ${v.runtimeType}');
  }
}
