import 'package:fc_social_fitness/social/domain/entities/specific_users_info.dart';
import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import '../../../repositories/user_repository.dart';

class GetFollowersAndFollowingsUseCase
    implements
        UseCaseTwoParams<FollowersAndFollowingsInfo, List<dynamic>,
            List<dynamic>> {
  final FirestoreUserRepository _fireStoreUserRepository;

  GetFollowersAndFollowingsUseCase(this._fireStoreUserRepository);

  @override
  Future<FollowersAndFollowingsInfo> call(
      {required List<dynamic> paramsOne, required List<dynamic> paramsTwo}) {
    return _fireStoreUserRepository.getFollowersAndFollowingsInfo(
        followersIds: paramsOne, followingsIds: paramsTwo);
  }
}
