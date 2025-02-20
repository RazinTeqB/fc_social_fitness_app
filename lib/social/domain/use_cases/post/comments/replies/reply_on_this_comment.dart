import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:fc_social_fitness/social/domain/repositories/post/comment/reply_repository.dart';

class ReplyOnThisCommentUseCase implements UseCase<Comment, Comment> {
  final FirestoreReplyRepository _replayOnThisCommentRepository;

  ReplyOnThisCommentUseCase(this._replayOnThisCommentRepository);

  @override
  Future<Comment> call({required Comment params}) async {
    return await _replayOnThisCommentRepository.replyOnThisComment(
        replyInfo: params);
  }
}
