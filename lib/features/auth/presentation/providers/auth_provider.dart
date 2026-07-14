import 'package:flutter/foundation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/session/auth_session.dart';
import '../../domain/usecases/login_usecase.dart';

enum AuthStatus { idle, loading, success, error }

/// Provider = presentation-layer state holder. It calls the UseCase,
/// never the repository or data source directly - that's the whole
/// point of the layering.
class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  AuthProvider({required this.loginUseCase});

  AuthStatus status = AuthStatus.idle;
  String? errorMessage;

  /// True only when the last failure was specifically "no internet".
  /// The login screen uses this to know it's safe to silently retry
  /// once connectivity returns (rather than surfacing a stale error).
  bool lastFailureWasNetwork = false;

  bool get isLoading => status == AuthStatus.loading;

  Future<void> login({required String email, required String password}) async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    final result = await loginUseCase(LoginParams(email: email, password: password));

    result.fold(
      (failure) {
        status = AuthStatus.error;
        errorMessage = failure.message;
        lastFailureWasNetwork = failure is NoInternetFailure;
        notifyListeners();
      },
      (auth) {
        AuthSession.instance.saveToken(auth.token);
        status = AuthStatus.success;
        lastFailureWasNetwork = false;
        notifyListeners();
      },
    );
  }

  void resetError() {
    status = AuthStatus.idle;
    errorMessage = null;
    notifyListeners();
  }
}
