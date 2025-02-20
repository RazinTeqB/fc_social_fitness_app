import 'package:fc_social_fitness/utils/flutter_flow_icon_button.dart';
import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';

class CustomCircularProgress extends StatelessWidget {
  final Color color;

  const CustomCircularProgress(this.color, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: Transform.scale(
        scale: 0.50,
        child: ClipOval(
          child: isThatAndroid
              ? CircularProgressIndicator(
                  strokeWidth: 6,
                  color: color,
                )
              : CupertinoActivityIndicator(color: color),
        ),
      ),
    );
  }
}

class ThineCircularProgress extends StatelessWidget {
  final Color? color;
  const ThineCircularProgress({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isThatAndroid
          ? CircularProgressIndicator(
              strokeWidth: 1, color: color ?? FlutterFlowTheme.of(context).primaryText)
          : CupertinoActivityIndicator(
              color: color ?? FlutterFlowTheme.of(context).primaryText),
    );
  }
}
