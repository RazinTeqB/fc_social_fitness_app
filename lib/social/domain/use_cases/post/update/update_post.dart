import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/domain/repositories/post/post_repository.dart';

class UpdatePostUseCase implements UseCase<Post, Post> {
  final FireStorePostRepository _updatePostRepository;

  UpdatePostUseCase(this._updatePostRepository);

  @override
  Future<Post> call({required Post params}) {
    return _updatePostRepository.updatePost(postInfo: params);
  }
}
