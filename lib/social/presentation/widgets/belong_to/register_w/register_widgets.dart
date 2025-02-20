import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fc_social_fitness/social/core/resources/assets_manager.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/resources/styles_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/presentation/pages/register/sign_up_page.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/register_w/or_text.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_text_field.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';
import '../../../../../utils/internationalization.util.dart';

class RegisterWidgets extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? fullNameController;
  final Widget customTextButton;
  final bool isThatLogIn;
  final ValueNotifier<bool> validateEmail;
  final ValueNotifier<bool> validatePassword;
  final ValueNotifier<bool>? rememberPassword;

  const RegisterWidgets({
    Key? key,
    required this.emailController,
    this.isThatLogIn = true,
    required this.passwordController,
    required this.customTextButton,
    this.fullNameController,
    this.rememberPassword,
    required this.validateEmail,
    required this.validatePassword,
  }) : super(key: key);

  @override
  State<RegisterWidgets> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<RegisterWidgets> {
  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
    double height = MediaQuery.of(context).size.height - 50;
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: isThatMobile
              ? buildColumn(context, height: height)
              : buildForWeb(context),
        )),
      ),
    );
  }

  SizedBox buildForWeb(BuildContext context) {
    return SizedBox(
      width: 352,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.2),
            ),
            child: buildColumn(context),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.2),
            ),
            child: haveAccountRow(context),
          ),
        ],
      ),
    );
  }

  Widget buildColumn(BuildContext context, {double height = 400}) {
    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.isThatLogIn) const Spacer(),
          SvgPicture.asset(
            IconsAssets.instagramLogo,
            color: Theme.of(context).focusColor,
            height: 50,
          ),
          const SizedBox(height: 30),
          CustomTextField(
            hint: FFLocalizations.of(context).getText(StringsManager.email),
            controller: widget.emailController,
            isThatEmail: true,
            validate: widget.validateEmail,
          ),
          SizedBox(height: isThatMobile ? 15 : 6.5),
          if (!widget.isThatLogIn && widget.fullNameController != null) ...[
            CustomTextField(
                hint: FFLocalizations.of(context).getText(StringsManager.fullName),
                controller: widget.fullNameController!),
            SizedBox(height: isThatMobile ? 15 : 6.5),
          ],
          CustomTextField(
            hint: FFLocalizations.of(context).getText(StringsManager.password),
            controller: widget.passwordController,
            isThatEmail: false,
            validate: widget.validatePassword,
          ),
          if (!widget.isThatLogIn) ...[
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isThatMobile ? 4 : 0,
                    vertical: isThatMobile ? 15 : 10),
                child: Row(
                  children: [
                    const SizedBox(width: 13),
                    ValueListenableBuilder(
                      valueListenable: widget.rememberPassword!,
                      builder: (context, bool rememberPasswordValue, child) =>
                          Checkbox(
                              value: rememberPasswordValue,
                              activeColor: isThatMobile
                                  ? ColorManager.white
                                  : ColorManager.blue,
                              fillColor: isThatMobile
                                  ? MaterialStateProperty.resolveWith(
                                      (Set states) {
                                      if (states
                                          .contains(MaterialState.disabled)) {
                                        return Colors.blue.withOpacity(.32);
                                      }
                                      return Colors.blue;
                                    })
                                  : null,
                              onChanged: (value) => widget.rememberPassword!
                                  .value = !rememberPasswordValue),
                    ),
                    Text(
                      FFLocalizations.of(context).getText(StringsManager.rememberPassword),
                      style:FlutterFlowTheme.of(context).bodyText1,
                    )
                  ],
                ),
              ),
            ),
          ],
          widget.customTextButton,
          const SizedBox(height: 15),
          if (!widget.isThatLogIn) ...[
            const Spacer(),
            const Spacer(),
          ],
          if (isThatMobile) ...[
            const SizedBox(height: 8),
            if (!widget.isThatLogIn) ...[
              const Divider(color: ColorManager.lightGrey, height: 1),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, left: 15.0, right: 15.0, bottom: 6.5),
                child: haveAccountRow(context),
              ),
            ] else ...[
              haveAccountRow(context),
              const OrText(),
            ],
          ],
          if (widget.isThatLogIn) ...[
            TextButton(
              onPressed: () {},
              child: Text(
                FFLocalizations.of(context).getText(StringsManager.loginWithFacebook),
                style: FlutterFlowTheme.of(context).bodyText1,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Row haveAccountRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.isThatLogIn
              ? FFLocalizations.of(context).getText(StringsManager.noAccount)
              : FFLocalizations.of(context).getText(StringsManager.haveAccount),
          style:
          FlutterFlowTheme.of(context).bodyText1,
        ),
        const SizedBox(width: 4),
        register(context),
      ],
    );
  }

  InkWell register(BuildContext context) {
    return InkWell(
        onTap: () {
          if (widget.isThatLogIn) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const SignUpPage(),
              ),
            );
          } else {
            Navigator.pop(context);
          }
        },
        child: registerText());
  }

  Text registerText() {
    return Text(
      widget.isThatLogIn ? FFLocalizations.of(context).getText(StringsManager.signUp) : FFLocalizations.of(context).getText(StringsManager.logIn),
      style: FlutterFlowTheme.of(context).bodyText1,
    );
  }
}
