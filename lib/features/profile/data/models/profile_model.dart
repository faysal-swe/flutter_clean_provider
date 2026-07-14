import '../../domain/entities/profile_entity.dart';

/// Maps reqres.in's `GET /users/{id}` response:
/// {
///   "data": {
///     "id": 2, "email": "...", "first_name": "...",
///     "last_name": "...", "avatar": "..."
///   },
///   "support": { ... }
/// }
class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.avatarUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return ProfileModel(
      id: data['id'] as int,
      email: data['email'] as String? ?? '',
      firstName: data['first_name'] as String? ?? '',
      lastName: data['last_name'] as String? ?? '',
      avatarUrl: data['avatar'] as String? ?? '',
    );
  }
}
