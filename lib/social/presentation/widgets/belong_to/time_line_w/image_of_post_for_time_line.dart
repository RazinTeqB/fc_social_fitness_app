import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/config/routes/app_routes.dart';
import 'package:fc_social_fitness/social/config/routes/customRoutes/hero_dialog_route.dart';
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
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:fc_social_fitness/social/presentation/pages/comments/comments_for_mobile.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/comments_w/comment_box.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_post_display.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/others/image_of_post.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';
import '../../../../../utils/internationalization.util.dart';

class PostOfTimeLine extends StatefulWidget {
  final ValueNotifier<Post> postInfo;
  final bool playTheVideo;
  final VoidCallback reLoadData;
  final ValueChanged<int> removeThisPost;

  final int indexOfPost;
  final ValueNotifier<List<Post>> postsInfo;

  const PostOfTimeLine({
    Key? key,
    required this.postInfo,
    required this.reLoadData,
    required this.indexOfPost,
    required this.playTheVideo,
    required this.postsInfo,
    required this.removeThisPost,
  }) : super(key: key);

  @override
  State<PostOfTimeLine> createState() => _PostOfTimeLineState();
}

class _PostOfTimeLineState extends State<PostOfTimeLine>
    with TickerProviderStateMixin {
  final ValueNotifier<TextEditingController> commentTextController =
      ValueNotifier(TextEditingController());
  @override
  dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return thePostsOfHomePage(bodyHeight: 700);
  }

  Widget thePostsOfHomePage({required double bodyHeight}) {
    return Container(
      width: double.infinity,
      color: isThatMobile ? null : ColorManager.white,
      child: ValueListenableBuilder(
        valueListenable: widget.postInfo,
        builder: (context, Post postInfoValue, child) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            CustomPostDisplay(
              postInfo: widget.postInfo,
              postsInfo: widget.postsInfo,
              indexOfPost: widget.indexOfPost,
              playTheVideo: widget.playTheVideo,
              reLoadData: widget.reLoadData,
              textController: commentTextController,
              removeThisPost: widget.removeThisPost,
              selectedCommentInfo: ValueNotifier(null),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  if (postInfoValue.comments.isNotEmpty) ...[
                    numberOfComment(postInfoValue),
                    const SizedBox(height: 8),
                  ],
                  if (isThatMobile) ...[
                    buildCommentBox(bodyHeight),
                    buildPublishingDate(postInfoValue, context),
                  ] else ...[
                    buildPublishingDate(postInfoValue, context),
                    const Divider(),
                    buildCommentBox(bodyHeight),
                  ],
                ]),
          ],
        ),
      ),
    );
  }

  Padding buildPublishingDate(Post postInfoValue, BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 11.5, top: 5.0),
      child: Text(
        DateOfNow.chattingDateOfNow(
            postInfoValue.datePublished, postInfoValue.datePublished),
        style: FlutterFlowTheme.of(context).bodyText2,
      ),
    );
  }

  void _showAddCommentModal() {
    if (isThatMobile) {
      double media = MediaQuery.of(context).viewInsets.bottom;
      print(MediaQuery.of(context).viewInsets.bottom);
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            child: Padding(
              padding: EdgeInsets.only(bottom: media+MediaQuery.of(context).viewInsets.bottom+10),
              child: ValueListenableBuilder(
                valueListenable: commentTextController,
                builder: (context, TextEditingController textValue, child) =>
                    CommentBox(
                  isThatCommentScreen: false,
                  postInfo: widget.postInfo,
                  textController: textValue,
                  selectedCommentInfo: ValueNotifier(null),
                  userPersonalInfo: widget.postInfo.value.publisherInfo!,
                  currentFocus: ValueNotifier(FocusScopeNode()),
                  makeSelectedCommentNullable: makeSelectedCommentNullable,
                ),
              ),
            ),
          );
        },
      );
    }
  }

  makeSelectedCommentNullable(bool isThatComment) {
    widget.postInfo.value.comments.add(" ");
    commentTextController.value.text = '';
    Navigator.maybePop(context);
  }

  Widget buildCommentBox(double bodyHeight) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 11.5),
      child: GestureDetector(
        onTap: _showAddCommentModal,
        child: ValueListenableBuilder(
          valueListenable: commentTextController,
          builder: (context, TextEditingController textValue, child) => Row(
            crossAxisAlignment: textValue.text.length < 70
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.end,
            children: [
              CircleAvatarOfProfileImage(
                userInfo: widget.postInfo.value.publisherInfo!,
                bodyHeight: bodyHeight * .5,
              ),
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: TextField(
                  style: FlutterFlowTheme.of(context).bodyText1,
                  controller: commentTextController.value,
                  cursorColor: ColorManager.teal,
                  decoration: InputDecoration(
                    hintText: FFLocalizations.of(context).getText(StringsManager.addComment),
                    hintStyle: FlutterFlowTheme.of(context).bodyText1,
                    fillColor: ColorManager.black,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  enabled: !isThatMobile,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              if (isThatMobile) ...[
               /* GestureDetector(
                  onTap: () {
                    commentTextController.value.text += '❤';
                    _showAddCommentModal();
                  },
                  child: const Text('❤'),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    commentTextController.value.text += '🙌';
                    _showAddCommentModal();
                  },
                  child: const Text('🙌'),
                ),*/
                const SizedBox(width: 8),
              ] else ...[
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8.0),
                  child: InkWell(
                    onTap: () {
                      if (commentTextController.value.text.isNotEmpty) {
                        postTheComment(widget.postInfo.value.publisherInfo!);
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
      ),
    );
  }

  Future<void> postTheComment(UserPersonalInfo userInfo) async {
    final whitespaceRE = RegExp(r"\s+");
    String textWithOneSpaces =
        commentTextController.value.text.replaceAll(whitespaceRE, " ");

    CommentsInfoCubit commentsInfoCubit =
        BlocProvider.of<CommentsInfoCubit>(context);
    await commentsInfoCubit.addComment(
        commentInfo: newCommentInfo(userInfo, textWithOneSpaces));
    makeSelectedCommentNullable(true);
    if (!mounted) return;

    await PostCubit.get(context)
        .updatePostInfo(postInfo: widget.postInfo.value);
    if (!mounted) return;

    BlocProvider.of<NotificationCubit>(context).createNotification(
        newNotification: createNotification(textWithOneSpaces, userInfo));

    /// To rebuild number of comments
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

  Widget numberOfComment(Post postInfo) {
    int commentsLength = postInfo.comments.length;
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 11.5),
      child: GestureDetector(
        onTap: () {
          if (isThatMobile) {
            pushToPage(context,
                page: CommentsPageForMobile(postInfo: widget.postInfo));
          } else {
            Navigator.of(
              context,
            ).push(HeroDialogRoute(
              builder: (context) => ImageOfPost(
                postInfo:
                    ValueNotifier(widget.postsInfo.value[widget.indexOfPost]),
                playTheVideo: widget.playTheVideo,
                indexOfPost: widget.indexOfPost,
                postsInfo: widget.postsInfo,
                removeThisPost: widget.removeThisPost,
                reLoadData: widget.reLoadData,
                selectedCommentInfo: ValueNotifier(null),
                textController: commentTextController,
              ),
            ));
          }
        },
        child: Text(
          "$commentsLength ${commentsLength > 1 ? FFLocalizations.of(context).getText(StringsManager.comments) : FFLocalizations.of(context).getText(StringsManager.comment)}",
          style: FlutterFlowTheme.of(context).bodyText2,
        ),
      ),
    );
  }
}
