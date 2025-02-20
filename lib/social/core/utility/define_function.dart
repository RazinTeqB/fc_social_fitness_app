import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/comment.dart';

typedef SelectedCommentCallback = void Function(Comment commentInfo, int index);
typedef UpdateFollowersCallback = void Function(
    bool isThatAdding, dynamic userId);
