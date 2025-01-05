class Album {
  final String name;
  final String picture;
  final int userId;

  Album({required this.name, required this.picture, required this.userId});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'picture': picture,
      'user_id': userId,
    };
  }
}
