import '../../../../core/error/either.dart';
import '../../../../core/error/failure.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile(int userId);
}
