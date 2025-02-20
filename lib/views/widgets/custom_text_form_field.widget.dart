import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../constants/app_sizes.constant.dart';
import '../../constants/app_text_styles.constant.dart';
import '../../utils/flutter_flow_theme.util.dart';

class CustomTextFormField extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  CustomTextFormField({
    Key? key,
    required this.hintText,
    this.border,
    this.filled = true,
    this.isFixedHeight = true,
    this.borderRadius,
    this.padding,
    this.fillColor,
    this.minLines,
    this.maxLines,
    this.textEditingController,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.cursorColor,
    this.textStyle,
    this.labelText,
    this.labelTextStyle,
    this.hintTextStyle,
    this.prefixWidget,
    this.suffixWidget,
    this.togglePassword = false,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.nextFocusNode,
    this.isReadOnly = false,
    this.onTap,
    //IN CASO DI ERRORI ELIMINARE REQUIRED TEXTSTYLE STYLE
    required TextStyle style,
  }) : super(key: key);

  final InputBorder? border;
  final int? minLines;
  final int? maxLines;
  final bool filled;
  final bool isFixedHeight;
  final double? borderRadius;
  final EdgeInsets? padding;
  final Color? fillColor;

  final TextEditingController? textEditingController;
  final bool obscureText;
  final bool togglePassword;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final Color? cursorColor;
  final TextStyle? textStyle;

  final String? labelText;
  final TextStyle? labelTextStyle;

  final String hintText;
  final TextStyle? hintTextStyle;

  final Widget? prefixWidget;
  final Widget? suffixWidget;

  final Function(String)? onChanged;
  final Function(dynamic)? onFieldSubmitted;
  final dynamic errorText;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  final bool isReadOnly;
  final Function()? onTap;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool makePasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: widget.isFixedHeight ? AppSizes.inputHeight : null,
          padding: widget.padding ?? const EdgeInsets.fromLTRB(15, 5, 15, 5),
          decoration: BoxDecoration(
            color:
                widget.fillColor ?? FlutterFlowTheme.of(context).secondaryText,
            borderRadius: BorderRadius.all(
              Radius.circular(widget.borderRadius ?? 15),
            ),
          ),
          child: Row(
            children: <Widget>[
              //show leading widget or empty space if no leading widget was added
              widget.prefixWidget ?? const SizedBox.shrink(),
              //add spacing if there is a leading widget
              (widget.prefixWidget != null)
                  ? const SizedBox(
                      width: 15,
                    )
                  : const SizedBox.shrink(),
              Expanded(
                child: TextFormField(
                  onTap: widget.onTap,
                  readOnly: widget.isReadOnly,
                  controller: widget.textEditingController,
                  focusNode: widget.focusNode,
                  textAlign: TextAlign.start,
                  maxLines: widget.maxLines ?? 1,
                  minLines: widget.minLines ?? 1,
                  onChanged: widget.onChanged,
                  obscureText:
                      (widget.obscureText) ? !makePasswordVisible : false,
                  textInputAction: widget.textInputAction,
                  keyboardType: widget.keyboardType,
                  cursorColor: (widget.cursorColor != null)
                      ? widget.cursorColor
                      : FlutterFlowTheme.of(context).cursorColor,
                  style: (widget.textStyle != null)
                      ? widget.textStyle
                      : FlutterFlowTheme.of(context).bodyText1,
                  validator: widget.validator,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelStyle: widget.labelTextStyle ??
                        FlutterFlowTheme.of(context).bodyText1,
                    hintStyle: widget.hintTextStyle,
                    labelText: widget.labelText,
                    hintText: widget.hintText,
                  ),
                ),
              ),

              //suffix widget
              if (widget.togglePassword)
                ButtonTheme(
                  minWidth: 30,
                  height: 30,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        makePasswordVisible = !makePasswordVisible;
                      });
                    },
                    child: Icon(
                      (!makePasswordVisible)
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                )
              else
                widget.suffixWidget ?? const SizedBox.shrink(),
            ],
          ),
        ),

        // Error text widget
        widget.errorText != null
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.errorText ?? "Errore",
                  style: FlutterFlowTheme.of(context)
                      .bodyText1
                      .merge(TextStyle(fontSize: 12, color: Colors.red)),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
