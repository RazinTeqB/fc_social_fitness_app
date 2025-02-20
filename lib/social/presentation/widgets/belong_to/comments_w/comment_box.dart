import 'package:fc_social_fitness/utils/internationalization.util.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/core/functions/date_of_now.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/resources/styles_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/notification.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/presentation/cubit/notification/notification_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/commentsInfo/cubit/comments_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/reply_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';

class CommentBox extends StatefulWidget {
  final ValueNotifier<Post> postInfo;
  final ValueNotifier<FocusNode> currentFocus;
  final bool isThatCommentScreen;
  final ValueNotifier<Comment?> selectedCommentInfo;
  final UserPersonalInfo userPersonalInfo;
  final TextEditingController textController;
  final ValueChanged<bool> makeSelectedCommentNullable;
  final bool expandCommentBox;
  const CommentBox({
    Key? key,
    required this.currentFocus,
    this.expandCommentBox = false,
    required this.postInfo,
    required this.selectedCommentInfo,
    required this.textController,
    required this.userPersonalInfo,
    this.isThatCommentScreen = true,
    required this.makeSelectedCommentNullable,
  }) : super(key: key);

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isThatMobile) ...[
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              textOfEmoji('❤'),
              textOfEmoji('🙌'),
              textOfEmoji('🔥'),
              textOfEmoji('👏🏻'),
              textOfEmoji('😢'),
              textOfEmoji('😍'),
              textOfEmoji('😮'),
              textOfEmoji('😂'),
            ],
          ),
        ],
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 15, end: 15),
          child: Row(
            crossAxisAlignment: widget.expandCommentBox ||
                    widget.textController.text.length < 70
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.end,
            children: [
              CircleAvatarOfProfileImage(
                userInfo: widget.userPersonalInfo,
                bodyHeight: 370,
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  cursorColor: FlutterFlowTheme.of(context).course20,
                  focusNode: widget.currentFocus.value,
                  style: FlutterFlowTheme.of(context).bodyText1,
                  maxLines: widget.expandCommentBox ? 1 : null,
                  decoration: InputDecoration.collapsed(
                      hintText: FFLocalizations.of(context).getText(StringsManager.addComment),
                      hintStyle: FlutterFlowTheme.of(context).bodyText1),
                  autofocus: false,
                  controller: widget.textController,
                  onChanged: (e) => setState(() {}),
                ),
              ),
              if (widget.textController.text.isEmpty &&
                  !widget.isThatCommentScreen) ...[
               /* GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.textController.text = '❤';
                    });
                  },
                  child: const Text('❤'),
                ),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.textController.text = '🙌';
                    });
                  },
                  child: const Text('🙌'),
                ),*/
              ] else ...[
                ValueListenableBuilder(
                  valueListenable: widget.selectedCommentInfo,
                  builder: (context, Comment? selectedComment, child) =>
                      InkWell(
                    onTap: () {
                      if (widget.textController.text.isNotEmpty) {
                        postTheComment(
                            widget.userPersonalInfo, selectedComment);
                      }
                    },
                    child: Text(
                      FFLocalizations.of(context).getText(StringsManager.post),
                      style: FlutterFlowTheme.of(context).bodyText1,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 15)
      ],
    );
  }

  Future<void> postTheComment(
      UserPersonalInfo myPersonalInfo, Comment? selectedComment) async {
    final whitespaceRE = RegExp(r"\s+");
    String textWithOneSpaces =
        widget.textController.text.replaceAll(whitespaceRE, " ");

    if (selectedComment == null) {
      CommentsInfoCubit commentsInfoCubit =
          BlocProvider.of<CommentsInfoCubit>(context);
      await commentsInfoCubit.addComment(
          commentInfo: newCommentInfo(myPersonalInfo, textWithOneSpaces));
      widget.makeSelectedCommentNullable(true);

      /// Just to recount the number of comments in the previous page
      if (widget.isThatCommentScreen) {
        setState(() {
          dynamic lastComment = widget.postInfo.value.comments.last;
          widget.postInfo.value.comments.add(lastComment);
        });
      }
    } else {
      Comment replyInfo = newReplyInfo(
          selectedComment, myPersonalInfo.userId, textWithOneSpaces);
      await ReplyInfoCubit.get(context)
          .replyOnThisComment(replyInfo: replyInfo);
      widget.makeSelectedCommentNullable(false);
      if (!mounted) return;
      await PostCubit.get(context)
          .updatePostInfo(postInfo: widget.postInfo.value);
    }
    if (!mounted) return;

    BlocProvider.of<NotificationCubit>(context).createNotification(
        newNotification: createNotification(textWithOneSpaces, myPersonalInfo));
    setState(() {});
  }

  CustomNotification createNotification(
      String textWithOneSpaces, UserPersonalInfo myPersonalInfo) {
    return CustomNotification(
      text: "commented: $textWithOneSpaces",
      postId: widget.postInfo.value.postUid,
      postImageUrl: widget.postInfo.value.postUrl,
      time: DateOfNow.dateOfNow(),
      senderId: myPersonalId,
      receiverId: widget.postInfo.value.publisherId,
      personalUserName: myPersonalInfo.userName,
      personalProfileImageUrl: myPersonalInfo.profileImageUrl,
      isThatLike: false,
      senderName: myPersonalInfo.userName,
    );
  }

  Container customDivider() => Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      color: Colors.grey,
      width: double.infinity,
      height: 0.2);

  Widget textOfEmoji(String emoji) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.textController.text = widget.textController.text + emoji;
          widget.textController.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.textController.text.length));
        });
      },
      child: Text(
        emoji,
        style:FlutterFlowTheme.of(context).title1,
      ),
    );
  }

  Comment newCommentInfo(
      UserPersonalInfo myPersonalInfo, String textWithOneSpaces) {
    return Comment(
      theComment: textWithOneSpaces,
      whoCommentId: myPersonalInfo.userId,
      datePublished: DateOfNow.dateOfNow(),
      postId: widget.postInfo.value.postUid,
      likes: [],
      replies: [],
    );
  }

  Comment newReplyInfo(
      Comment commentInfo, String myPersonalId, String textWithOneSpaces) {
    return Comment(
      datePublished: DateOfNow.dateOfNow(),
      parentCommentId: commentInfo.parentCommentId,
      postId: commentInfo.postId,
      theComment: textWithOneSpaces,
      whoCommentId: myPersonalId,
      likes: [],
    );
  }
}
