import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

abstract class ParentPost {
  String datePublished;
  String caption;
  String publisherId;
  List<dynamic> likes;
  List<dynamic> comments;
  UserPersonalInfo? publisherInfo;
  bool isThatImage;

  ParentPost({
    required this.datePublished,
    required this.publisherId,
    this.publisherInfo,
    this.caption = "",
    required this.comments,
    required this.likes,
    required this.isThatImage,
  });
}
