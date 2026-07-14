/// Exceptions thrown from the DATA layer (data sources).
/// These are caught by the repository implementation and converted
/// into [Failure]s (see failure.dart) before being passed up to the
/// domain/presentation layers. The UI never sees a raw exception.

/// Base class so we can catch "any of our own exceptions" if needed.
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

/// 500, 502, 503... - something went wrong on the server.
class ServerException extends AppException {
  final int? statusCode;
  const ServerException({this.statusCode, String message = 'Server error, please try again later.'})
      : super(message);
}

/// 401 - invalid/expired credentials or token.
class UnauthorizedException extends AppException {
  const UnauthorizedException({String message = 'Invalid credentials or session expired.'})
      : super(message);
}

/// 403 - authenticated but not allowed to access this resource.
class ForbiddenException extends AppException {
  const ForbiddenException({String message = 'You do not have permission to do this.'})
      : super(message);
}

/// 404 - resource not found.
class NotFoundException extends AppException {
  const NotFoundException({String message = 'Requested resource was not found.'})
      : super(message);
}

/// Generic 4xx we didn't explicitly handle (e.g. 400 bad request).
class BadRequestException extends AppException {
  const BadRequestException({String message = 'Invalid request. Please check your input.'})
      : super(message);
}

/// Request took too long.
class TimeoutException extends AppException {
  const TimeoutException({String message = 'Connection timed out. Please try again.'})
      : super(message);
}

/// Thrown by our own code (NetworkInfo check) BEFORE we even attempt
/// to hit Dio - i.e. "no internet at all".
class NoInternetException extends AppException {
  const NoInternetException({String message = 'No internet connection. Please check your network.'})
      : super(message);
}

/// Catch-all for anything unexpected (parsing errors, unknown Dio errors, etc).
class UnknownException extends AppException {
  const UnknownException({String message = 'Something went wrong. Please try again.'})
      : super(message);
}
