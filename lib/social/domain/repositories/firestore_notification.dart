import 'package:fc_social_fitness/social/data/models/child_classes/notification.dart';
import 'package:fc_social_fitness/social/domain/entities/notification_check.dart';

abstract class FirestoreNotificationRepository {
  Future<String> createNotification(
      {required CustomNotification newNotification});
  Future<List<CustomNotification>> getNotifications({required String userId});
  Future<void> deleteNotification(
      {required NotificationCheck notificationCheck});
}
