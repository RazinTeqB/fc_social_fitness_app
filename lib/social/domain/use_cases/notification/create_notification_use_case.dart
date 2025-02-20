import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/notification.dart';
import 'package:fc_social_fitness/social/domain/repositories/firestore_notification.dart';

class CreateNotificationUseCase implements UseCase<String, CustomNotification> {
  final FirestoreNotificationRepository _notificationRepository;
  CreateNotificationUseCase(this._notificationRepository);
  @override
  Future<String> call({required CustomNotification params}) {
    return _notificationRepository.createNotification(newNotification: params);
  }
}
