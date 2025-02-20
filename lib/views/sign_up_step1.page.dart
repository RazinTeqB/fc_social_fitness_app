import 'package:fc_social_fitness/views/widgets/custom_text_form_field.widget.dart';
import 'package:fc_social_fitness/views/widgets/fitness_button.widget.dart';
import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:fc_social_fitness/views/widgets/flutter_flow_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../constants/app_routes.dart';
import '../constants/text_constants.dart';
import '../utils/flutter_flow_theme.util.dart';
import '../utils/internationalization.util.dart';
import '../viewmodels/signup.viewmodel.dart';

class SignUpStepOne extends StatefulWidget {
  const SignUpStepOne({Key? key, required this.vm}) : super(key: key);
  final SignupViewModel vm;

  @override
  State<SignUpStepOne> createState() => _SignUpStepOneState();
}

class _SignUpStepOneState extends State<SignUpStepOne> {
  @override
  Widget build(BuildContext context) {
    return widget.vm.isBusy
        ? FitnessLoading()
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor:
                    FlutterFlowTheme.of(context).secondaryBackground,
                body: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),
                    Text(
                      "Registrazione",
                      style: FlutterFlowTheme.of(context).title3,
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Fase 1 di 2",
                      style: FlutterFlowTheme.of(context).bodyText1,
                    ),
                    // const SizedBox(height: 50),

                    SizedBox(height: 100),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: StreamBuilder<bool>(
                        stream: widget.vm.validUsername,
                        builder: (context, snapshot) {
                          return CustomTextFormField(
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            hintText:
                                FFLocalizations.of(context).getText('username'),
                            //prova
                            style: TextStyle(
                                color: FlutterFlowTheme.of(context).white),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            textEditingController: widget.vm.usernameTEC,
                            errorText: snapshot.error,
                            onChanged: widget.vm.validateUsername,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: StreamBuilder<bool>(
                            stream: widget.vm.validEmailAddress,
                            builder: (context, snapshot) {
                              return CustomTextFormField(
                                fillColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                hintText: FFLocalizations.of(context)
                                    .getText('email'),
                                //prova
                                style: TextStyle(
                                    color: FlutterFlowTheme.of(context).white),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                textEditingController:
                                    widget.vm.emailAddressTEC,
                                errorText: snapshot.error,
                                onChanged: widget.vm.validateEmailAddress,
                              );
                            })),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: StreamBuilder<bool>(
                        stream: widget.vm.validPassword,
                        builder: (context, snapshot) {
                          return CustomTextFormField(
                            togglePassword: true,
                            obscureText: true,
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            hintText:
                                FFLocalizations.of(context).getText('password'),
                            style: TextStyle(
                                color: FlutterFlowTheme.of(context).white),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            textEditingController: widget.vm.passwordTEC,
                            errorText: snapshot.error,
                            onChanged: widget.vm.validatePassword,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: StreamBuilder<bool>(
                        stream: widget.vm.validConfirmPassword,
                        builder: (context, snapshot) {
                          return CustomTextFormField(
                            togglePassword: true,
                            obscureText: true,
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            hintText:
                                "${FFLocalizations.of(context).getText('conferma password')}",
                            style: TextStyle(
                                color: FlutterFlowTheme.of(context).white),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            textEditingController: widget.vm.confirmPasswordTEC,
                            errorText: snapshot.error,
                            onChanged: widget.vm.validateConfirmPassword,
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 40),

                    FFButtonWidget(
                        text: FFLocalizations.of(context).getText('avanti'),
                        onPressed: () {
                          widget.vm.validateFirstStep();
                          FocusScope.of(context).unfocus();
                        },
                        options: FFButtonOptions(
                          splashColor: Colors.transparent,
                          width: 230,
                          height: 50,
                          color: FlutterFlowTheme.of(context).course20,
                          textStyle: FlutterFlowTheme.of(context)
                              .bodyText1
                              .merge(TextStyle(color: Colors.white)),
                          elevation: 0,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        )),
                    SizedBox(height: 40),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("${TextConstants.alreadyHaveAccount} ",
                          style: FlutterFlowTheme.of(context).bodyText1),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.loginRoute);
                          },
                          child: Text(TextConstants.signIn,
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .merge(TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .course20))))
                    ])
                  ],
                )),
              ),
            ));
  }
}
