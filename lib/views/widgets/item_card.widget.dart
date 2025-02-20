import 'package:fc_social_fitness/constants/app_colors.constant.dart';
import 'package:flutter/material.dart';

import '../../utils/flutter_flow_theme.util.dart';

class ItemCard extends StatelessWidget {
  const ItemCard(
      {super.key,
      required this.title,
      required this.color,
      required this.rightWidget,
      required this.onTap,
      required this.textStyle});

  final Color color;
  final TextStyle textStyle;
  final String title;
  final Widget rightWidget;

  //final Function callback;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Text(
                  title,
                  style: FlutterFlowTheme.of(context).bodyText1,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 24),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(40)),
              child: rightWidget,
            )
          ],
        ),
      ),
    );
  }
}
