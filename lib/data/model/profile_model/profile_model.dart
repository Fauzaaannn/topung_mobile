import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  const ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.usia,
    required this.jenisKelamin,
  });

  final String id;
  final String username;
  final String email;
  final String role;
  final int usia;
  final String jenisKelamin;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] != null
        ? json['data'] as Map<String, dynamic>
        : json;
    return ProfileModel(
      id: data['id'].toString(),
      username: data['username'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: data['role'] as String? ?? '',
      usia: data['usia'] != null
          ? int.tryParse(data['usia'].toString()) ?? 0
          : 0,
      jenisKelamin: data['jenisKelamin'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'role': role,
    'usia': usia,
    'jenisKelamin': jenisKelamin,
  };

  @override
  List<Object?> get props => [id, username, email, role, usia, jenisKelamin];
}
