class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? phone;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName'] ?? 'Name Not Found',
      email: json['email'] ?? 'Email Not Found',
      phone: json['phone']?.toString(),
    );
  }

  UserModel copyWith({String? id, String? fullName, String? email, String? phone}) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}