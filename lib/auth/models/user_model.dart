class UserModel {
  final String id;
  final String name;
  final String email;
  final String? password;
  final String firebaseUid;
  final String? role;
  final String? photoUrl;
  final bool isGoogleUser;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    required this.firebaseUid,
    this.role,
    this.photoUrl,
    this.isGoogleUser = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      password: json['password'],
      firebaseUid: json['firebase_uid'],
      role: json['role'],
      photoUrl: json['photo_url'],
      isGoogleUser: json['is_google_user'] ?? false,
    );
  }
}