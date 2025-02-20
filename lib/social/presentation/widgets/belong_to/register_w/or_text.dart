import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/resources/styles_manager.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';
import '../../../../../utils/internationalization.util.dart';

class OrText extends StatelessWidget {
  const OrText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Divider(
          indent: 30,
          endIndent: 20,
          thickness: 0.2,
          color: ColorManager.grey,
        )),
        Text(
          FFLocalizations.of(context).getText(StringsManager.or),
          style: FlutterFlowTheme.of(context).bodyText1,
        ),
        const Expanded(
            child: Divider(
          indent: 20,
          endIndent: 30,
          thickness: 0.2,
          color: ColorManager.grey,
        )),
      ],
    );
  }
}
