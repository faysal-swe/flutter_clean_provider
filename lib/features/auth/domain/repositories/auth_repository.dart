import '../../../../core/error/either.dart';
import '../../../../core/error/failure.dart';
import '../entities/auth_entity.dart';

/// The domain layer only knows about THIS abstract contract.
/// It has no idea Dio, reqres.in, or JSON exist - that's the whole point
/// of Clean Architecture: business logic doesn't depend on implementation
/// details.
abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  });
}
