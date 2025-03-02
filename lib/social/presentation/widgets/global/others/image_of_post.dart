import 'package:fc_social_fitness/utils/internationalization.util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fc_social_fitness/social/config/routes/app_routes.dart';
import 'package:fc_social_fitness/social/config/routes/customRoutes/hero_dialog_route.dart';
import 'package:fc_social_fitness/social/core/functions/date_of_now.dart';
import 'package:fc_social_fitness/social/core/resources/assets_manager.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/resources/styles_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/notification.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/domain/entities/notification_check.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/follow/follow_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/notification/notification_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/postLikes/post_likes_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:fc_social_fitness/social/presentation/pages/comments/comments_for_mobile.dart';
import 'package:fc_social_fitness/social/presentation/pages/time_line/my_own_time_line/update_post_info.dart';
import 'package:fc_social_fitness/social/presentation/pages/video/play_this_video.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/comments_w/comment_box.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/comments_w/comment_of_post.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/profile_w/which_profile_page.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/profile_w/bottom_sheet.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/time_line_w/image_slider.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/time_line_w/points_scroll_bar.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/aimation/like_popup_animation.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/circle_avatar_image/circle_avatar_name.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/others/count_of_likes.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/others/share_button.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/popup_widgets/common/jump_arrow.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/popup_widgets/common/volume_icon.dart';

import '../../../../../constants/app_sizes.constant.dart';
import '../../../../../utils/flutter_flow_theme.util.dart';

// ignore: must_be_immutable
class ImageOfPost extends StatefulWidget {
  final ValueNotifier<Post> postInfo;
  bool playTheVideo;
  final VoidCallback? reLoadData;
  final int indexOfPost;
  final ValueNotifier<List<Post>> postsInfo;
  final VoidCallback? rebuildPreviousWidget;

  final bool showSliderArrow;
  final ValueNotifier<TextEditingController> textController;
  final ValueNotifier<Comment?> selectedCommentInfo;
  final ValueChanged<int>? removeThisPost;

  ImageOfPost({
    Key? key,
    this.reLoadData,
    required this.postInfo,
    required this.textController,
    required this.selectedCommentInfo,
    this.showSliderArrow = false,
    required this.playTheVideo,
    this.rebuildPreviousWidget,
    required this.indexOfPost,
    required this.postsInfo,
    this.removeThisPost,
  }) : super(key: key);

  @override
  State<ImageOfPost> createState() => _ImageOfPostState();
}

class _ImageOfPostState extends State<ImageOfPost>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<TextEditingController> commentTextController =
      ValueNotifier(TextEditingController());
  ValueChanged<Post>? selectedPostInfo;

  ValueNotifier<bool> isSaved = ValueNotifier(false);
  ValueNotifier<int> initPosition = ValueNotifier(0);
  bool showCommentBox = false;
  bool isSoundOn = true;
  bool isLiked = false;
  bool isHeartAnimation = false;
  late UserPersonalInfo myPersonalInfo;
  TransformationController controller = TransformationController();
  late AnimationController animationController;
  Animation<Matrix4>? animation;
  OverlayEntry? entry;

  @override
  void initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )
      ..addListener(() => controller.value = animation!.value)
      ..addStatusListener((status) {
        entry?.remove();
        entry = null;
      });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildPostForMobile(bodyHeight: 700);
  }

  pushToProfilePage(Post postInfo) {
    return pushToPage(context,
        page: WhichProfilePage(userId: postInfo.publisherId));
  }

  Widget buildPostForMobile({required double bodyHeight}) {
    return SizedBox(
      width: double.infinity,
      child: buildNormalPostDisplay(bodyHeight),
    );
  }

  ValueListenableBuilder<Post> buildNormalPostDisplay(double bodyHeight) {
    return ValueListenableBuilder(
      valueListenable: widget.postInfo,
      builder: (context, Post postInfoValue, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
            child: buildPublisherInfo(bodyHeight, postInfoValue),
          ),
          SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: imageOfPost(postInfoValue),
          ),
          Padding(
            padding:
                const EdgeInsetsDirectional.only(start: 8, top: 10, bottom: 8),
            child: buildPostInteraction(postInfoValue, showScrollBar: true),
          ),
        ],
      ),
    );
  }

  List<Widget> likesAndCommentBox(Post postInfoValue) {
    double withOfScreen = MediaQuery.of(context).size.width;
    bool minimumWidth = withOfScreen > 800;
    return [
      if (postInfoValue.likes.isNotEmpty)
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 10),
          child: CountOfLikes(postInfo: postInfoValue),
        ),
      Padding(
        padding: const EdgeInsetsDirectional.all(10),
        child: Text(
          DateOfNow.chattingDateOfNow(
              postInfoValue.datePublished, postInfoValue.datePublished),
          style: FlutterFlowTheme.of(context).bodyText1,
        ),
      ),
      if (showCommentBox || minimumWidth)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: CommentBox(
            postInfo: widget.postInfo,
            selectedCommentInfo: widget.selectedCommentInfo,
            textController: widget.textController.value,
            userPersonalInfo: myPersonalInfo,
            expandCommentBox: true,
            currentFocus: ValueNotifier(FocusScopeNode()),
            makeSelectedCommentNullable: makeSelectedCommentNullable,
          ),
        ),
    ];
  }

  Row buildPostInteraction(Post postInfoValue, {bool showScrollBar = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        loveButton(postInfoValue),
        const SizedBox(width: 5),
        commentButton(context, postInfoValue),
        ShareButton(postInfo: ValueNotifier(postInfoValue)),
        const Spacer(),
        if (postInfoValue.imagesUrls.length > 1 && showScrollBar)
          scrollBar(postInfoValue),
        const Spacer(),
        const Spacer(),
        //saveButton(),
      ],
    );
  }

  Row buildPublisherInfo(double bodyHeight, Post postInfoValue,
      {bool makeCircleAvatarBigger = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatarOfProfileImage(
          bodyHeight:
              makeCircleAvatarBigger ? bodyHeight * .6 : bodyHeight * .5,
          userInfo: postInfoValue.publisherInfo!,
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () => pushToProfilePage(postInfoValue),
          child:
              NameOfCircleAvatar(postInfoValue.publisherInfo!.userName, false),
        ),
        const Spacer(),
        widget.postInfo.value.publisherId == myPersonalId
            ?
        GestureDetector(
          onTap: (){
            showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              shape: AppSizes.containerTopRadiusShape(),
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              builder: (BuildContext bc) {
                return SafeArea(
                  bottom: true,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 15,
                        right: 15,
                        left: 15,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: ordersOfMyPost(),
                  ),
                );
              },
            );
          },
          child: Icon(FontAwesomeIcons.xmark),
        ):Container()
      ],
    );
  }

  Widget buildPostForWeb({required double bodyHeight}) {
    return GestureDetector(
      onTap: () {
        showCommentBox = false;
        Navigator.of(context).maybePop();
      },
      child: Scaffold(
        backgroundColor: ColorManager.black38,
        body: GestureDetector(
          /// Don't remove this,it's for avoid pop when tap in popup post
          onTap: () {},
          child: Stack(
            alignment: Alignment.center,
            children: [
              buildPopupContainer(bodyHeight),
              closeButton(),
              if (widget.showSliderArrow) ...[
                if (widget.indexOfPost != 0) buildJumpArrow(),
                if (widget.indexOfPost < widget.postsInfo.value.length - 1)
                  buildJumpArrow(isThatBack: false),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildJumpArrow({bool isThatBack = true}) {
    return GestureDetector(
      onTap: () async {
        int index =
            isThatBack ? widget.indexOfPost - 1 : widget.indexOfPost + 1;
        await Navigator.of(context).maybePop();
        if (!mounted) return;
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => ImageOfPost(
              postInfo: ValueNotifier(widget.postsInfo.value[index]),
              playTheVideo: widget.playTheVideo,
              indexOfPost: index,
              postsInfo: widget.postsInfo,
              rebuildPreviousWidget: widget.rebuildPreviousWidget,
              reLoadData: widget.reLoadData,
              removeThisPost: widget.removeThisPost,
              showSliderArrow: true,
              selectedCommentInfo: widget.selectedCommentInfo,
              textController: ValueNotifier(TextEditingController()),
            ),
          ),
        );
      },
      child: ArrowJump(isThatBack: isThatBack, makeArrowBigger: true),
    );
  }

  Padding buildPopupContainer(double bodyHeight) {
    double withOfScreen = MediaQuery.of(context).size.width;
    bool minimumWidth = withOfScreen > 800;
    Post postInfoValue = widget.postInfo.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80.0),
      child: Center(
        child: !minimumWidth
            ? Container(
                width: 300,
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorManager.white),
                child: buildNormalPostDisplay(bodyHeight))
            : SizedBox(
                height: withOfScreen / 2,
                width: minimumWidth ? 1270 : 800,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() =>
                                widget.playTheVideo = !widget.playTheVideo);
                          });
                        },
                        child: imageOfPost(widget.postInfo.value),
                      ),
                    ),
                    Container(
                      height: withOfScreen / 2,
                      width: 500,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        color: ColorManager.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: ColorManager.black38, width: 0.08),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: buildPublisherInfo(
                                bodyHeight,
                                postInfoValue,
                                makeCircleAvatarBigger: true,
                              ),
                            ),
                          ),
                          CommentsOfPost(
                            postInfo: widget.postInfo,
                            selectedCommentInfo: widget.selectedCommentInfo,
                            textController: widget.textController,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color: ColorManager.black38, width: 0.08),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 10, top: 10, bottom: 8),
                              child: buildPostInteraction(postInfoValue),
                            ),
                          ),
                          ...likesAndCommentBox(postInfoValue),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Padding closeButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          showCommentBox = false;
          Navigator.of(context).maybePop();
        },
        child: const Align(
          alignment: Alignment.topRight,
          child: Icon(
            Icons.close_rounded,
            size: 26,
            color: ColorManager.white,
          ),
        ),
      ),
    );
  }

  makeSelectedCommentNullable(bool isThatComment) {
    setState(() {
      widget.selectedCommentInfo.value = null;
      widget.textController.value.text = '';
    });
  }

  SizedBox buildSizedBox() => SizedBox(
        width: double.infinity,
        height: 50,
        child: Text("Yes", style: getNormalStyle(color: ColorManager.black)),
      );

  Widget loveButton(Post postInfo) {
    bool isLiked = postInfo.likes.contains(myPersonalId);
    return GestureDetector(
      onTap: () async {
        setState(() {
          if (isLiked) {
            BlocProvider.of<PostLikesCubit>(context).removeTheLikeOnThisPost(
                postId: postInfo.postUid, userId: myPersonalId);
            postInfo.likes.remove(myPersonalId);
            if (widget.rebuildPreviousWidget != null) {
              widget.rebuildPreviousWidget!();
            }

            BlocProvider.of<NotificationCubit>(context).deleteNotification(
                notificationCheck: createNotificationCheck(postInfo));
          } else {
            BlocProvider.of<PostLikesCubit>(context).putLikeOnThisPost(
                postId: postInfo.postUid, userId: myPersonalId);
            postInfo.likes.add(myPersonalId);
            if (widget.rebuildPreviousWidget != null) {
              widget.rebuildPreviousWidget!();
            }

            BlocProvider.of<NotificationCubit>(context).createNotification(
                newNotification: createNotification(postInfo));
          }
        });
      },
      child: !isLiked
          ? Icon(
              Icons.favorite_border,
              color: FlutterFlowTheme.of(context).primaryText,
            )
          : const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
    );
  }

  NotificationCheck createNotificationCheck(Post postInfo) {
    return NotificationCheck(
      senderId: myPersonalId,
      receiverId: postInfo.publisherId,
      postId: postInfo.postUid,
    );
  }

  CustomNotification createNotification(Post postInfo) {
    return CustomNotification(
      text: FFLocalizations.of(context).getText(StringsManager.likedAPhoto),
      postId: postInfo.postUid,
      postImageUrl: postInfo.imagesUrls.length > 1
          ? postInfo.imagesUrls[0]
          : postInfo.postUrl,
      time: DateOfNow.dateOfNow(),
      senderId: myPersonalId,
      receiverId: postInfo.publisherId,
      personalUserName: myPersonalInfo.userName,
      personalProfileImageUrl: myPersonalInfo.profileImageUrl,
      senderName: myPersonalInfo.userName,
    );
  }

  ValueListenableBuilder<int> scrollBar(Post postInfoValue) {
    return ValueListenableBuilder(
      valueListenable: initPosition,
      builder: (context, int positionValue, child) => PointsScrollBar(
        photoCount: postInfoValue.imagesUrls.length,
        activePhotoIndex: positionValue,
      ),
    );
  }

  SvgPicture iconsOfImagePost(String path, {bool lowHeight = false}) {
    return SvgPicture.asset(
      path,
      color: FlutterFlowTheme.of(context).primaryText,
      height: lowHeight ? 22 : 28,
    );
  }

  Widget imageOfPost(Post postInfo) {
    bool isLiked = postInfo.likes.contains(myPersonalId);
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (!postInfo.isThatImage) {
                  widget.playTheVideo = !widget.playTheVideo;
                }
              });
            },
            onDoubleTap: () {
              setState(() {
                isHeartAnimation = true;
                this.isLiked = true;
                if (!isLiked) {
                  BlocProvider.of<PostLikesCubit>(context).putLikeOnThisPost(
                      postId: postInfo.postUid, userId: myPersonalId);
                  postInfo.likes.add(myPersonalId);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsetsDirectional.only(top: 8.0),
              child: postInfo.imagesUrls.length > 1
                  ? ImagesSlider(
                      aspectRatio: postInfo.aspectRatio,
                      imagesUrls: postInfo.imagesUrls,
                      updateImageIndex: _updateImageIndex,
                      showPointsScrollBar: false,
                    )
                  : (postInfo.isThatImage
                      ? buildSingleImage(postInfo)
                      : videoPlayer(postInfo)),
            ),
          ),
        ),
        GestureDetector(
            onTap: () {
              setState(() {
                if (!postInfo.isThatImage) {
                  widget.playTheVideo = !widget.playTheVideo;
                }
              });
            },
            onDoubleTap: () {
              setState(() {
                isHeartAnimation = true;
                this.isLiked = true;
                if (!isLiked) {
                  BlocProvider.of<PostLikesCubit>(context).putLikeOnThisPost(
                      postId: postInfo.postUid, userId: myPersonalId);
                  postInfo.likes.add(myPersonalId);
                }
              });
            },
            child: Opacity(
              opacity: isHeartAnimation ? 1 : 0,
              child: LikePopupAnimation(
                isAnimating: isHeartAnimation,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.favorite,
                    color: ColorManager.white, size: 100),
                onEnd: () => setState(() => isHeartAnimation = false),
              ),
            )),
      ],
    );
  }

  Stack videoPlayer(Post postInfo) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PlayThisVideo(
          videoUrl: postInfo.postUrl,
          coverOfVideoUrl: postInfo.coverOfVideoUrl,
          play: widget.playTheVideo,
          withoutSound: !isSoundOn,
        ),
        if (!widget.playTheVideo)
          Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.play_arrow_rounded,
              color: ColorManager.white,
              size: isThatMobile ? 100 : 200,
            ),
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () => setState(() => isSoundOn = !isSoundOn),
              child: VolumeIcon(isVolumeOn: isSoundOn),
            ),
          ),
        )
      ],
    );
  }

  Builder buildSingleImage(Post postInfo) {
    return Builder(builder: (context) {
      return InteractiveViewer(
        transformationController: controller,
        panEnabled: false,
        clipBehavior: Clip.none,
        minScale: 1,
        maxScale: 4,
        onInteractionStart: (details) {
          if (details.pointerCount < 2) return;
          makeImageUnbounded(context, postInfo);
        },
        onInteractionEnd: (details) => resetAnimation(),
        child: NetworkDisplay(
          aspectRatio: postInfo.aspectRatio,
          url: postInfo.postUrl,
          isThatImage: postInfo.isThatImage,
        ),
      );
    });
  }

  void makeImageUnbounded(BuildContext context, Post postInfo) {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = MediaQuery.of(context).size;
    entry = OverlayEntry(
      builder: (context) => Positioned(
          left: offset.dx,
          top: offset.dy,
          width: size.width,
          child: buildSingleImage(postInfo)),
    );
    final overlay = Overlay.of(context);
    overlay.insert(entry!);
  }

  void resetAnimation() {
    animation = Matrix4Tween(
      begin: controller.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutQuart));
    animationController.forward(from: 0);
  }

  void _updateImageIndex(int index, _) {
    initPosition.value = index;
  }

  Future<void> bottomSheet() async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomBottomSheet(
          headIcon: ShareButton(
            postInfo: widget.postInfo,
            shareWidget: shareWidget(),
          ),
          bodyText: widget.postInfo.value.publisherId == myPersonalId
              ? ordersOfMyPost()
              : ordersOfOtherUser(),
        );
      },
    );
  }

  Column shareWidget() {
    return Column(
      children: [
        SvgPicture.asset(
          IconsAssets.shareCircle,
          height: 50,
          color: FlutterFlowTheme.of(context).primaryText,
        ),
        const SizedBox(height: 10),
        buildText(FFLocalizations.of(context).getText(StringsManager.share)),
      ],
    );
  }

  Widget ordersOfMyPost() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: ValueListenableBuilder(
        valueListenable: widget.postInfo,
        builder: (context, Post postInfoValue, child) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            deletePost(postInfoValue),
            editPost(postInfoValue),
            Container(height: 10)
          ],
        ),
      ),
    );
  }

  BlocBuilder<PostCubit, PostState> deletePost(Post postInfoValue) {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      return GestureDetector(
          onTap: () async {
            Navigator.of(context).maybePop();
            await PostCubit.get(context)
                .deletePostInfo(postInfo: postInfoValue);
            if (widget.reLoadData != null) widget.reLoadData!();
            if (widget.removeThisPost != null) {
              widget.removeThisPost!(widget.indexOfPost);
            }
          },
          child: textOfOrders(
              FFLocalizations.of(context).getText(StringsManager.delete)));
    });
  }

  BlocBuilder<PostCubit, PostState> editPost(Post postInfoValue) {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      return GestureDetector(
          onTap: () async {
            Navigator.maybePop(context);
            await pushToPage(context,
                page: UpdatePostInfo(oldPostInfo: postInfoValue));
          },
          child: textOfOrders(
              FFLocalizations.of(context).getText(StringsManager.edit)));
    });
  }

  Widget ordersOfOtherUser() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [hideButton(), unFollowButton(), const SizedBox(height: 10)],
      ),
    );
  }

  Builder unFollowButton() {
    return Builder(builder: (context) {
      FollowCubit followCubit = BlocProvider.of<FollowCubit>(context);
      UserPersonalInfo myPersonalInfo =
          UserInfoCubit.getMyPersonalInfo(context);
      List iFollowThem = myPersonalInfo.followedPeople;
      return ValueListenableBuilder(
        valueListenable: widget.postInfo,
        builder: (context, Post postInfoValue, child) => GestureDetector(
            onTap: () async {
              await Navigator.of(context).maybePop();
              await followCubit.unFollowThisUser(
                  followingUserId: widget.postInfo.value.publisherId,
                  myPersonalId: myPersonalId);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  if (widget.reLoadData != null) widget.reLoadData!();
                  if (widget.removeThisPost != null) {
                    widget.removeThisPost!(widget.indexOfPost);
                  }
                });
              });
            },
            child: textOfOrders(iFollowThem.contains(postInfoValue.publisherId)
                ? FFLocalizations.of(context).getText(StringsManager.unfollow)
                : FFLocalizations.of(context).getText(StringsManager.follow))),
      );
    });
  }

  GestureDetector hideButton() {
    return GestureDetector(
        child: textOfOrders(
            FFLocalizations.of(context).getText(StringsManager.hide)));
  }

  Widget textOfOrders(String text) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          buildText(text),
        ],
      ),
    );
  }

  Widget buildText(String text) {
    return Text(text,
        style:FlutterFlowTheme.of(context).bodyText1);
  }

  ValueListenableBuilder<bool> saveButton() {
    return ValueListenableBuilder(
      valueListenable: isSaved,
      builder: (context, bool isSavedValue, child) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 12.0),
        child: GestureDetector(
          child: isSavedValue
              ? Icon(
                  Icons.bookmark_border,
                  color: Theme.of(context).focusColor,
                )
              : Icon(
                  Icons.bookmark,
                  color: Theme.of(context).focusColor,
                ),
          onTap: () {
            isSaved.value = !isSaved.value;
          },
        ),
      ),
    );
  }

  Padding commentButton(BuildContext context, Post postInfoValue) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 5),
      child: GestureDetector(
        child: iconsOfImagePost(IconsAssets.commentIcon),
        onTap: () {
          if (isThatMobile) {
            pushToPage(context,
                page: CommentsPageForMobile(postInfo: widget.postInfo));
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() => widget.playTheVideo = true);
            });

            Navigator.of(context).push(
              HeroDialogRoute(
                builder: (context) => ImageOfPost(
                  postInfo: widget.postInfo,
                  playTheVideo: true,
                  indexOfPost: widget.indexOfPost,
                  postsInfo: widget.postsInfo,
                  removeThisPost: widget.removeThisPost,
                  rebuildPreviousWidget: widget.rebuildPreviousWidget,
                  reLoadData: widget.reLoadData,
                  selectedCommentInfo: widget.selectedCommentInfo,
                  textController: widget.textController,
                ),
              ),
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() => widget.playTheVideo = true);
            });
          }
        },
      ),
    );
  }
}
