/// Domain-level representation of a successful login.
/// Pure Dart, no JSON/serialization concerns here -
/// that belongs in the data layer's model class.
class AuthEntity {
  final String token;

  const AuthEntity({required this.token});
}
