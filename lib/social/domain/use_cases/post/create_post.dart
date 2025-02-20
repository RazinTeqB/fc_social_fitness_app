import 'dart:io';
import 'dart:typed_data';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/core/use_case/use_case.dart';
import '../../repositories/post/post_repository.dart';

class CreatePostUseCase
    implements UseCaseThreeParams<Post, Post, File, Uint8List?> {
  final FireStorePostRepository _createPostRepository;

  CreatePostUseCase(this._createPostRepository);

  @override
  Future<Post> call(
      {required Post paramsOne,
      required File paramsTwo,
      required Uint8List? paramsThree}) {
    return _createPostRepository.createPost(
        postInfo: paramsOne, file: paramsTwo, coverOfVideo: paramsThree);
  }
}
