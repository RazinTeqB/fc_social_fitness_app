import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fc_social_fitness/social/core/resources/assets_manager.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/presentation/pages/video/play_this_video.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/time_line_w/animated_dialog.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/config/routes/app_routes.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/postLikes/post_likes_cubit.dart';
import 'package:fc_social_fitness/social/presentation/pages/comments/comments_for_mobile.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/profile_w/which_profile_page.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/time_line_w/send_to_users.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/aimation/fade_animation.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_app_bar.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_posts_display.dart';

import '../../../../../../utils/flutter_flow_theme.util.dart';
import '../../../../../../utils/internationalization.util.dart';
import '../../../../../../utils/sliding_sheet/src/sheet.dart';
import '../../../../../../utils/sliding_sheet/src/specs.dart';

class _PositionDimension {
  final double positionTop;
  final double positionBottom;
  final double positionLeft;
  final double positionRight;
  final double positionCenter;

  _PositionDimension({
    required this.positionTop,
    required this.positionBottom,
    required this.positionLeft,
    required this.positionRight,
    required this.positionCenter,
  });
}

// ignore: must_be_immutable
class PopupPostCard extends StatefulWidget {
  Post postClickedInfo;
  Widget postClickedWidget;
  final List<Post> postsInfo;
  final bool isThatProfile;

  PopupPostCard({
    Key? key,
    required this.postClickedInfo,
    required this.postClickedWidget,
    required this.postsInfo,
    required this.isThatProfile,
  }) : super(key: key);

  @override
  State<PopupPostCard> createState() => _PopupPostCardState();
}

class _PopupPostCardState extends State<PopupPostCard> {
  OverlayEntry? _popupDialog;
  OverlayEntry? _popupEmptyDialog;
  GlobalKey loveKey = GlobalKey();
  GlobalKey viewProfileKey = GlobalKey();
  GlobalKey shareKey = GlobalKey();
  GlobalKey menuKey = GlobalKey();

  final TextEditingController _bottomSheetMessageTextController =
      TextEditingController();
  final TextEditingController _bottomSheetSearchTextController =
      TextEditingController();

  ValueNotifier<bool> messageVisibility = ValueNotifier(false);
  ValueNotifier<bool> loveVisibility = ValueNotifier(false);
  ValueNotifier<bool> viewProfileVisibility = ValueNotifier(false);
  ValueNotifier<bool> shareVisibility = ValueNotifier(false);
  ValueNotifier<bool> menuVisibility = ValueNotifier(false);

  final ValueNotifier<Widget> loveStatusAnimation =
      ValueNotifier(const SizedBox());

  bool isLiked = false;
  ValueNotifier<bool> isHeartAnimation = ValueNotifier(false);

  double widgetPositionLeft = 0;
  String messageText = "";

  @override
  void initState() {
    isLiked = widget.postClickedInfo.likes.contains(myPersonalId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapPost,
      onLongPressMoveUpdate: onLongPressMoveUpdate,
      onLongPress: onLongPressPost,
      onLongPressEnd: onLongPressEnd,
      child: widget.postClickedWidget,
    );
  }

  void onTapPost() {
    List<Post> customPostsInfo = widget.postsInfo;
    customPostsInfo.removeWhere(
        (value) => value.postUid == widget.postClickedInfo.postUid);
    customPostsInfo.insert(0, widget.postClickedInfo);
    Scaffold page = Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: isThatMobile
          ? CustomAppBar.oneTitleAppBar(
              context,
              widget.isThatProfile
                  ? FFLocalizations.of(context).getText(StringsManager.posts)
                  : FFLocalizations.of(context).getText(StringsManager.explore))
          : null,
      body: CustomPostsDisplay(postsInfo: widget.postsInfo),
    );
    pushToPage(context, page: page, withoutRoot: false);
  }

  void onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    _PositionDimension lovePosition = _getOffset(loveKey);
    _PositionDimension commentPosition = _getOffset(viewProfileKey);
    _PositionDimension sharePosition = _getOffset(shareKey);
    _PositionDimension menuPosition = _getOffset(menuKey);

    setState(() {
      if (details.globalPosition.dy > lovePosition.positionTop &&
          details.globalPosition.dy < lovePosition.positionBottom &&
          details.globalPosition.dx > lovePosition.positionLeft &&
          details.globalPosition.dx < lovePosition.positionRight) {
        messageText =
            isLiked ? FFLocalizations.of(context).getText(StringsManager.unLike) : FFLocalizations.of(context).getText(StringsManager.like);
        widgetPositionLeft = lovePosition.positionLeft -
            lovePosition.positionCenter -
            (isLiked ? 15 : 7);
        loveVisibility.value = true;
        messageVisibility.value = true;
      } else if (details.globalPosition.dy > commentPosition.positionTop &&
          details.globalPosition.dy < commentPosition.positionBottom &&
          details.globalPosition.dx > commentPosition.positionLeft &&
          details.globalPosition.dx < commentPosition.positionRight) {
        messageText = widget.isThatProfile
            ? FFLocalizations.of(context).getText(StringsManager.comment)
            : FFLocalizations.of(context).getText(StringsManager.viewProfile);
        widgetPositionLeft =
            commentPosition.positionLeft - commentPosition.positionCenter - 30;
        viewProfileVisibility.value = true;
        messageVisibility.value = true;
      } else if (details.globalPosition.dy > sharePosition.positionTop &&
          details.globalPosition.dy < sharePosition.positionBottom &&
          details.globalPosition.dx > sharePosition.positionLeft &&
          details.globalPosition.dx < sharePosition.positionRight) {
        messageText = FFLocalizations.of(context).getText(StringsManager.share);
        widgetPositionLeft =
            sharePosition.positionLeft - sharePosition.positionCenter - 12;
        shareVisibility.value = true;
        messageVisibility.value = true;
      } else if (details.globalPosition.dy > menuPosition.positionTop &&
          details.globalPosition.dy < menuPosition.positionBottom &&
          details.globalPosition.dx > menuPosition.positionLeft &&
          details.globalPosition.dx < menuPosition.positionRight) {
        messageText = FFLocalizations.of(context).getText(StringsManager.menu);
        widgetPositionLeft =
            menuPosition.positionLeft - menuPosition.positionCenter - 15;
        menuVisibility.value = true;
        messageVisibility.value = true;
      } else {
        messageText = "";
        widgetPositionLeft = 0;
        loveVisibility.value = false;
        viewProfileVisibility.value = false;
        shareVisibility.value = false;
        menuVisibility.value = false;
        messageVisibility.value = false;
      }
    });

    _popupEmptyDialog = _createPopupEmptyDialog();
    Overlay.of(context)!.insert(_popupEmptyDialog!);
  }

  onLongPressPost() {
    loveStatusAnimation.value = const SizedBox();
    _popupDialog = _createPopupDialog(widget.postClickedInfo);
    Overlay.of(context)!.insert(_popupDialog!);
    _popupEmptyDialog = _createPopupEmptyDialog();
    Overlay.of(context)!.insert(_popupEmptyDialog!);
  }

  void onLongPressEnd(LongPressEndDetails details) async {
    if (loveVisibility.value) {
      if (isLiked) {
        setState(() {
          BlocProvider.of<PostLikesCubit>(context).removeTheLikeOnThisPost(
              postId: widget.postClickedInfo.postUid, userId: myPersonalId);
          widget.postClickedInfo.likes.remove(myPersonalId);
          isLiked = false;
        });
      } else {
        setState(() {
          loveStatusAnimation.value = const FadeAnimation(
              child:
                  Icon(Icons.favorite, color: ColorManager.white, size: 100));

          BlocProvider.of<PostLikesCubit>(context).putLikeOnThisPost(
              postId: widget.postClickedInfo.postUid, userId: myPersonalId);
          widget.postClickedInfo.likes.add(myPersonalId);
          isHeartAnimation.value = true;
        });
      }
      await Future.delayed(const Duration(seconds: 1));
      isHeartAnimation.value = false;
    }
    if (viewProfileVisibility.value) {
      Widget page;
      if (widget.isThatProfile) {
        page = CommentsPageForMobile(
            postInfo: ValueNotifier(widget.postClickedInfo));
      } else {
        page = WhichProfilePage(
          userId: widget.postClickedInfo.publisherId,
        );
      }
      if (!mounted) return;

      pushToPage(context, page: page, withoutRoot: false);
    }
    if (shareVisibility.value) draggableBottomSheet();

    setState(() {
      messageVisibility.value = false;
      _popupDialog?.remove();
      _popupEmptyDialog?.remove();
    });
  }

  Future<void> draggableBottomSheet() async {
    return showSlidingBottomSheet<void>(
      context,
      builder: (BuildContext context) => SlidingSheetDialog(
        cornerRadius: 16,
        color: FlutterFlowTheme.of(context).course20,
        snapSpec: const SnapSpec(
          initialSnap: 1,
          snappings: [.4, 1, .7],
        ),
        builder: buildSheet,
        headerBuilder: (context, state) => Material(
          child: upperWidgets(context),
        ),
      ),
    );
  }

  Column upperWidgets(BuildContext context) {
    String postImageUrl = widget.postClickedInfo.imagesUrls.length > 1
        ? widget.postClickedInfo.imagesUrls[0]
        : widget.postClickedInfo.postUrl;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 10),
          child: Container(
            width: 45,
            height: 4.5,
            decoration: BoxDecoration(
              color: Theme.of(context).textTheme.headlineMedium!.color,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                width: 50,
                height: 45,
                decoration: BoxDecoration(
                  color: ColorManager.grey,
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(postImageUrl,
                        maxWidth: 100, maxHeight: 90),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: TextField(
                controller: _bottomSheetMessageTextController,
                cursorColor: ColorManager.teal,
                decoration: InputDecoration(
                  hintText: FFLocalizations.of(context).getText(StringsManager.writeMessage),
                  hintStyle:FlutterFlowTheme.of(context).bodyText2,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        Padding(
          padding:
              const EdgeInsetsDirectional.only(top: 30.0, end: 20, start: 20),
          child: Container(
            width: double.infinity,
            height: 35,
            decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              cursorColor: ColorManager.teal,
              style: FlutterFlowTheme.of(context).bodyText1,
              controller: _bottomSheetSearchTextController,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20,
                    color: ColorManager.lowOpacityGrey,
                  ),
                  contentPadding: const EdgeInsetsDirectional.all(12),
                  hintText: FFLocalizations.of(context).getText(StringsManager.search),
                  hintStyle: FlutterFlowTheme.of(context).title1,
                  border: InputBorder.none),
              onChanged: (_) => setState(() {}),
            ),
          ),
        )
      ],
    );
  }

  clearTextsController(bool clearText) {
    setState(() {
      if (clearText) {
        _bottomSheetMessageTextController.clear();
        _bottomSheetSearchTextController.clear();
      }
    });
  }

  Widget buildSheet(context, state) => Material(
        child: SendToUsers(
          publisherInfo: widget.postClickedInfo.publisherInfo!,
          messageTextController: _bottomSheetMessageTextController,
          postInfo: widget.postClickedInfo,
          clearTexts: clearTextsController,
          selectedUsersInfo: ValueNotifier<List<UserPersonalInfo>>([]),
        ),
      );

  _PositionDimension _getOffset(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    Offset position = box?.localToGlobal(Offset.zero) ?? const Offset(0, 0);
    Size widgetSize = key.currentContext?.size ?? Size.zero;
    double widgetWidth = widgetSize.width;
    _PositionDimension positionDimension = _PositionDimension(
      positionTop: position.dy,
      positionBottom: position.dy + 50,
      positionLeft: position.dx,
      positionRight: position.dx + 50,
      positionCenter: widgetWidth / 2,
    );

    return positionDimension;
  }

  OverlayEntry _createPopupDialog(Post postInfo) {
    return OverlayEntry(
      builder: (context) => _buildSafeArea(),
    );
  }

  OverlayEntry _createPopupEmptyDialog() {
    return OverlayEntry(
      builder: (context) => const SizedBox(),
    );
  }

  SafeArea _buildSafeArea() {
    return SafeArea(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 20),
        child: AnimatedDialog(
          child: _createPopupContent(widget.postClickedInfo),
        ),
      ),
    );
  }

  Widget _createPopupContent(Post postInfo) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _createPhotoTitle(postInfo),
              Stack(
                alignment: Alignment.center,
                children: [
                  postInfo.isThatImage
                      ? Container(
                          color: FlutterFlowTheme.of(context).course20,
                          width: double.infinity,
                          child: NetworkDisplay(
                            url: postInfo.postUrl.isNotEmpty
                                ? postInfo.postUrl
                                : postInfo.imagesUrls[0],
                            isThatImage: postInfo.isThatImage,
                            aspectRatio: postInfo.aspectRatio,
                          ),
                        )
                      : Container(
                          color: FlutterFlowTheme.of(context).course20,
                          width: double.infinity,
                          height: screenSize.height - 200,
                          child: PlayThisVideo(
                            videoUrl: postInfo.postUrl,
                            coverOfVideoUrl: postInfo.coverOfVideoUrl,
                            play: true,
                          ),
                        ),
                  popupMessage(),
                  loveAnimation()
                ],
              ),
              _createActionBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget loveAnimation() {
    return ValueListenableBuilder(
      valueListenable: loveStatusAnimation,
      builder: (context, value, child) =>
          Center(child: loveStatusAnimation.value),
    );
  }

  Widget popupMessage() {
    return _PopupMessageDialog(
      visible: messageVisibility.value,
      message: messageText,
      widgetPositionLeft: widgetPositionLeft,
    );
  }

  Widget _createPhotoTitle(Post postInfo) => Container(
        padding: const EdgeInsetsDirectional.only(
            bottom: 5, top: 5, end: 10, start: 10),
        height: 55,
        width: double.infinity,
        color: Theme.of(context).splashColor,
        child: Row(
          children: [
            CircleAvatarOfProfileImage(
              userInfo: postInfo.publisherInfo!,
              bodyHeight: 370,
            ),
            const SizedBox(width: 7),
            Text(postInfo.publisherInfo!.name,
                style: FlutterFlowTheme.of(context).title1),
          ],
        ),
      );

  Widget _createActionBar() {
    isLiked = widget.postClickedInfo.likes.contains(myPersonalId);
    return Container(
      height: 50,
      padding: const EdgeInsetsDirectional.only(bottom: 5, top: 5),
      color: Theme.of(context).splashColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            key: loveKey,
            child: isLiked
                ? const Icon(
                    Icons.favorite,
                    size: 28,
                    color: Colors.red,
                  )
                : Icon(
                    Icons.favorite_border,
                    size: 28,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
          ),
          SizedBox(
            key: viewProfileKey,
            child: SvgPicture.asset(
              widget.isThatProfile
                  ? IconsAssets.commentIcon
                  : IconsAssets.profileIcon,
              height: 28,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          SizedBox(
            key: shareKey,
            child: SvgPicture.asset(
              IconsAssets.send1Icon,
              height: 23,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          SizedBox(
            key: menuKey,
            child: SvgPicture.asset(
              IconsAssets.menuHorizontalIcon,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _PopupMessageDialog extends StatelessWidget {
  final String message;
  final bool visible;
  final double widgetPositionLeft;
  const _PopupMessageDialog({
    Key? key,
    required this.message,
    required this.visible,
    required this.widgetPositionLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Positioned(
        bottom: 20,
        left: widgetPositionLeft,
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.black87,
            borderRadius: BorderRadius.circular(2),
          ),
          padding: const EdgeInsetsDirectional.only(
              end: 10, start: 10, top: 5, bottom: 5),
          child: Text(
            message,
            style: const TextStyle(
              color: ColorManager.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
