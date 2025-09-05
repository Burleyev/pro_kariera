import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_kariera/admin/app/widgets_admin/hero_admin.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pro_kariera/const/cloudinary.dart';
import 'package:pro_kariera/services/cloudinary_service.dart';

class AboutMeAdmin extends StatefulWidget {
  const AboutMeAdmin({super.key});
  @override
  State<AboutMeAdmin> createState() => _AboutMeAdminState();
}

class _AboutMeAdminState extends State<AboutMeAdmin> {
  String _uiLang = 'uk';
  bool _collapsed = false;
  String get _docLocale => _uiLang == 'uk' ? 'ua' : 'de';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(_collapsed ? Icons.expand_more : Icons.expand_less),
                onPressed: () => setState(() => _collapsed = !_collapsed),
              ),
              const Spacer(),
              LanguageSwitcher(
                current: _uiLang,
                onSelect: (c) => setState(() => _uiLang = c),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'AboutMe (inline)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _collapsed
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const Text('AboutMe скрыт — нажмите стрелку'),
            secondChild: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('content')
                      .doc(_docLocale)
                      .snapshots(),
                  builder: (context, snap) {
                    final data = snap.data?.data() ?? {};
                    final about = Map<String, dynamic>.from(
                      data['aboutMe'] as Map? ?? {},
                    );

                    Future<void> saveField(String key, String val) async {
                      await FirebaseFirestore.instance
                          .collection('content')
                          .doc(_docLocale)
                          .set({
                            'aboutMe': {key: val},
                          }, SetOptions(merge: true));
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Сохранено: $key')),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InlineImagePicker(
                          label: 'Фото 1',
                          currentUrl: about['photo1Url'] ?? '',
                          onUploaded: (url, id) async {
                            await FirebaseFirestore.instance
                                .collection('content')
                                .doc(_docLocale)
                                .set({
                                  'aboutMe': {'photo1Url': url, 'photo1Id': id},
                                }, SetOptions(merge: true));
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Фото 1 загружено')),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _InlineImagePicker(
                          label: 'Фото 2',
                          currentUrl: about['photo2Url'] ?? '',
                          onUploaded: (url, id) async {
                            await FirebaseFirestore.instance
                                .collection('content')
                                .doc(_docLocale)
                                .set({
                                  'aboutMe': {'photo2Url': url, 'photo2Id': id},
                                }, SetOptions(merge: true));
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Фото 2 загружено')),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _InlineImagePicker(
                          label: 'Фото 3',
                          currentUrl: about['photo3Url'] ?? '',
                          onUploaded: (url, id) async {
                            await FirebaseFirestore.instance
                                .collection('content')
                                .doc(_docLocale)
                                .set({
                                  'aboutMe': {'photo3Url': url, 'photo3Id': id},
                                }, SetOptions(merge: true));
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Фото 3 загружено')),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        InlineEditableText(
                          text: about['introTitle'] ?? '',
                          hint: 'introTitle',
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          onSubmitted: (v) => saveField('introTitle', v),
                        ),
                        const SizedBox(height: 8),
                        InlineEditableText(
                          text: about['introText'] ?? '',
                          hint: 'introText',
                          multiLine: true,
                          onSubmitted: (v) => saveField('introText', v),
                        ),
                        const SizedBox(height: 8),
                        InlineEditableText(
                          text: about['introText2'] ?? '',
                          hint: 'introText2',
                          multiLine: true,
                          onSubmitted: (v) => saveField('introText2', v),
                        ),
                        const SizedBox(height: 8),
                        InlineEditableText(
                          text: about['advantagesTitle'] ?? '',
                          hint: 'advantagesTitle',
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          onSubmitted: (v) => saveField('advantagesTitle', v),
                        ),
                        const SizedBox(height: 8),
                        InlineEditableText(
                          text: about['advantage'] ?? '',
                          hint: 'advantage',
                          multiLine: true,
                          onSubmitted: (v) => saveField('advantage', v),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineImagePicker extends StatefulWidget {
  final String label;
  final String currentUrl;
  final void Function(String url, String publicId) onUploaded;
  const _InlineImagePicker({
    required this.label,
    required this.currentUrl,
    required this.onUploaded,
  });
  @override
  State<_InlineImagePicker> createState() => _InlineImagePickerState();
}

class _InlineImagePickerState extends State<_InlineImagePicker> {
  bool _uploading = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 120,
                height: 80,
                child: widget.currentUrl.isEmpty
                    ? Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_outlined),
                      )
                    : Image.network(widget.currentUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _uploading ? null : _pickAndUpload,
              icon: _uploading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload),
              label: Text(_uploading ? 'Загрузка…' : 'Загрузить'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickAndUpload() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      if (file.bytes == null) return;
      setState(() => _uploading = true);
      final cloud = CloudinaryService(
        cloudName: kCloudinaryCloudName,
        uploadPreset: kCloudinaryUploadPreset,
      );
      final uploaded = await cloud.uploadBytes(
        bytes: file.bytes!,
        fileName: file.name,
        folder: 'prokariera/about',
      );
      if (!mounted) return;
      widget.onUploaded(uploaded.url, uploaded.publicId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }
}
