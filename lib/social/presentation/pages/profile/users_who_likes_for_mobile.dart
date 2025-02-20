import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/presentation/pages/profile/users_who_likes.dart';

import '../../../../utils/flutter_flow_theme.util.dart';
import '../../../../utils/internationalization.util.dart';

class UsersWhoLikesForMobile extends StatelessWidget {
  final List<dynamic> usersIds;
  final bool showSearchBar;
  final bool isThatMyPersonalId;

  const UsersWhoLikesForMobile({
    Key? key,
    required this.showSearchBar,
    required this.usersIds,
    required this.isThatMyPersonalId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: isThatMobile ? buildAppBar(context) : null,
        body: UsersWhoLikes(
          usersIds: usersIds,
          showSearchBar: showSearchBar,
          isThatMyPersonalId: isThatMyPersonalId,
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      title: Text(FFLocalizations.of(context).getText(StringsManager.likes),
          style: FlutterFlowTheme.of(context).bodyText1,
    ));
  }
}
