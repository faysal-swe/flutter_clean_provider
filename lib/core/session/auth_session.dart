/// Minimal in-memory session store.
///
/// In a real production app you'd persist the token with
/// `flutter_secure_storage`, but that's outside the scope of what was
/// requested here — this keeps the example focused on Clean Architecture,
/// networking and error handling.
class AuthSession {
  AuthSession._internal();
  static final AuthSession instance = AuthSession._internal();

  String? _token;

  bool get isLoggedIn => _token != null && _token!.isNotEmpty;
  String? get token => _token;

  void saveToken(String token) => _token = token;

  void clear() => _token = null;
}
