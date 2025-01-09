class UserModel {
  final String id;
  final String name;
  final String email;
  final String firebaseUid;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.firebaseUid,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      firebaseUid: json['firebase_uid'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'firebase_uid': firebaseUid,
      'role': role,
    };
  }
}