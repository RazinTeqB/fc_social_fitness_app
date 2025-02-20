import 'dart:io';
import 'dart:typed_data';

import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:fc_social_fitness/social/domain/repositories/user_repository.dart';

class AddMessageUseCase
    implements UseCaseThreeParams<Message, Message, File, File?> {
  final FirestoreUserRepository _addPostToUserRepository;

  AddMessageUseCase(this._addPostToUserRepository);

  @override
  Future<Message> call(
      {required Message paramsOne,
      File? paramsTwo,
      required File? paramsThree}) {
    return _addPostToUserRepository.sendMessage(
        messageInfo: paramsOne,
        pathOfPhoto: paramsTwo,
        recordFile: paramsThree);
  }
}
