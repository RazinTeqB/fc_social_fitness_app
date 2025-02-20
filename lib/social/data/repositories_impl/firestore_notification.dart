import 'package:fc_social_fitness/social/data/datasourses/remote/notification/firebase_notification.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/notification.dart';
import 'package:fc_social_fitness/social/domain/entities/notification_check.dart';
import 'package:fc_social_fitness/social/domain/repositories/firestore_notification.dart';

class FirestoreNotificationRepoImpl implements FirestoreNotificationRepository {
  @override
  Future<String> createNotification(
      {required CustomNotification newNotification}) async {
    try {
      return await FirestoreNotification.createNotification(newNotification);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<CustomNotification>> getNotifications({required String userId}) {
    try {
      return FirestoreNotification.getNotifications(userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deleteNotification(
      {required NotificationCheck notificationCheck}) {
    try {
      return FirestoreNotification.deleteNotification(
          notificationCheck: notificationCheck);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
