import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///currently, I don't use routes methods because there is a lot of run time errors.
/// I use normal Navigator because i don't know how to make Get.to without root.
Future pushToPage(
  BuildContext context, {
  required Widget page,
  bool withoutRoot = true,
  bool withoutPageTransition = false,
}) async {
    PageRoute route = withoutPageTransition
        ? MaterialPageRoute(
            builder: (context) => page, maintainState: !withoutRoot)
        : CupertinoPageRoute(
            builder: (context) => page, maintainState: !withoutRoot);
    return Navigator.of(context, rootNavigator: withoutRoot).push(route);

}
