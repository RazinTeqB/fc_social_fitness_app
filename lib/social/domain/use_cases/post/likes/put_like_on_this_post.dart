import 'package:fc_social_fitness/social/domain/repositories/post/post_repository.dart';
import 'package:fc_social_fitness/social/core/use_case/use_case.dart';

class PutLikeOnThisPostUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FireStorePostRepository _putLikeOnThisPostRepository;

  PutLikeOnThisPostUseCase(this._putLikeOnThisPostRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _putLikeOnThisPostRepository.putLikeOnThisPost(
        postId: paramsOne, userId: paramsTwo);
  }
}
