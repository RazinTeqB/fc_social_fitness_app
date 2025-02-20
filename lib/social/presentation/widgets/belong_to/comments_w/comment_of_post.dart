import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/core/functions/date_of_now.dart';
import 'package:fc_social_fitness/social/core/functions/toast_show.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/resources/styles_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/core/utility/injector.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/commentsInfo/cubit/comments_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/commentsInfo/cubit/repliesInfo/reply_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/comments_w/comment_box.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/comments_w/commentator.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_post_display.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';
import '../../../../../utils/internationalization.util.dart';

class CommentsOfPost extends StatefulWidget {
  final ValueNotifier<Comment?> selectedCommentInfo;
  final ValueNotifier<TextEditingController> textController;

  final ValueNotifier<Post> postInfo;
  final bool showImage;

  const CommentsOfPost({
    Key? key,
    required this.selectedCommentInfo,
    required this.textController,
    required this.postInfo,
    this.showImage = false,
  }) : super(key: key);

  @override
  State<CommentsOfPost> createState() => _CommentsOfPostState();
}

class _CommentsOfPostState extends State<CommentsOfPost> {
  Map<int, bool> showMeReplies = {};
  List<Comment> allComments = [];
  bool addReply = false;
  bool rebuild = false;
  late UserPersonalInfo myPersonalInfo;
  ValueNotifier<FocusNode> currentFocus = ValueNotifier(FocusNode());

  @override
  initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isThatMobile ? buildForMobile() : commentsList();
  }

  Widget buildForMobile() {
    return Column(
      children: [
        commentsList(),
        commentBox(),
      ],
    );
  }

  Widget commentsList() {
    return Expanded(child: Container(color: FlutterFlowTheme.of(context).secondaryBackground, child: blocBuilder()));
  }

  Widget blocBuilder() {
    return BlocBuilder<CommentsInfoCubit, CommentsInfoState>(
      bloc: blocAction(),
      buildWhen: buildBlocWhen,
      builder: (context, state) => buildBloc(context, state),
    );
  }

  CommentsInfoCubit blocAction() => BlocProvider.of<CommentsInfoCubit>(context)
    ..getSpecificComments(postId: widget.postInfo.value.postUid);

  bool buildBlocWhen(CommentsInfoState previous, CommentsInfoState current) =>
      previous != current && current is CubitCommentsInfoLoaded;

  Widget buildBloc(context, state) {
    if (state is CubitCommentsInfoLoaded) {
      return blocLoaded(context, state);
    } else if (state is CubitCommentsInfoFailed) {
      return whenBuildFailed(context, state);
    } else {
      return const ThineCircularProgress();
    }
  }

  Widget blocLoaded(BuildContext context, CubitCommentsInfoLoaded state) {
    state.commentsOfThePost
        .sort((a, b) => b.datePublished.compareTo(a.datePublished));
    allComments = state.commentsOfThePost;
    return commentsListView(allComments);
  }

  Widget whenBuildFailed(BuildContext context, state) {
    ToastShow.toastStateError(state);
    return Text(FFLocalizations.of(context).getText(StringsManager.somethingWrong),
        style: FlutterFlowTheme.of(context).bodyText1);
  }

  selectedComment(Comment commentInfo) {
    setState(() => widget.selectedCommentInfo.value = commentInfo);
  }

  Widget commentsListView(List<Comment> commentsOfThePost) {
    return allComments.isEmpty && !widget.showImage
        ? noCommentText(context)
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showImage) ...[
                    CustomPostDisplay(
                      playTheVideo: true,
                      indexOfPost: 0,
                      postsInfo: ValueNotifier([widget.postInfo.value]),
                      postInfo: widget.postInfo,
                      textController: widget.textController,
                      selectedCommentInfo: widget.selectedCommentInfo,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 11.5, top: 5.0),
                      child: Text(
                        DateOfNow.chattingDateOfNow(
                            widget.postInfo.value.datePublished,
                            widget.postInfo.value.datePublished),
                        style: FlutterFlowTheme.of(context).bodyText1,
                      ),
                    ),
                    const Divider(color: ColorManager.black26),
                  ],
                  allComments.isNotEmpty
                      ? buildComments(commentsOfThePost)
                      : const SizedBox(),
                ],
              ),
            ),
          );
  }

  ListView buildComments(List<Comment> commentsOfThePost) {
    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (!showMeReplies.containsKey(index)) {
          showMeReplies[index] = false;
        }

        return BlocProvider<ReplyInfoCubit>(
          create: (_) => injector<ReplyInfoCubit>(),
          child: CommentInfo(
            commentInfo: commentsOfThePost[index],
            index: index,
            showMeReplies: showMeReplies,
            textController: widget.textController,
            selectedCommentInfo: ValueNotifier(selectedComment),
            myPersonalInfo: myPersonalInfo,
            addReply: addReply,
            rebuildCallback: isScreenRebuild,
            rebuildComment: rebuild,
            postInfo: widget.postInfo,
            currentFocus: currentFocus,
          ),
        );
      },
      itemCount: commentsOfThePost.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
    );
  }

  Widget noCommentText(BuildContext context) {
    return Center(
      child: Text(
        FFLocalizations.of(context).getText(StringsManager.noComments),
        style: FlutterFlowTheme.of(context).bodyText1,
      ),
    );
  }

  Widget commentBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        replyingMention(),
        customDivider(),
        commentTextField(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget replyingMention() {
    if (widget.selectedCommentInfo.value != null) {
      return Container(
        width: double.infinity,
        height: 45,
        color: FlutterFlowTheme.of(context).secondaryBackground,
        child: Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 10.0, end: 17),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                      "${FFLocalizations.of(context).getText(StringsManager.replyingTo)} ${widget.selectedCommentInfo.value!.whoCommentInfo!.userName}",
                      style: FlutterFlowTheme.of(context).bodyText1),
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.selectedCommentInfo.value = null;
                        widget.textController.value.text = '';
                      });
                    },
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: FlutterFlowTheme.of(context).alternate,
                    )),
              ],
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget commentTextField() => CommentBox(
        postInfo: widget.postInfo,
        selectedCommentInfo: widget.selectedCommentInfo,
        textController: widget.textController.value,
        userPersonalInfo: myPersonalInfo,
        currentFocus: currentFocus,
        makeSelectedCommentNullable: makeSelectedCommentNullable,
      );

  void isScreenRebuild(isRebuild) {
    setState(() {
      rebuild = isRebuild;
    });
  }

  makeSelectedCommentNullable(bool isThatComment) {
    setState(() {
      widget.selectedCommentInfo.value = null;
      widget.textController.value.text = '';
      if (!isThatComment) isScreenRebuild(true);
    });
  }

  Container customDivider() => Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      color: ColorManager.grey,
      width: double.infinity,
      height: 0.2);
}
