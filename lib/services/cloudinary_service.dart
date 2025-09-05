import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class CloudinaryUploadResult {
  final String url; // secure_url
  final String publicId; // public_id
  final String format; // optional
  CloudinaryUploadResult({
    required this.url,
    required this.publicId,
    required this.format,
  });
}

class CloudinaryService {
  CloudinaryService({required this.cloudName, required this.uploadPreset});

  final String cloudName;
  final String uploadPreset;

  /// Web/Desktop/Mobile: загружаем bytes + имя файла
  Future<CloudinaryUploadResult> uploadBytes({
    required Uint8List bytes,
    required String fileName,
    String? folder, // e.g. 'prokariera/avatars'
  }) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/auto/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset;

    if (folder != null && folder.isNotEmpty) {
      request.fields['folder'] = folder;
    }

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName.isNotEmpty ? fileName : 'upload.jpg',
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Cloudinary upload error: ${response.statusCode} ${response.body}',
      );
    }

    final Map<String, dynamic> map =
        jsonDecode(response.body) as Map<String, dynamic>;
    final String url = (map['secure_url'] as String?) ?? '';
    final String publicId = (map['public_id'] as String?) ?? '';
    final String format = (map['format'] as String?) ?? '';

    if (url.isEmpty || publicId.isEmpty) {
      throw Exception(
        'Cloudinary response missing secure_url/public_id: ${response.body}',
      );
    }

    return CloudinaryUploadResult(url: url, publicId: publicId, format: format);
  }
}
