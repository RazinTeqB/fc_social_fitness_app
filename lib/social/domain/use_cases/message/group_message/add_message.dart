import 'dart:io';
import 'dart:typed_data';

import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:fc_social_fitness/social/domain/repositories/group_message.dart';

class AddMessageForGroupChatUseCase
    implements UseCaseThreeParams<Message, Message, File, File?> {
  final FirestoreGroupMessageRepository _addPostToUserRepository;
  AddMessageForGroupChatUseCase(this._addPostToUserRepository);

  @override
  Future<Message> call(
      {required Message paramsOne,
      File? paramsTwo,
      required File? paramsThree}) {
    return _addPostToUserRepository.sendMessage(
        messageInfo: paramsOne,
        photoFile: paramsTwo,
        recordFile: paramsThree);
  }
}
