import 'package:fc_social_fitness/social/domain/repositories/calling_rooms_repository.dart';
import 'package:fc_social_fitness/social/core/use_case/use_case.dart';

class GetCallingStatusUseCase extends StreamUseCase<bool, String> {
  final CallingRoomsRepository _callingRoomsRepo;
  GetCallingStatusUseCase(this._callingRoomsRepo);
  @override
  Stream<bool> call({required String params}) {
    return _callingRoomsRepo.getCallingStatus(channelUid: params);
  }
}
