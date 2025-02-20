import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:readmore/readmore.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';
import '../../../../../utils/internationalization.util.dart';

class ReadMore extends StatelessWidget {
  final String text;
  final int timeLines;
  const ReadMore(this.text, this.timeLines, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      text,
      trimLines: timeLines,
      colorClickableText: ColorManager.grey,
      trimMode: TrimMode.Line,
      trimCollapsedText: FFLocalizations.of(context).getText(StringsManager.more),
      trimExpandedText: FFLocalizations.of(context).getText(StringsManager.less),
      style: FlutterFlowTheme.of(context).bodyText1,
      moreStyle: FlutterFlowTheme.of(context).bodyText1,
    );
  }
}
