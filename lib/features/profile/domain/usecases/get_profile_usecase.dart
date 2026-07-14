import '../../../../core/error/either.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileParams {
  final int userId;
  const GetProfileParams(this.userId);
}

class GetProfileUseCase implements UseCase<ProfileEntity, GetProfileParams> {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(GetProfileParams params) {
    return repository.getProfile(params.userId);
  }
}
