import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/domain/repositories/user_repository.dart';
import 'package:fc_social_fitness/social/core/use_case/use_case.dart';

class GetUserFromUserNameUseCase implements UseCase<UserPersonalInfo?, String> {
  final FirestoreUserRepository _getUserFromUserNameRepository;

  GetUserFromUserNameUseCase(this._getUserFromUserNameRepository);

  @override
  Future<UserPersonalInfo?> call({required String params}) {
    return _getUserFromUserNameRepository.getUserFromUserName(userName: params);
  }
}
