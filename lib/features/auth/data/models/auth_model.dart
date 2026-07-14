import '../../domain/entities/auth_entity.dart';

/// Data-layer model. Extends the domain entity and adds `fromJson`.
/// This is the "adapter" between the wire format (reqres.in's JSON)
/// and the pure domain object the rest of the app works with.
class AuthModel extends AuthEntity {
  const AuthModel({required super.token});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(token: json['token'] as String? ?? '');
  }
}
