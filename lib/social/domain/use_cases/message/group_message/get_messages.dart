import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:fc_social_fitness/social/domain/repositories/group_message.dart';

class GetMessagesGroGroupChatUseCase
    implements StreamUseCase<List<Message>, String> {
  final FirestoreGroupMessageRepository _addPostToUserRepository;

  GetMessagesGroGroupChatUseCase(this._addPostToUserRepository);

  @override
  Stream<List<Message>> call({required String params}) {
    return _addPostToUserRepository.getMessages(groupChatUid: params);
  }
}
