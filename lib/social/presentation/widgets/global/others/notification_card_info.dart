import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/config/routes/app_routes.dart';
import 'package:fc_social_fitness/social/config/routes/customRoutes/hero_dialog_route.dart';
import 'package:fc_social_fitness/social/core/functions/date_of_now.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/resources/styles_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/notification.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/profile_w/which_profile_page.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/get_post_info.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';
import '../../../../../utils/internationalization.util.dart';

class NotificationCardInfo extends StatefulWidget {
  final CustomNotification notificationInfo;
  const NotificationCardInfo({Key? key, required this.notificationInfo})
      : super(key: key);

  @override
  State<NotificationCardInfo> createState() => _NotificationCardInfoState();
}

class _NotificationCardInfoState extends State<NotificationCardInfo> {
  late String profileImage;

  @override
  void initState() {
    profileImage = widget.notificationInfo.personalProfileImageUrl;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (profileImage.isNotEmpty) {
      precacheImage(NetworkImage(profileImage), context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String reformatDate =
        DateOfNow.commentsDateOfNow(widget.notificationInfo.time);
    List<String> hashOfUserName = hashUserName(widget.notificationInfo.text);
    return InkWell(
      onTap: () async {
        await pushToPage(context,
            page: WhichProfilePage(userId: widget.notificationInfo.senderId),
            withoutRoot: false);
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
            start: 15, top: 15, end: 15, bottom: !isThatMobile ? 5 : 0),
        child: Row(children: [
          CircleAvatar(
            backgroundColor: ColorManager.customGrey,
            backgroundImage: profileImage.isNotEmpty
                ? CachedNetworkImageProvider(profileImage,
                    maxWidth: 165, maxHeight: 165)
                : null,
            radius: 25,
            child: profileImage.isEmpty
                ? Icon(
                    Icons.person,
                    color: FlutterFlowTheme.of(context).course20,
                    size: 25,
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "${widget.notificationInfo.personalUserName} ",
                    style: FlutterFlowTheme.of(context).bodyText1,
                  ),
                  if (hashOfUserName.isNotEmpty) ...[
                    TextSpan(
                      text: "${hashOfUserName[0]} ",
                      style: FlutterFlowTheme.of(context).bodyText1,
                    ),
                    TextSpan(
                      text: "${hashOfUserName[1]} ",
                      style: FlutterFlowTheme.of(context).bodyText1,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          String userName =
                              hashOfUserName[1].replaceAll('@', '');
                          await pushToPage(context,
                              page: WhichProfilePage(userName: userName));
                        },
                    ),
                    TextSpan(
                      text: "${hashOfUserName[2]} ",
                      style: FlutterFlowTheme.of(context).bodyText1,
                    ),
                  ] else ...[
                    TextSpan(
                      text: "${widget.notificationInfo.text} ",
                      style: FlutterFlowTheme.of(context).bodyText1,
                    ),
                  ],
                  TextSpan(
                    text: reformatDate,
                    style: FlutterFlowTheme.of(context).bodyText1,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (widget.notificationInfo.isThatPost &&
              widget.notificationInfo.postImageUrl.isNotEmpty)
            GestureDetector(
              onTap: () {
                String appBarText;
                if (widget.notificationInfo.isThatPost &&
                    widget.notificationInfo.isThatLike) {
                  appBarText = FFLocalizations.of(context).getText(StringsManager.post);
                } else {
                  appBarText = FFLocalizations.of(context).getText(StringsManager.comments);
                }
                if (isThatMobile) {
                  pushToPage(context,
                      page: GetsPostInfoAndDisplay(
                        postId: widget.notificationInfo.postId,
                        appBarText: appBarText,
                      ),
                      withoutRoot: false);
                } else {
                  Navigator.of(context).push(HeroDialogRoute(
                    builder: (context) => GetsPostInfoAndDisplay(
                      postId: widget.notificationInfo.postId,
                      appBarText: appBarText,
                      fromHeroRoute: true,
                    ),
                  ));
                }
              },
              child: Image.network(widget.notificationInfo.postImageUrl,
                  height: 45, width: 45),
            ),
        ]),
      ),
    );
  }

  List<String> hashUserName(String text) {
    List<String> splitText = text.split(":");
    if (splitText.length > 1 && splitText[1][1] == "@") {
      List<String> hashName = splitText[1].split(" ");
      if (hashName.isNotEmpty) {
        return ["${splitText[0]}:", hashName[1], hashName[2]];
      }
    }
    return [];
  }
}
