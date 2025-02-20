import 'dart:io';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/message.dart';

abstract class FirestoreGroupMessageRepository {
  Future<Message> createChatForGroups(Message messageInfo);

  Future<Message> sendMessage(
      {required Message messageInfo,
      File? photoFile,
      required File? recordFile});

  Stream<List<Message>> getMessages({required String groupChatUid});

  Future<void> deleteMessage(
      {required Message messageInfo,
      required String chatOfGroupUid,
      Message? replacedMessage});

  Future<void> deleteChat(
      {required Message messageInfo,
        required String chatOfGroupUid});
}
