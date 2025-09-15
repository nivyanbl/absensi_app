class UserModel {
  final String id;
  final String fullName;
  final String email;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? 'Name Not Found',
      email: json['email'] ?? 'Email Not Found',
    );
  }
}