import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Экран админки: входящие сообщения из формы "Контакти".
/// Источник данных: коллекция `contactMessages` в Firestore.
/// Документ ожидается с полями: name, email, message, locale, createdAt(Timestamp), status(new|seen|done).
class MessagesAdminPage extends StatelessWidget {
  const MessagesAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('contactMessages')
        .orderBy('createdAt', descending: true)
        .limit(200);

    return Scaffold(
      appBar: AppBar(title: const Text('Входящие сообщения')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: query.snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Ошибка: ${snap.error}'));
          }
          final docs = snap.data?.docs ?? const [];
          if (docs.isEmpty) {
            return const Center(child: Text('Пока нет сообщений'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final d = docs[i];
              final data = d.data();
              final name = (data['name'] ?? '').toString();
              final email = (data['email'] ?? '').toString();
              final message = (data['message'] ?? '').toString();
              final locale = (data['locale'] ?? '').toString();
              final status = (data['status'] ?? 'new').toString();
              final ts = data['createdAt'];

              DateTime? dt;
              if (ts is Timestamp) dt = ts.toDate();

              Color borderColor = switch (status) {
                'done' => Colors.green,
                'seen' => Colors.orange,
                _ => Colors.blueGrey,
              };

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Верхняя строка с чипами статуса/языка/времени
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Chip(label: Text('Статус: $status')),
                          if (locale.isNotEmpty)
                            Chip(label: Text('Мова: $locale')),
                          if (dt != null) Chip(label: Text(_formatDate(dt!))),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Имя + email
                      Row(
                        children: [
                          const Icon(Icons.person, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            name.isEmpty ? 'Без имени' : name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.email, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: SelectableText(
                              email,
                              maxLines: 1,
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Сообщение
                      SelectableText(message),

                      const SizedBox(height: 12),

                      // Действия
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              await d.reference.update({'status': 'seen'});
                            },
                            icon: const Icon(Icons.remove_red_eye_outlined),
                            label: const Text('Прочитано'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await d.reference.update({'status': 'done'});
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Закрыто'),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Удалить сообщение?'),
                                  content: const Text('Действие необратимо.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text('Отмена'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Удалить'),
                                    ),
                                  ],
                                ),
                              );
                              if (ok == true) {
                                await d.reference.delete();
                              }
                            },
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Удалить'),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              final mailto = Uri(
                                scheme: 'mailto',
                                path: email,
                                queryParameters: {
                                  'subject': 'Re: ProKariera контакт',
                                },
                              );
                              // ignore: deprecated_member_use
                              // launch(mailto.toString());
                            },
                            icon: const Icon(Icons.reply_outlined),
                            label: const Text('Ответить'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

String _formatDate(DateTime dt) {
  // yyyy-mm-dd hh:mm
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  final h = dt.hour.toString().padLeft(2, '0');
  final min = dt.minute.toString().padLeft(2, '0');
  return '$y-$m-$d $h:$min';
}
