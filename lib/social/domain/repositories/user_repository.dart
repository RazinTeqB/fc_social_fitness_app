import 'dart:io';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/domain/entities/sender_info.dart';
import 'package:fc_social_fitness/social/domain/entities/specific_users_info.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

abstract class FirestoreUserRepository {
  Future<void> addNewUser(UserPersonalInfo newUserInfo);

  Future<UserPersonalInfo> getPersonalInfo(
      {required String userId, bool getDeviceToken = false});

  Future<List<UserPersonalInfo>> getAllUnFollowersUsers(
      UserPersonalInfo myPersonalInfo);

  Stream<List<UserPersonalInfo>> getAllUsers();

  Future<UserPersonalInfo?> getUserFromUserName({required String userName});

  Future<UserPersonalInfo> updateUserPostsInfo(
      {required String userId, required Post postInfo});

  Future<UserPersonalInfo> updateUserInfo({required UserPersonalInfo userInfo});

  Future<String> uploadProfileImage(
      {required File photo,
      required String userId,
      required String previousImageUrl});

  Future<FollowersAndFollowingsInfo> getFollowersAndFollowingsInfo(
      {required List<dynamic> followersIds,
      required List<dynamic> followingsIds});

  Future<List<UserPersonalInfo>> getSpecificUsersInfo(
      {required List<dynamic> usersIds});

  Future<void> followThisUser(String followingUserId, String myPersonalId);

  Future<void> unFollowThisUser(String followingUserId, String myPersonalId);
  Stream<UserPersonalInfo> getMyPersonalInfo();

  Stream<List<UserPersonalInfo>> searchAboutUser(
      {required String name, required bool searchForSingleLetter});

  Future<Message> sendMessage(
      {required Message messageInfo,
      File? pathOfPhoto,
      required File? recordFile});

  Stream<List<Message>> getMessages({required String receiverId});

  Future<void> deleteMessage(
      {required Message messageInfo,
      Message? replacedMessage,
      required bool isThatOnlyMessageInChat});

  Future<void> deleteChat({required Message messageInfo});

  Future<SenderInfo> getSpecificChatInfo(
      {required String chatUid, required bool isThatGroup});
  Future<List<SenderInfo>> getChatUserInfo(
      {required UserPersonalInfo myPersonalInfo});
}
