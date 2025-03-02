import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/post/parent_post.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

class Post extends ParentPost {
  String postUrl;
  List<dynamic> imagesUrls;
  String postUid;
  double aspectRatio;
  String coverOfVideoUrl;

  /// is this post contains images and videos.
  /// It's not the best way, we can combine [isThatImage] and [isThatMix] in enum for example,
  /// But, i made this way because i have a lot of data in the backend without [isThatMix]
  bool isThatMix = false;
  Post({
    required String datePublished,
    required String publisherId,
    UserPersonalInfo? publisherInfo,
    this.postUid = "",
    this.coverOfVideoUrl = "",
    this.isThatMix = false,
    this.postUrl = "",
    required this.imagesUrls,
    required this.aspectRatio,
    String caption = "",
    required List<dynamic> comments,
    required List<dynamic> likes,
    bool isThatImage = true,
  }) : super(
          datePublished: datePublished,
          likes: likes,
          comments: comments,
          publisherId: publisherId,
          caption: caption,
          publisherInfo: publisherInfo,
          isThatImage: isThatImage,
        );

  static Post fromQuery(
      {DocumentSnapshot<Map<String, dynamic>>? doc,
      QueryDocumentSnapshot<Map<String, dynamic>>? query}) {
    dynamic snap = doc ?? query;
    return Post(
      caption: snap.data()?["caption"] ?? "",
      datePublished: snap.data()?["datePublished"] ?? "",
      publisherId: snap.data()?["publisherId"] ?? "",
      likes: snap.data()?["likes"] ?? [],
      comments: snap.data()?["comments"] ?? [],
      coverOfVideoUrl: snap.data()?["coverOfVideoUrl"] ?? "",
      imagesUrls: snap.data()?["imagesUrls"] ?? [],
      postUid: snap.data()?["postUid"] ?? "",
      aspectRatio: snap.data()?["aspectRatio"] ?? 0.0,
      postUrl: snap.data()?["postUrl"] ?? "",
      isThatImage: snap.data()?["isThatImage"] ?? true,
      isThatMix: snap.data()?["isThatMix"] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'caption': caption,
        "datePublished": datePublished,
        "publisherId": publisherId,
        'comments': comments,
        'aspectRatio': aspectRatio,
        'imagesUrls': imagesUrls,
        'likes': likes,
        'postUid': postUid,
        "postUrl": postUrl,
        "coverOfVideoUrl": coverOfVideoUrl,
        "isThatImage": isThatImage,
        "isThatMix": isThatMix,
      };
}
