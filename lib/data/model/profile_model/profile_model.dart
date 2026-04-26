import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  final String id;
  final String name;
  final String email;
  final String role;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] != null
        ? json['data'] as Map<String, dynamic>
        : json;
    return ProfileModel(
      id: data['id'].toString(),
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: data['role'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
  };

  @override
  List<Object?> get props => [id, name, email, role];
}
