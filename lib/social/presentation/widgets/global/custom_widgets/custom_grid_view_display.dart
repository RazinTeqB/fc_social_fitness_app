import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/config/routes/customRoutes/hero_dialog_route.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/presentation/pages/video/play_this_video.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/others/image_of_post.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/popup_widgets/mobile/popup_post.dart';

// ignore: must_be_immutable
class CustomGridViewDisplay extends StatefulWidget {
  Post postClickedInfo;
  final List<Post> postsInfo;
  final bool isThatProfile;
  final int index;
  final bool playThisVideo;
  final ValueChanged<int>? removeThisPost;
  CustomGridViewDisplay(
      {required this.index,
      required this.postsInfo,
      this.isThatProfile = true,
      this.playThisVideo = false,
      required this.postClickedInfo,
      this.removeThisPost,
      Key? key})
      : super(key: key);

  @override
  State<CustomGridViewDisplay> createState() => _CustomGridViewDisplayState();
}

class _CustomGridViewDisplayState extends State<CustomGridViewDisplay> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: createGridTileWidget());
  }

  Widget createGridTileWidget() {
    Post postInfo = widget.postClickedInfo;
    bool isThatImage = postInfo.isThatMix || postInfo.isThatImage;
    if (isThatMobile) {
      return PopupPostCard(
        postClickedInfo: postInfo,
        postsInfo: widget.postsInfo,
        isThatProfile: widget.isThatProfile,
        postClickedWidget: isThatImage ? buildCardImage() : buildCardVideo(),
      );
    } else {
      return GestureDetector(
        onTap: onTapPostForWeb,
        onLongPressEnd: (_) => onTapPostForWeb,
        child:
            isThatImage ? buildCardImage() : buildCardVideo(playVideo: false),
      );
    }
  }

  onTapPostForWeb() => Navigator.of(context).push(
        HeroDialogRoute(
          builder: (context) => ImageOfPost(
            postInfo: ValueNotifier(widget.postClickedInfo),
            playTheVideo: widget.playThisVideo,
            indexOfPost: widget.index,
            removeThisPost: widget.removeThisPost,
            postsInfo: ValueNotifier(widget.postsInfo),
            showSliderArrow: true,
            selectedCommentInfo: ValueNotifier(null),
            textController: ValueNotifier(TextEditingController()),
          ),
        ),
      );

  Widget buildCardVideo({bool? playVideo}) {
    return PlayThisVideo(
      videoUrl: widget.postClickedInfo.postUrl,
      coverOfVideoUrl: !widget.isThatProfile && playVideo == null
          ? ""
          : widget.postClickedInfo.coverOfVideoUrl,
      play: playVideo ?? widget.playThisVideo,
      withoutSound: true,
    );
  }

  Stack buildCardImage() {
    bool isThatMultiImages = widget.postClickedInfo.imagesUrls.length > 1;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        NetworkDisplay(
          isThatImage: widget.postClickedInfo.isThatImage,
          url: isThatMultiImages
              ? widget.postClickedInfo.imagesUrls[0]
              : widget.postClickedInfo.postUrl,
        ),
        if (isThatMultiImages)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.collections_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
