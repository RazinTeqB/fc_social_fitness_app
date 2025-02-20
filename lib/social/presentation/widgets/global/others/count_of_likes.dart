import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/config/routes/app_routes.dart';
import 'package:fc_social_fitness/social/config/routes/customRoutes/hero_dialog_route.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/presentation/pages/profile/users_who_likes_for_mobile.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';
import '../../../../../utils/internationalization.util.dart';

class CountOfLikes extends StatelessWidget {
  final Post postInfo;

  const CountOfLikes({Key? key, required this.postInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int likes = postInfo.likes.length;

    return InkWell(
      onTap: () {
        pushToPage(context,
            page: UsersWhoLikesForMobile(
              showSearchBar: true,
              usersIds: postInfo.likes,
              isThatMyPersonalId: postInfo.publisherId == myPersonalId,
            ));
      },
      child: Text(
          '$likes ${likes > 1 ? FFLocalizations.of(context).getText(StringsManager.likes) : FFLocalizations.of(context).getText(StringsManager.like)}',
          textAlign: TextAlign.left,
          style: FlutterFlowTheme.of(context).bodyText1),
    );
  }
}
