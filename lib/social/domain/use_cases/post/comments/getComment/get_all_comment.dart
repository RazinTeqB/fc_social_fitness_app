import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:fc_social_fitness/social/domain/repositories/post/comment/comment_repository.dart';

class GetSpecificCommentsUseCase implements UseCase<List<Comment>, String> {
  final FirestoreCommentRepository _getAllCommentsRepository;

  GetSpecificCommentsUseCase(this._getAllCommentsRepository);

  @override
  Future<List<Comment>> call({required String params}) {
    return _getAllCommentsRepository.getSpecificComments(postId: params);
  }
}
