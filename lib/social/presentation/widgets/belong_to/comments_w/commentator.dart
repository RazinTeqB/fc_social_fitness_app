import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/config/routes/app_routes.dart';
import 'package:fc_social_fitness/social/config/routes/customRoutes/hero_dialog_route.dart';
import 'package:fc_social_fitness/social/core/functions/date_of_now.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/notification.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/domain/entities/notification_check.dart';
import 'package:fc_social_fitness/social/presentation/cubit/notification/notification_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/commentsInfo/cubit/comment_likes/comment_likes_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/replyLikes/reply_likes_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/reply_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/pages/profile/users_who_likes_for_mobile.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/profile_w/which_profile_page.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:fc_social_fitness/social/core/functions/toast_show.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';
import '../../../../../utils/internationalization.util.dart';

// ignore: must_be_immutable
class CommentInfo extends StatefulWidget {
  int index;
  bool addReply;
  bool isThatReply;
  final Comment commentInfo;
  final bool rebuildComment;
  Map<int, bool> showMeReplies;
  UserPersonalInfo myPersonalInfo;
  ValueNotifier<TextEditingController> textController;
  final ValueNotifier<ValueChanged<Comment>>? selectedCommentInfo;
  final ValueChanged<bool> rebuildCallback;
  final ValueNotifier<Post> postInfo;
  ValueNotifier<FocusNode> currentFocus;

  CommentInfo(
      {Key? key,
      required this.commentInfo,
      required this.currentFocus,
      this.selectedCommentInfo,
      required this.index,
      this.isThatReply = false,
      required this.myPersonalInfo,
      required this.rebuildComment,
      required this.showMeReplies,
      required this.rebuildCallback,
      required this.addReply,
      required this.textController,
      required this.postInfo})
      : super(key: key);

  @override
  State<CommentInfo> createState() => _CommentInfoState();
}

class _CommentInfoState extends State<CommentInfo> {
  @override
  Widget build(BuildContext context) {
    bool isLiked = widget.commentInfo.likes.contains(myPersonalId);
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10, top: 10),
      child: Column(
        children: [
          rowOfCommentator(context, isLiked, widget.commentInfo.theComment),
          if (!widget.isThatReply && widget.commentInfo.replies!.isNotEmpty)
            widget.showMeReplies[widget.index] == false
                ? textOfReplyCount(context)
                : showReplies(context),
        ],
      ),
    );
  }

  BlocBuilder<ReplyInfoCubit, ReplyInfoState> showReplies(
      BuildContext context) {
    return BlocBuilder<ReplyInfoCubit, ReplyInfoState>(
        bloc: BlocProvider.of<ReplyInfoCubit>(context)
          ..getRepliesOfThisComment(commentId: widget.commentInfo.commentUid),
        buildWhen: (previous, current) {
          if (previous != current && (current is CubitReplyInfoLoaded)) {
            return true;
          }
          if (widget.rebuildComment) {
            widget.rebuildCallback(false);
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is CubitReplyInfoLoaded) {
            List<Comment> repliesInfo =
                BlocProvider.of<ReplyInfoCubit>(context).repliesOnComment;
            return Padding(
              padding: const EdgeInsetsDirectional.only(start: 40.0),
              child: ListView.separated(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    return CommentInfo(
                      showMeReplies: widget.showMeReplies,
                      commentInfo: repliesInfo[index],
                      textController: widget.textController,
                      rebuildCallback: widget.rebuildCallback,
                      index: index,
                      selectedCommentInfo: widget.selectedCommentInfo,
                      myPersonalInfo: widget.myPersonalInfo,
                      addReply: widget.addReply,
                      isThatReply: true,
                      rebuildComment: widget.rebuildComment,
                      postInfo: widget.postInfo,
                      currentFocus: widget.currentFocus,
                    );
                  },
                  itemCount: repliesInfo.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                        height: 20,
                      )),
            );
          } else if (state is CubitReplyInfoFailed) {
            ToastShow.toastStateError(state);
            return Text(state.toString(),
                style: FlutterFlowTheme.of(context).bodyText1);
          } else {
            return textOfLoading(context, FFLocalizations.of(context).getText(StringsManager.loading));
          }
        });
  }

  Padding textOfLoading(BuildContext context, String loadingText) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 50.0),
      child: Row(
        children: [
          Container(
              color: FlutterFlowTheme.of(context).primaryText, height: 1, width: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Text(loadingText,
                style: FlutterFlowTheme.of(context).bodyText1),
          )
        ],
      ),
    );
  }

  Padding textOfReplyCount(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 50.0, bottom: 10),
      child: Row(
        children: [
          Container(
              color: FlutterFlowTheme.of(context).primaryText, height: 1, width: 40),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.showMeReplies.update(widget.index, (value) => true);
                });
              },
              child: Text(
                "${FFLocalizations.of(context).getText(StringsManager.view)} ${widget.commentInfo.replies!.length} ${FFLocalizations.of(context).getText(StringsManager.more)} ${widget.commentInfo.replies!.length > 1 ? FFLocalizations.of(context).getText(StringsManager.replies) : FFLocalizations.of(context).getText(StringsManager.reply)}",
                style: FlutterFlowTheme.of(context).bodyText1,
              ),
            ),
          )
        ],
      ),
    );
  }

  Row rowOfCommentator(
      BuildContext context, bool isLiked, String hashTageOfUserName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        profileImage(context),
        const SizedBox(width: 15),
        buildCommentInfo(context, hashTageOfUserName),
        if (!widget.commentInfo.isLoading) loveButton(isLiked, context)
      ],
    );
  }

  GestureDetector profileImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushToPage(context,
            page: WhichProfilePage(
                userId: widget.commentInfo.whoCommentInfo!.userId),
            withoutRoot: false);
      },
      child: CircleAvatarOfProfileImage(
        userInfo: widget.commentInfo.whoCommentInfo!,
        bodyHeight: widget.isThatReply ? 280 : 400,
      ),
    );
  }

  Expanded buildCommentInfo(BuildContext context, String hashTageOfUserName) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top: 3),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              whoCommentUserName(context, hashTageOfUserName),
              const SizedBox(height: 5),
              commentOption(context),
              const SizedBox(height: 15),
            ]),
      ),
    );
  }

  Widget commentOption(BuildContext context) {
    return Row(
      children: [
        Text(DateOfNow.commentsDateOfNow(widget.commentInfo.datePublished),
            style: FlutterFlowTheme.of(context).bodyText1),
        if (widget.commentInfo.likes.isNotEmpty) usersWhoLikes(context),
        const SizedBox(width: 20),
        replayButton(context),
      ],
    );
  }

  InkWell replayButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        String hashTag = "@${widget.commentInfo.whoCommentInfo!.userName} ";
        widget.textController.value.text = hashTag;
        widget.textController.value.selection = TextSelection.fromPosition(
            TextPosition(offset: widget.textController.value.text.length));
        Comment commentInfo = widget.commentInfo;
        if (widget.commentInfo.parentCommentId.isEmpty) {
          commentInfo.parentCommentId = commentInfo.commentUid;
        }
        setState(() => widget.selectedCommentInfo?.value(commentInfo));
      },
      child: Text(
        FFLocalizations.of(context).getText(StringsManager.reply),
        style: FlutterFlowTheme.of(context).bodyText1,
      ),
    );
  }

  Padding usersWhoLikes(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: InkWell(
        onTap: () {
            pushToPage(
              context,
              page: UsersWhoLikesForMobile(
                showSearchBar: false,
                usersIds: widget.commentInfo.likes,
                isThatMyPersonalId:
                    widget.commentInfo.whoCommentId == myPersonalId,
              ),
            );
        },
        child: Text(
          "${widget.commentInfo.likes.length} ${widget.commentInfo.likes.length == 1 ? FFLocalizations.of(context).getText(StringsManager.like) : FFLocalizations.of(context).getText(StringsManager.likes)}",
          style: FlutterFlowTheme.of(context).bodyText1,
        ),
      ),
    );
  }

  GestureDetector whoCommentUserName(
      BuildContext context, String hashTageOfUserName) {
    return GestureDetector(
      onTap: () {
        pushToPage(context,
            page: WhichProfilePage(
                userId: widget.commentInfo.whoCommentInfo!.userId));
      },
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: widget.commentInfo.whoCommentInfo!.userName,
              style: FlutterFlowTheme.of(context).bodyText1,
            ),
            const TextSpan(
              text: '  ',
            ),
            if (widget.isThatReply)
              TextSpan(
                text: hashTageOfUserName.split(" ")[0],
                style: FlutterFlowTheme.of(context).bodyText1,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    List<String> hashTagName = hashTageOfUserName.split(" ");
                    String userName = hashTagName[0].replaceAll('@', '');
                    await pushToPage(context,
                        page: WhichProfilePage(
                          userName: userName,
                        ));
                  },
              ),
            TextSpan(
              style: FlutterFlowTheme.of(context).bodyText1,
              text:
                  " ${widget.isThatReply ? hashTageOfUserName.split(" ")[1] : hashTageOfUserName}",
            )
          ],
        ),
      ),
    );
  }

  Widget loveButton(bool isLiked, BuildContext context) {
    return GestureDetector(
      child: !isLiked
          ? Icon(
              Icons.favorite_border,
              size: 15,
              color: FlutterFlowTheme.of(context).primaryText,
            )
          : const Icon(
              Icons.favorite,
              size: 15,
              color: Colors.red,
            ),
      onTap: () {
        setState(() {
          if (isLiked) {
            if (widget.isThatReply) {
              BlocProvider.of<ReplyLikesCubit>(context).removeLikeOnThisReply(
                  replyId: widget.commentInfo.commentUid,
                  myPersonalId: myPersonalId);
            } else {
              BlocProvider.of<CommentLikesCubit>(context)
                  .removeLikeOnThisComment(
                postId: widget.commentInfo.postId,
                commentId: widget.commentInfo.commentUid,
                myPersonalId: myPersonalId,
              );
            }
            widget.commentInfo.likes.remove(myPersonalId);
            //for notification
            BlocProvider.of<NotificationCubit>(context).deleteNotification(
                notificationCheck:
                    createNotificationCheck(widget.postInfo.value));
          } else {
            if (widget.isThatReply) {
              BlocProvider.of<ReplyLikesCubit>(context).putLikeOnThisReply(
                replyId: widget.commentInfo.commentUid,
                myPersonalId: myPersonalId,
              );
            } else {
              BlocProvider.of<CommentLikesCubit>(context).putLikeOnThisComment(
                postId: widget.commentInfo.postId,
                commentId: widget.commentInfo.commentUid,
                myPersonalId: myPersonalId,
              );
            }
            widget.commentInfo.likes.add(myPersonalId);
            //for notification
            BlocProvider.of<NotificationCubit>(context).createNotification(
                newNotification: createNotification(widget.commentInfo));
          }
        });
      },
    );
  }

  NotificationCheck createNotificationCheck(Post postInfo) {
    return NotificationCheck(
      senderId: myPersonalId,
      receiverId: postInfo.publisherId,
      postId: postInfo.postUid,
      isThatLike: false,
    );
  }

  CustomNotification createNotification(Comment commentInfo) {
    return CustomNotification(
      text: "${FFLocalizations.of(context).getText(StringsManager.likedAComment)}:${commentInfo.theComment}",
      postId: widget.postInfo.value.postUid,
      postImageUrl: widget.postInfo.value.imagesUrls.length > 1
          ? widget.postInfo.value.imagesUrls[0]
          : widget.postInfo.value.postUrl,
      time: DateOfNow.dateOfNow(),
      senderId: myPersonalId,
      receiverId: widget.postInfo.value.publisherId,
      personalUserName: widget.myPersonalInfo.userName,
      personalProfileImageUrl: widget.myPersonalInfo.profileImageUrl,
      isThatLike: false,
      senderName: widget.myPersonalInfo.userName,
    );
  }
}
