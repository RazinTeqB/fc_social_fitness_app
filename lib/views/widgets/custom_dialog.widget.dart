// ignore_for_file: const_initialized_with_non_constant_value, non_constant_identifier_names
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.constant.dart';
import '../../constants/app_sizes.constant.dart';
import '../../constants/app_text_styles.constant.dart';
import '../../models/dialog_data.model.dart';
import '../../utils/flutter_flow_theme.util.dart';

class CustomDialog {
  static dismissDialog(context) {
    try {
      Navigator.of(context, rootNavigator: true).pop();
    } catch (error) {
      rethrow;
    }
  }

  //Show dialog
  static showAlertDialog(
    BuildContext context,
    DialogData dialogData, {
    bool isDismissible = true,
    Function()? onDismissAction,
  }) async {
    Widget alertTitleWidget = Text(
      dialogData.title,
      style: FlutterFlowTheme.of(context).bodyText1,
    );

    Widget alertBodyWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        alertTitleWidget,
        (Platform.isIOS) ? const SizedBox(height: 10) : const SizedBox.shrink(),
        Text(
          dialogData.body,
          style: FlutterFlowTheme.of(context).bodyText1,
        ),
      ],
    );

    StatelessWidget alert;

    // set up the AlertDialog
    if (Platform.isAndroid) {
      alert = AlertDialog(
        content: Container(
          child: alertBodyWidget,
        ),
      );
    } else {
      alert = CupertinoAlertDialog(
        content: alertBodyWidget,
      );
    }

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext context) {
        return alert;
      },
    ).then(
      (val) {
        if (dialogData.dialogType == DialogType.closePageAfterDialog ||
            dialogData.dialogType == DialogType.successThenClosePage ||
            dialogData.popAfter) {
          Navigator.pop(context);
        }
        if (onDismissAction != null) {
          onDismissAction();
        }
      },
    );
  }

  static showCustomMaterialAlertDialog(
    BuildContext context, {
    required Widget content,
    bool isDismissible = false,
  }) {
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          content: content,
        );
      },
    );
  }

  static showConfirmationActionAlertDialog(
    BuildContext context,
    DialogData dialogData, {
    bool isDismissible = true,
    Function()? negativeButtonAction,
    Function()? positiveButtonAction,
  }) {
    Widget alertTitleWidget = Text(
      dialogData.title,
      style: FlutterFlowTheme.of(context).bodyText1,
    );

    //Load animation file base on dialog model type

    Widget alertBodyWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        (Platform.isIOS) ? const SizedBox(height: 10) : const SizedBox.shrink(),
        alertTitleWidget,
        (Platform.isIOS) ? const SizedBox(height: 10) : const SizedBox.shrink(),
        Text(
          dialogData.body,
          style: FlutterFlowTheme.of(context).bodyText1,
        ),
      ],
    );

    // set up the negative action button
    Widget negativeButton = TextButton(
      child: Text(
        dialogData.negativeButtonTitle,
        style: FlutterFlowTheme.of(context).bodyText1,
      ),
      onPressed: negativeButtonAction,
    );

    // set up the positive action button
    Widget positiveButton = TextButton(
      child: Text(
        dialogData.positiveButtonTitle,
        style: FlutterFlowTheme.of(context).bodyText1,
      ),
      onPressed: positiveButtonAction,
    );

    StatelessWidget alert;

    // set up the AlertDialog
    if (Platform.isAndroid) {
      alert = AlertDialog(
        content: alertBodyWidget,
        actions: <Widget>[
          negativeButton,
          positiveButton,
        ],
      );
    } else {
      alert = CupertinoAlertDialog(
        content: alertBodyWidget,
        actions: <Widget>[
          negativeButton,
          positiveButton,
        ],
      );
    }

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //Bottom Sheet
  static showCustomBottomSheet(
    BuildContext context, {
    required Widget content,
    EdgeInsetsGeometry? contentPadding,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: AppSizes.containerTopRadiusShape(),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      builder: (BuildContext bc) {
        return SafeArea(
          bottom: true,
          child: Padding(
            padding: contentPadding ?? const EdgeInsets.all(8.0),
            child: content,
          ),
        );
      },
    );
  }
}
