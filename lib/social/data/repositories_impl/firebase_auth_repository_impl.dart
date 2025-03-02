import 'package:firebase_auth/firebase_auth.dart';
import 'package:fc_social_fitness/social/data/datasourses/remote/notification/firebase_notification.dart';
import 'package:fc_social_fitness/social/domain/entities/registered_user.dart';
import 'package:fc_social_fitness/social/domain/repositories/auth_repository.dart';
import '../datasourses/remote/firebase_auth.dart';

class FirebaseAuthRepositoryImpl implements FirebaseAuthRepository {
  @override
  Future<User> logIn(RegisteredUser userInfo) async {
    try {
      return await FirebaseAuthentication.logIn(
          email: userInfo.email, password: userInfo.password);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> signOut({required String userId}) async {
    try {
      await FirebaseAuthentication.signOut();
      await FirestoreNotification.deleteDeviceToken(userId: userId);
      return;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<User> signUp(RegisteredUser newUserInfo) async {
    try {
      User userId = await FirebaseAuthentication.signUp(
          email: newUserInfo.email, password: newUserInfo.password);
      return userId;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
