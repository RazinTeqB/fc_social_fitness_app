import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import 'package:fc_social_fitness/social/domain/repositories/post/post_repository.dart';

class DeletePostUseCase implements UseCase<void, Post> {
  final FireStorePostRepository _deletePostRepository;

  DeletePostUseCase(this._deletePostRepository);

  @override
  Future<void> call({required Post params}) {
    return _deletePostRepository.deletePost(postInfo: params);
  }
}
