import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  const ResponsiveLayout({
    Key? key,
    required this.mobileScreenLayout,
    required this.webScreenLayout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isThatMobile ? mobileScreenLayout : webScreenLayout;
  }
}
