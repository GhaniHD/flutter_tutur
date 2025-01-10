// lib/data/models/card_modal_item.dart

class CardModalItem {
  final String id;
  final String name;
  final String spelling; // Menambahkan field ejaan
  final String? picture;
  final String? voice;
  final String? albumId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CardModalItem({
    required this.id,
    required this.name,
    required this.spelling,
    this.picture,
    this.voice,
    this.albumId,
    this.createdAt,
    this.updatedAt,
  });

  factory CardModalItem.fromJson(Map<String, dynamic> json) {
    return CardModalItem(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      spelling: json['spelling'] ?? '', // Parsing ejaan dari JSON
      picture: json['picture'],
      voice: json['voice'],
      albumId: json['album_id']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'spelling': spelling,
      'picture': picture,
      'voice': voice,
      'album_id': albumId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Copy with method untuk membuat salinan dengan field yang dimodifikasi
  CardModalItem copyWith({
    String? id,
    String? name,
    String? spelling,
    String? picture,
    String? voice,
    String? albumId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CardModalItem(
      id: id ?? this.id,
      name: name ?? this.name,
      spelling: spelling ?? this.spelling,
      picture: picture ?? this.picture,
      voice: voice ?? this.voice,
      albumId: albumId ?? this.albumId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'CardModalItem(id: $id, name: $name, spelling: $spelling)';
  }
}
