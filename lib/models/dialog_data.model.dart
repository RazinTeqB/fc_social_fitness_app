import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
enum DialogType {
  normal,
  loading,
  success,
  successThenClosePage,
  failed,
  failedThenClosePage,
  warning,
  closePageAfterDialog,
  redirectPage,
  payment,
}

class DialogData {
  String title;

  String body;

  DialogType dialogType;

  bool repeatAnimation = true;

  bool popAfter = false;

  String negativeButtonTitle;

  String positiveButtonTitle;

  Color backgroundColor;

  IconData iconData;

  bool isDismissible;

  dynamic extraData;

  DialogData({
    this.title = "",
    this.body = "",
    this.dialogType = DialogType.normal,
    this.repeatAnimation = true,
    this.negativeButtonTitle = "Cancel",
    this.positiveButtonTitle = "Ok",
    this.backgroundColor = Colors.blue,
    this.iconData = FontAwesomeIcons.exclamationTriangle,
    this.isDismissible = false,
    this.extraData,
  });
}