import 'dart:io';
import 'package:fc_social_fitness/social/data/datasourses/remote/chat/group_chat.dart';
import 'package:fc_social_fitness/social/data/datasourses/remote/firebase_storage.dart';
import 'package:fc_social_fitness/social/data/datasourses/remote/user/firestore_user_info.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:fc_social_fitness/social/domain/repositories/group_message.dart';
import 'package:fc_social_fitness/viewmodels/base.viewmodel.dart';

class FirebaseGroupMessageRepoImpl implements FirestoreGroupMessageRepository {
  @override
  Future<Message> createChatForGroups(Message messageInfo) async {
    try {
      Message messageDetails =
          await FireStoreGroupChat.createChatForGroups(messageInfo);
      await FirestoreUser.updateChatsOfGroups(messageInfo: messageInfo);
      CustomBaseViewModel.numberOfMessage.add(CustomBaseViewModel.numberOfMessage.value+1);
      return messageDetails;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<Message> sendMessage(
      {required Message messageInfo,
      File? photoFile,
      required File? recordFile}) async {
    try {
      if (photoFile != null) {
        String imageUrl = await FirebaseStoragePost.uploadFile(
            postFile: photoFile, folderName: "messagesFiles");
        messageInfo.imageUrl = imageUrl;
      }
      if (recordFile != null) {
        String recordedUrl = await FirebaseStoragePost.uploadFile(
            folderName: "messagesFiles", postFile: recordFile);
        messageInfo.recordedUrl = recordedUrl;
      }
      bool updateLastMessage = true;
      if (messageInfo.chatOfGroupId.isEmpty) {
        Message newMessageInfo = await createChatForGroups(messageInfo);
        messageInfo = newMessageInfo;
        updateLastMessage = false;
      }
      Message myMessageInfo = await FireStoreGroupChat.sendMessage(
          updateLastMessage: updateLastMessage, message: messageInfo);

      for (final userId in messageInfo.receiversIds) {
        await FirestoreUser.sendNotification(
            userId: userId, message: messageInfo);
      }

      return myMessageInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<List<Message>> getMessages({required String groupChatUid}) =>
      FireStoreGroupChat.getMessages(groupChatUid: groupChatUid);

  @override
  Future<void> deleteMessage({
    required Message messageInfo,
    required String chatOfGroupUid,
    Message? replacedMessage,
  }) async {
    try {
      await FireStoreGroupChat.deleteMessage(
          chatOfGroupUid: chatOfGroupUid, messageId: messageInfo.messageUid);
      if (replacedMessage != null) {
        await FireStoreGroupChat.updateLastMessage(
            chatOfGroupUid: chatOfGroupUid, message: replacedMessage);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deleteChat({required Message messageInfo, required String chatOfGroupUid})async {
    try {
      await FireStoreGroupChat.deleteChat(chatOfGroupUid: chatOfGroupUid, messageInfo: messageInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
