import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/domain/entities/notification_check.dart';
import 'package:fc_social_fitness/social/domain/repositories/firestore_notification.dart';

class DeleteNotificationUseCase implements UseCase<void, NotificationCheck> {
  final FirestoreNotificationRepository _notificationRepository;
  DeleteNotificationUseCase(this._notificationRepository);
  @override
  Future<void> call({required NotificationCheck params}) {
    return _notificationRepository.deleteNotification(
        notificationCheck: params);
  }
}
