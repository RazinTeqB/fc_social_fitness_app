import 'package:fc_social_fitness/social/domain/repositories/post/post_repository.dart';
import 'package:fc_social_fitness/social/core/use_case/use_case.dart';

class RemoveTheLikeOnThisPostUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FireStorePostRepository _removeTheLikeOnThisPostRepository;

  RemoveTheLikeOnThisPostUseCase(this._removeTheLikeOnThisPostRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _removeTheLikeOnThisPostRepository.removeTheLikeOnThisPost(
        postId: paramsOne, userId: paramsTwo);
  }
}
