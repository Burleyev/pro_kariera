import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

/// Simple Cloudinary uploader for Flutter Web (and desktop/mobile)
/// without server-side signing (uses an **unsigned** upload preset).
///
/// Usage:
/// ```dart
/// final uploader = CloudinaryUploader(
///   cloudName: '<your_cloud_name>',
///   uploadPreset: 'unsigned_prokariera',
///   folder: 'prokariera/services', // optional
/// );
/// final result = await uploader.pickAndUpload();
/// if (result != null) {
///   final url = result.secureUrl; // https URL for the uploaded image
/// }
/// ```
class CloudinaryUploader {
  CloudinaryUploader({
    required this.cloudName,
    required this.uploadPreset,
    this.folder,
  }) : assert(cloudName.isNotEmpty),
       assert(uploadPreset.isNotEmpty);

  /// Your Cloudinary cloud name (Dashboard → Cloud name)
  final String cloudName;

  /// Unsigned upload preset name (Settings → Upload → Upload presets)
  final String uploadPreset;

  /// Optional target folder inside Cloudinary (e.g. `prokariera/services`).
  final String? folder;

  /// Opens file picker and uploads the selected image.
  /// Returns [CloudinaryUploadInfo] or null if user cancelled.
  Future<CloudinaryUploadInfo?> pickAndUpload() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (picked == null || picked.files.isEmpty) return null;

    final file = picked.files.first;
    final bytes = file.bytes;
    if (bytes == null) return null;

    return uploadBytes(bytes, originalFileName: file.name);
  }

  /// Upload raw bytes (e.g. when you already have image bytes).
  Future<CloudinaryUploadInfo> uploadBytes(
    Uint8List bytes, {
    String originalFileName = 'upload.jpg',
  }) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: originalFileName),
      );

    if (folder != null && folder!.isNotEmpty) {
      request.fields['folder'] = folder!;
    }

    final streamed = await request.send();
    final responseBody = await streamed.stream.bytesToString();

    if (streamed.statusCode != 200) {
      throw Exception(
        'Cloudinary upload failed (${streamed.statusCode}): $responseBody',
      );
    }

    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    return CloudinaryUploadInfo.fromJson(json);
  }

  /// Helper: produce a resized, optimized URL using Cloudinary on-the-fly transforms.
  /// Example: `f_auto,q_auto,w_600`.
  String sizedUrl(String secureUrl, {int width = 600}) {
    return secureUrl.replaceFirst(
      '/upload/',
      '/upload/f_auto,q_auto,w_$width/',
    );
  }

  /// Helper: small thumbnail URL (default 360px wide).
  String thumbUrl(String secureUrl, {int width = 360}) =>
      sizedUrl(secureUrl, width: width);
}

/// Parsed result from Cloudinary upload API.
class CloudinaryUploadInfo {
  CloudinaryUploadInfo({
    required this.secureUrl,
    required this.publicId,
    required this.bytes,
    required this.width,
    required this.height,
    required this.format,
  });

  final String secureUrl; // https URL to the asset
  final String publicId; // e.g. prokariera/services/abc123
  final int bytes; // file size
  final int width; // px
  final int height; // px
  final String format; // jpg/png/webp

  factory CloudinaryUploadInfo.fromJson(Map<String, dynamic> json) {
    return CloudinaryUploadInfo(
      secureUrl: json['secure_url'] as String,
      publicId: json['public_id'] as String,
      bytes: (json['bytes'] as num?)?.toInt() ?? 0,
      width: (json['width'] as num?)?.toInt() ?? 0,
      height: (json['height'] as num?)?.toInt() ?? 0,
      format: (json['format'] as String?) ?? 'unknown',
    );
  }
}
