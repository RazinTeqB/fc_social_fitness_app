import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fc_social_fitness/social/core/resources/assets_manager.dart';
import 'package:fc_social_fitness/social/presentation/pages/activity/activity_for_mobile.dart';

class ActivityForWeb extends StatelessWidget {
  const ActivityForWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Widget>(
      elevation: 20,
      color: Theme.of(context).splashColor,
      offset: const Offset(90, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: SvgPicture.asset(
        IconsAssets.add2Icon,
        color: Theme.of(context).focusColor,
        height: 700,
        width: 500,
      ),
      itemBuilder: (context) => [
        const PopupMenuItem<Widget>(
          child: ActivityPage(),
        ),
      ],
    );
  }
}
