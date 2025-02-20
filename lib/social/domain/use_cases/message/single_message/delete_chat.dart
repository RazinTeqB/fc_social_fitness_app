import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:fc_social_fitness/social/domain/repositories/user_repository.dart';

class DeleteChatUseCase implements UseCase<void, Message> {
  final FirestoreUserRepository _addPostToUserRepository;

  DeleteChatUseCase(this._addPostToUserRepository);

  @override
  Future<void> call({required Message params}) {
    return _addPostToUserRepository.deleteChat(messageInfo: params);
  }
}
