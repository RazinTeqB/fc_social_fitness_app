import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/domain/entities/sender_info.dart';
import 'package:fc_social_fitness/social/domain/repositories/user_repository.dart';

class GetChatUsersInfoAddMessageUseCase
    implements UseCase<List<SenderInfo>, UserPersonalInfo> {
  final FirestoreUserRepository _addPostToUserRepository;

  GetChatUsersInfoAddMessageUseCase(this._addPostToUserRepository);

  @override
  Future<List<SenderInfo>> call({required UserPersonalInfo params}) {
    return _addPostToUserRepository.getChatUserInfo(myPersonalInfo: params);
  }
}
