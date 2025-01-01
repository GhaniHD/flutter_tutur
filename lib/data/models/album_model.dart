class AlbumModel{
  
  /// Mendefinisikan class AlbumModel untuk menggambarkan data album
  final int id;
  final String title;
  final int userId;
  final String? imageUrl;

  // Konstruktor yang wajib mengisi semua properti
  AlbumModel({ 
    required this.id, 
    required this.title,
    required this.userId,
    this.imageUrl,
  });
  
  // Fungsi untuk membuat objek AlbumModel dari data JSON
  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
    );
  }

  // Fungsi untuk mengubah objek AlbumModel menjadi format JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
    };
  }

}