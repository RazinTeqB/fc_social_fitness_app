import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/domain/repositories/post/comment/comment_repository.dart';

class PutLikeOnThisCommentUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FirestoreCommentRepository _putLikeRepository;

  PutLikeOnThisCommentUseCase(this._putLikeRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _putLikeRepository.putLikeOnThisComment(
        commentId: paramsOne, myPersonalId: paramsTwo);
  }
}
