import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fc_social_fitness/social/core/resources/assets_manager.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';
import '../../../../../utils/internationalization.util.dart';

class AllCatchUpIcon extends StatelessWidget {
  const AllCatchUpIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double size = 60;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          child: SizedBox(
            width: size * 1.2,
            height: size * 1.2,
            child: SvgPicture.asset(
              IconsAssets.noMoreData,
              height: size,
              color: ColorManager.white,
            ),
          ),
          shaderCallback: (Rect bounds) {
            Rect rect = const Rect.fromLTRB(0, 0, size, size);
            return const LinearGradient(
              colors: <Color>[
                ColorManager.purple,
                ColorManager.purple,
                ColorManager.purple,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ).createShader(rect);
          },
        ),
        const SizedBox(height: 10),
        Text('Non ci sono altri post per oggi!',
            style: FlutterFlowTheme.of(context).bodyText1),
      ],
    );
  }
}
