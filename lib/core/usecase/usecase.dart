import '../error/either.dart';
import '../error/failure.dart';

/// Every UseCase in every feature implements this contract:
/// given [Params], asynchronously return `Either<Failure, Type>`.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use this for UseCases that don't need any parameters
/// (e.g. `GetProfileUseCase` if the id came from session instead of params).
class NoParams {
  const NoParams();
}
