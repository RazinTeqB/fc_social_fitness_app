import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/domain/repositories/post/comment/comment_repository.dart';

class RemoveLikeOnThisCommentUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FirestoreCommentRepository _removeLikeRepository;

  RemoveLikeOnThisCommentUseCase(this._removeLikeRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _removeLikeRepository.removeLikeOnThisComment(
        commentId: paramsOne, myPersonalId: paramsTwo);
  }
}
