class ServiceModel {
  final String id;
  final String titleDe, titleUk;
  final String descDe, descUk;
  final String imageUrl;
  final bool active;

  ServiceModel({
    required this.id,
    required this.titleDe,
    required this.titleUk,
    required this.descDe,
    required this.descUk,
    required this.imageUrl,
    required this.active,
  });

  factory ServiceModel.fromMap(String id, Map<String, dynamic> m) =>
      ServiceModel(
        id: id,
        titleDe: m['title_de'] ?? '',
        titleUk: m['title_uk'] ?? '',
        descDe: m['desc_de'] ?? '',
        descUk: m['desc_uk'] ?? '',
        imageUrl: m['imageUrl'] ?? '',
        active: (m['active'] ?? true) as bool,
      );

  Map<String, dynamic> toMap() => {
    'title_de': titleDe,
    'title_uk': titleUk,
    'desc_de': descDe,
    'desc_uk': descUk,
    'imageUrl': imageUrl,
    'active': active,
  };
}
