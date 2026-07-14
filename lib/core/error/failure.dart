import 'exceptions.dart';

/// Failures live in the DOMAIN layer. They are the "safe", presentation-friendly
/// counterpart of the exceptions thrown in the data layer. Repositories catch
/// exceptions and map them to a Failure so that UseCases/Providers/UI only ever
/// deal with `Either<Failure, T>`, never with raw try/catch.
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(super.message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);
}

/// Special-cased everywhere in the UI: this is the one failure type that
/// triggers the "auto retry when connection is back & user reopens screen"
/// behavior described in the requirements.
class NoInternetFailure extends Failure {
  const NoInternetFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

/// Central place that turns a thrown [AppException] into a [Failure].
/// Used by every RepositoryImpl so the mapping logic isn't duplicated.
Failure mapExceptionToFailure(Object error) {
  if (error is NoInternetException) return NoInternetFailure(error.message);
  if (error is UnauthorizedException) return UnauthorizedFailure(error.message);
  if (error is ForbiddenException) return ForbiddenFailure(error.message);
  if (error is NotFoundException) return NotFoundFailure(error.message);
  if (error is BadRequestException) return BadRequestFailure(error.message);
  if (error is TimeoutException) return TimeoutFailure(error.message);
  if (error is ServerException) return ServerFailure(error.message);
  if (error is AppException) return UnknownFailure(error.message);
  return const UnknownFailure('Something went wrong. Please try again.');
}
