import 'package:firebase_auth/firebase_auth.dart';
import 'package:fc_social_fitness/social/domain/entities/registered_user.dart';

abstract class FirebaseAuthRepository {
  Future<User> signUp(RegisteredUser newUserInfo);
  Future<User> logIn(RegisteredUser userInfo);
  Future<void> signOut({required String userId});
}
