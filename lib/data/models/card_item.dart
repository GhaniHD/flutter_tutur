class CardItem {
  final double cardSize;
  final double imageSize;
  final double fontSize;
  final String title;
  final String imagePath;
  final int albumId;

  CardItem({
    required this.cardSize,
    required this.imageSize,
    required this.fontSize,
    required this.title,
    required this.imagePath,
    required this.albumId,
  });

  // Method untuk mengonversi JSON menjadi CardItem
  factory CardItem.fromJson(Map<String, dynamic> json) {
    return CardItem(
      cardSize: json['card_size']?.toDouble() ?? 120.0,
      imageSize: json['image_size']?.toDouble() ?? 50.0,
      fontSize: json['font_size']?.toDouble() ?? 12.0,
      title: json['title'] ?? '',
      imagePath: json['image_path'] ?? '',
      albumId: json['album_id'] ?? 0,
    );
  }
}
