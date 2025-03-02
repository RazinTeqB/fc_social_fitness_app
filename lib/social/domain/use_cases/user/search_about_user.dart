import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/domain/repositories/user_repository.dart';

class SearchAboutUserUseCase
    implements StreamUseCaseTwoParams<List<UserPersonalInfo>, String, bool> {
  final FirestoreUserRepository _addPostToUserRepository;

  SearchAboutUserUseCase(this._addPostToUserRepository);

  @override
  Stream<List<UserPersonalInfo>> call(
      {required String paramsOne, required bool paramsTwo}) {
    return _addPostToUserRepository.searchAboutUser(
        name: paramsOne, searchForSingleLetter: paramsTwo);
  }
}
