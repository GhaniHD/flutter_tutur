// lib/data/models/album_item.dart
class AlbumItem {
  final int id;
  final String name;
  final String? picture;
  final int userId;

  AlbumItem({
    required this.id,
    required this.name,
    this.picture,
    required this.userId,
  });

  factory AlbumItem.fromJson(Map<String, dynamic> json) {
    return AlbumItem(
      id: json['id'],
      name: json['name'],
      picture: json['picture'],
      userId: json['user_id'],
    );
  }
}
