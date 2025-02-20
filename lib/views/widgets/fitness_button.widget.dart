import 'package:fc_social_fitness/constants/app_colors.constant.dart';
import 'package:flutter/material.dart';

import '../../utils/flutter_flow_theme.util.dart';

class FitnessButton extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final Function() onTap;

  FitnessButton(
      {required this.title, this.isEnabled = true, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: isEnabled ? FlutterFlowTheme.of(context).secondaryColor : FlutterFlowTheme.of(context).disabled,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onTap,
          child: Center(
            child: Text(
              title,
              style: FlutterFlowTheme.of(context).bodyText1,
            ),
          ),
        ),
      ),
    );
  }
}

class FitnessButtonTwo extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final Function() onTap;

  FitnessButtonTwo(
      {required this.title, this.isEnabled = true, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: isEnabled ? FlutterFlowTheme.of(context).course20 : AppColor.disabledColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Center(
            child: Text(
              title,
              style: FlutterFlowTheme.of(context).bodyText1.merge(TextStyle(color: FlutterFlowTheme.of(context).white)),
            ),
          ),
        ),
      ),
    );
  }
}
