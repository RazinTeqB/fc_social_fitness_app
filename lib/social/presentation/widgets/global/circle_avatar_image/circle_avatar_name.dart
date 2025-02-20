import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/core/resources/styles_manager.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';

class NameOfCircleAvatar extends StatelessWidget {
  final String circleAvatarName;
  final bool isForStoriesLine;

  const NameOfCircleAvatar(
    this.circleAvatarName,
    this.isForStoriesLine, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: isForStoriesLine ? 0 : 5),
      child: Text(
        circleAvatarName,
        maxLines: 1,
        style: isForStoriesLine
            ? FlutterFlowTheme.of(context).bodyText1
            : FlutterFlowTheme.of(context).bodyText1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }
}
