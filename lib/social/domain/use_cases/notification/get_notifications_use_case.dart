import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/notification.dart';
import 'package:fc_social_fitness/social/domain/repositories/firestore_notification.dart';

class GetNotificationsUseCase
    implements UseCase<List<CustomNotification>, String> {
  final FirestoreNotificationRepository _notificationRepository;
  GetNotificationsUseCase(this._notificationRepository);
  @override
  Future<List<CustomNotification>> call({required String params}) {
    return _notificationRepository.getNotifications(userId: params);
  }
}
