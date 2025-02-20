import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/domain/repositories/post/post_repository.dart';
import 'package:fc_social_fitness/social/core/use_case/use_case.dart';

class GetPostsInfoUseCase
    implements UseCaseTwoParams<List<Post>, List<dynamic>, int> {
  final FireStorePostRepository _getPostRepository;

  GetPostsInfoUseCase(this._getPostRepository);

  @override
  Future<List<Post>> call(
      {required List<dynamic> paramsOne, required int paramsTwo}) {
    return _getPostRepository.getPostsInfo(
        postsIds: paramsOne, lengthOfCurrentList: paramsTwo);
  }
}
