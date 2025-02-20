import 'dart:io';
import 'dart:typed_data';
import 'package:fc_social_fitness/social/data/datasourses/remote/firebase_storage.dart';
import 'package:fc_social_fitness/social/data/datasourses/remote/post/firestore_post.dart';
import 'package:fc_social_fitness/social/data/datasourses/remote/user/firestore_user_info.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:mime/mime.dart';
import '../../../domain/repositories/post/post_repository.dart';

class FireStorePostRepositoryImpl implements FireStorePostRepository {
  @override
  Future<Post> createPost({
    required Post postInfo,
    required File file,
    required Uint8List? coverOfVideo,
  }) async {
    try {
      String? mimeType = lookupMimeType(file.path);
      bool isFirstPostImage = mimeType!.startsWith('image/');
      postInfo.isThatImage = isFirstPostImage;
      mimeType = lookupMimeType(file.path);
      bool isThatImage = mimeType!.startsWith('image/');

        String fileName = isThatImage ? "jpg" : "mp4";
        String postUrl = await FirebaseStoragePost.uploadFile(
            postFile: file, folderName: "postUploads");
        postInfo.postUrl = postUrl;
        postInfo.imagesUrls.add(postUrl);
        //todo covervideo
      /*if (coverOfVideo != null) {
        String coverOfVideoUrl = await FirebaseStoragePost.uploadFile(
            postFile: coverOfVideo, folderName: 'postsVideo');
        postInfo.coverOfVideoUrl = coverOfVideoUrl;
      }*/
      postInfo.isThatMix = false;
      Post newPostInfo = await FirestorePost.createPost(postInfo);
      return newPostInfo;
    } catch (e) {
      print(e.toString());
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Post>> getPostsInfo(
      {required List<dynamic> postsIds,
      required int lengthOfCurrentList}) async {
    try {
      return await FirestorePost.getPostsInfo(
          postsIds: postsIds, lengthOfCurrentList: lengthOfCurrentList);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Post>> getAllPostsInfo(
      {required bool isVideosWantedOnly,
      required String skippedVideoUid}) async {
    try {
      return await FirestorePost.getAllPostsInfo(
          isVideosWantedOnly: isVideosWantedOnly,
          skippedVideoUid: skippedVideoUid);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List> getSpecificUsersPosts(List<dynamic> usersIds) async {
    try {
      return await FirestoreUser.getSpecificUsersPosts(usersIds);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> putLikeOnThisPost(
      {required String postId, required String userId}) async {
    try {
      return await FirestorePost.putLikeOnThisPost(
          postId: postId, userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> removeTheLikeOnThisPost(
      {required String postId, required String userId}) async {
    try {
      return await FirestorePost.removeTheLikeOnThisPost(
          postId: postId, userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deletePost({required Post postInfo}) async {
    try {
      await FirestorePost.deletePost(postInfo: postInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<Post> updatePost({required Post postInfo}) async {
    try {
      return await FirestorePost.updatePost(postInfo: postInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
