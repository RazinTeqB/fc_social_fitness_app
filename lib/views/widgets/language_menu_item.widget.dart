import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:flutter/material.dart';


class LanguageMenuItem extends StatefulWidget {
  LanguageMenuItem({
    Key? key,
    required this.iconData,
    required this.suffix,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final Function() onPressed;
  final IconData iconData;
  final Widget suffix;
  final String title;
  @override
  _LanguageMenuItemState createState() => _LanguageMenuItemState();
}

class _LanguageMenuItemState extends State<LanguageMenuItem> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(0),
      ),
      onPressed: widget.onPressed,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          0,
          20,
          0,
          20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child:  widget.suffix,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 8,
              child: Text(
                widget.title,
                style:FlutterFlowTheme.of(context).bodyText1,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Icon(
                widget.iconData,
                size: 18,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}