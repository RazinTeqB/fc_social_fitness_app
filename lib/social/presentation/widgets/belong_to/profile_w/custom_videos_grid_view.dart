import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/presentation/pages/video/play_this_video.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/popup_widgets/mobile/popup_post.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';
import '../../../../../utils/internationalization.util.dart';

// ignore: must_be_immutable
class CustomVideosGridView extends StatefulWidget {
  List<Post> postsInfo;
  final String userId;

  CustomVideosGridView(
      {required this.userId, required this.postsInfo, Key? key})
      : super(key: key);

  @override
  State<CustomVideosGridView> createState() => _CustomVideosGridViewState();
}

class _CustomVideosGridViewState extends State<CustomVideosGridView> {
  @override
  Widget build(BuildContext context) {
    bool isWidthAboveMinimum = MediaQuery.of(context).size.width > 800;

    return widget.postsInfo.isNotEmpty
        ? GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              mainAxisExtent: 215,
              crossAxisSpacing: isWidthAboveMinimum ? 30 : 1.5,
              mainAxisSpacing: isWidthAboveMinimum ? 30 : 1.5,
              childAspectRatio: 1.0,
            ),
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsetsDirectional.only(bottom: 1.5, top: 1.5),
            children: widget.postsInfo.map((postInfo) {
              return createGridTileWidget(postInfo);
            }).toList())
        : Center(
            child: Text(
              FFLocalizations.of(context).getText(StringsManager.noPosts),
            style: FlutterFlowTheme.of(context).bodyText1,
          ));
  }

  Widget createGridTileWidget(Post postInfo) => Builder(
        builder: (context) => PopupPostCard(
          postClickedInfo: postInfo,
          postsInfo: widget.postsInfo,
          isThatProfile: true,
          postClickedWidget: PlayThisVideo(
            videoUrl: postInfo.postUrl,
            coverOfVideoUrl: postInfo.coverOfVideoUrl,
            play: false,
          ),
        ),
      );
}
