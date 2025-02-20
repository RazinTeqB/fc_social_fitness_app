import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:fc_social_fitness/social/domain/repositories/group_message.dart';

class DeleteMessageForGroupChatUseCase
    implements UseCaseThreeParams<void, String, Message, Message?> {
  final FirestoreGroupMessageRepository _addPostToUserRepository;

  DeleteMessageForGroupChatUseCase(this._addPostToUserRepository);

  @override
  Future<void> call({
    required String paramsOne,
    required Message paramsTwo,
    required Message? paramsThree,
  }) {
    return _addPostToUserRepository.deleteChat(
        chatOfGroupUid: paramsOne,
        messageInfo: paramsTwo);
  }
}
