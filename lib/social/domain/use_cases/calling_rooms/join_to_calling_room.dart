import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/domain/repositories/calling_rooms_repository.dart';
import 'package:fc_social_fitness/social/core/use_case/use_case.dart';

class JoinToCallingRoomUseCase
    extends UseCaseTwoParams<String, String, UserPersonalInfo> {
  final CallingRoomsRepository _callingRoomsRepo;
  JoinToCallingRoomUseCase(this._callingRoomsRepo);
  @override
  Future<String> call(
      {required String paramsOne, required UserPersonalInfo paramsTwo}) async {
    return await _callingRoomsRepo.joinToRoom(
        channelId: paramsOne, myPersonalInfo: paramsTwo);
  }
}
