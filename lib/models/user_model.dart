enum UserRole {
  attendee,
  staff,
}

class UserModel {
  final String id;
  final String phoneNumber;
  final UserRole role;
  final String? name;
  final DateTime createdAt;
  final bool isActive;

  UserModel({
    required this.id,
    required this.phoneNumber,
    required this.role,
    this.name,
    required this.createdAt,
    this.isActive = true,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      role: UserRole.values.byName(map['role'] ?? 'attendee'),
      name: map['name'],
      createdAt: DateTime.parse(map['createdAt']),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'role': role.name,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}
