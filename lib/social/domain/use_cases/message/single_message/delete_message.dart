import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:fc_social_fitness/social/domain/repositories/user_repository.dart';

class DeleteMessageUseCase
    implements UseCaseThreeParams<void, Message, Message?, bool> {
  final FirestoreUserRepository _addPostToUserRepository;

  DeleteMessageUseCase(this._addPostToUserRepository);

  @override
  Future<void> call(
      {required Message paramsOne,
      required Message? paramsTwo,
      required bool paramsThree}) {
    return _addPostToUserRepository.deleteMessage(
        messageInfo: paramsOne,
        replacedMessage: paramsTwo,
        isThatOnlyMessageInChat: paramsThree);
  }
}
