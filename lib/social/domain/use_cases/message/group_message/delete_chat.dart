import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:fc_social_fitness/social/domain/repositories/group_message.dart';

class DeleteChatForGroupChatUseCase
    implements UseCaseTwoParams<void, String, Message> {
  final FirestoreGroupMessageRepository _addPostToUserRepository;

  DeleteChatForGroupChatUseCase(this._addPostToUserRepository);

  @override
  Future<void> call({
    required String paramsOne,
    required Message paramsTwo,
  }) {
    return _addPostToUserRepository.deleteChat(chatOfGroupUid: paramsOne, messageInfo: paramsTwo);
  }
}
