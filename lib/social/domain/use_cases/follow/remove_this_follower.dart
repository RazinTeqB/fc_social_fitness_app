import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/domain/repositories/user_repository.dart';

class UnFollowThisUserUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FirestoreUserRepository _unFollowThisUserRepository;

  UnFollowThisUserUseCase(this._unFollowThisUserRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _unFollowThisUserRepository.unFollowThisUser(paramsOne, paramsTwo);
  }
}
