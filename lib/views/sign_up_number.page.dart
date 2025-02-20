import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:fc_social_fitness/views/widgets/flutter_flow_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stacked/stacked.dart';
import '../constants/app_routes.dart';
import '../constants/text_constants.dart';
import '../utils/flutter_flow_icon_button.dart';
import '../utils/flutter_flow_theme.util.dart';
import '../utils/internationalization.util.dart';
import '../viewmodels/signup.viewmodel.dart';
import 'package:fc_social_fitness/views/widgets/custom_text_form_field.widget.dart';


class SignUpNumber extends StatefulWidget {
  const SignUpNumber({Key? key}) : super(key: key);

  @override
  State<SignUpNumber> createState() => _SignUpNumberState();
}

class _SignUpNumberState extends State<SignUpNumber> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupViewModel>.reactive(
        viewModelBuilder: () => SignupViewModel(context),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, vm, child) {
          return vm.isBusy
              ? FitnessLoading()
              : GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Scaffold(
                      appBar: AppBar(
                          elevation: 0,
                          leading: GestureDetector(
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 20,
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                            },
                          ),
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          centerTitle: true,
                          title: Text(
                              FFLocalizations.of(context).getText('registrati'),
                              style: FlutterFlowTheme.of(context).title3)),
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
                        stream: vm.validUsername,
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
                            textEditingController: vm.usernameTEC,
                            errorText: snapshot.error,
                            onChanged: vm.validateUsername,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: StreamBuilder<bool>(
                            stream: vm.validEmailAddress,
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
                                    vm.emailAddressTEC,
                                errorText: snapshot.error,
                                onChanged: vm.validateEmailAddress,
                              );
                            })),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: StreamBuilder<bool>(
                        stream: vm.validPassword,
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
                            textEditingController: vm.passwordTEC,
                            errorText: snapshot.error,
                            onChanged: vm.validatePassword,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: StreamBuilder<bool>(
                        stream: vm.validConfirmPassword,
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
                            textEditingController: vm.confirmPasswordTEC,
                            errorText: snapshot.error,
                            onChanged: vm.validateConfirmPassword,
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 40),

                    FFButtonWidget(
                        text: FFLocalizations.of(context).getText('avanti'),
                        onPressed: () {
                          vm.validateFirstStep();
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
              

                      /*SingleChildScrollView(
                      child: vm.isBusy
                          ? const FitnessLoading()
                          : // Generated code for this Column Widget...
                          Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsetsDirectional.only(top: 35),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 0),
                                        child: FlutterFlowIconButton(
                                          borderColor: Colors.transparent,
                                          borderRadius: 30,
                                          borderWidth: 1,
                                          buttonSize: 44,
                                          icon: Icon(
                                            Icons.arrow_back_ios_new,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 20,
                                          ),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      Text(
                                        FFLocalizations.of(context)
                                            .getText('registrati'),
                                        style:
                                            FlutterFlowTheme.of(context).title3,
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text(
                                          FFLocalizations.of(context)
                                              .getText('insertNumber'),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .top,
                                        left: 15,
                                        right: 15),
                                    child: InternationalPhoneNumberInput(
                                      selectorConfig: const SelectorConfig(
                                          selectorType:
                                              PhoneInputSelectorType.DROPDOWN,
                                          showFlags: true,
                                          useEmoji: true,
                                          setSelectorButtonAsPrefixIcon: true),
                                      countries: ["IT", "US", "GB"],
                                      keyboardType: TextInputType.phone,
                                      onInputChanged: (PhoneNumber number) {
                                        vm.phoneNumber = number;
                                      },
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyText2,
                                      autoFocus: true,
                                      textFieldController: vm.phoneNumberTEC,
                                      hintText: FFLocalizations.of(context)
                                          .getText('numero'),
                                      inputDecoration: InputDecoration(
                                        labelText: '',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .bodyText2,
                                        hintText: FFLocalizations.of(context)
                                            .getText('inserisci'),
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyText2,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            width: 0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            width: 0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0x00000000),
                                            width: 0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0x00000000),
                                            width: 0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        contentPadding:
                                            const EdgeInsetsDirectional.all(15),
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 24, 0, 0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      await vm.beginPhoneAuth(
                                        onCodeSent: (String verificationId,
                                            int? resendToken) async {
                                          vm.showCustomBottomSheet(
                                            context,
                                            content: _verifySmsCode(
                                                context, vm, verificationId),
                                          );
                                        },
                                      );
                                    },
                                    text: FFLocalizations.of(context)
                                        .getText('registratiNumero'),
                                    options: FFButtonOptions(
                                      width: 230,
                                      height: 50,
                                      color:
                                          FlutterFlowTheme.of(context).course20,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .merge(
                                              TextStyle(color: Colors.white)),
                                      elevation: 0,
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(TextConstants.alreadyHaveAccount,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1),
                                      SizedBox(width: 5),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.popAndPushNamed(
                                                context, AppRoutes.loginRoute);
                                          },
                                          child: Text(
                                            TextConstants.signIn,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1
                                                .merge(TextStyle(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .course20)),
                                          )),
                                    ])
                              ],
                            ))*/
                      ));
        });
  }

  Widget _verifySmsCode(
    BuildContext context,
    SignupViewModel vm,
    String verificationId,
  ) {
    return // Generated code for this Column Widget...
        Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          child: Text(
            FFLocalizations.of(context).getText('conferma'),
            style: FlutterFlowTheme.of(context).title3,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.all(15),
          child: Text(
            FFLocalizations.of(context).getText('messaggio'),
            textAlign: TextAlign.start,
            style: FlutterFlowTheme.of(context).bodyText2,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 15,vertical: 15),
          child: PinCodeTextField(
            keyboardType: TextInputType.number,
            appContext: context,
            length: 6,
            textStyle: FlutterFlowTheme.of(context).bodyText1,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            enableActiveFill: false,
            autoFocus: true,
            showCursor: true,
            cursorColor: FlutterFlowTheme.of(context).course20,
            obscureText: false,
            hintCharacter: '-',
            pinTheme: PinTheme(
              fieldHeight: 40,
              fieldWidth: 40,
              borderWidth: 1,
              borderRadius: BorderRadius.circular(60),
              shape: PinCodeFieldShape.box,
              activeColor: FlutterFlowTheme.of(context).course20,
              inactiveColor: FlutterFlowTheme.of(context).secondaryBackground,
              selectedColor: FlutterFlowTheme.of(context).secondaryText,
              activeFillColor: FlutterFlowTheme.of(context).course20,
              inactiveFillColor:
                  FlutterFlowTheme.of(context).secondaryBackground,
              selectedFillColor: FlutterFlowTheme.of(context).secondaryText,
            ),
            controller: vm.pinCodeTEC,
            autoDisposeControllers: false,
            onChanged: (_) => {},
          ),
        ),
        SizedBox(height: 15),
        FFButtonWidget(
          text: FFLocalizations.of(context).getText('step'),
          onPressed: () async {
            final smsCodeVal = vm.pinCodeTEC.text;
            if (smsCodeVal == null || smsCodeVal.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    FFLocalizations.of(context).getText('inserisciCodice'),
                  ),
                ),
              );
              return;
            }
            await vm.verifySmsCode(
              smsCode: smsCodeVal,
              verificationId: verificationId,
            );
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
          ),
        ),
        /*Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 30, vertical: 15),
          child: FFButtonWidget(

            text: FFLocalizations.of(context).getText('step'),
            options: FFButtonOptions(
              color: FlutterFlowTheme.of(context).course20,
              textStyle: FlutterFlowTheme.of(context).bodyText1.merge(TextStyle(color: Colors.white)),
              elevation: 0,
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 0,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),*/
        SizedBox(height: 25)
      ],
    );
  }
}
// import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
// import 'package:fc_social_fitness/views/widgets/flutter_flow_widgets.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:stacked/stacked.dart';
// import '../constants/app_routes.dart';
// import '../constants/text_constants.dart';
// import '../utils/flutter_flow_icon_button.dart';
// import '../utils/flutter_flow_theme.util.dart';
// import '../utils/internationalization.util.dart';
// import '../viewmodels/signup.viewmodel.dart';

// class SignUpEmail extends StatefulWidget {
//   const SignUpEmail({Key? key}) : super(key: key);

//   @override
//   State<SignUpEmail> createState() => _SignUpEmailState();
// }

// class _SignUpEmailState extends State<SignUpEmail> {
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<SignupViewModel>.reactive(
//         viewModelBuilder: () => SignupViewModel(context),
//         onViewModelReady: (model) => model.initialise(),
//         builder: (context, vm, child) {
//           return vm.isBusy
//               ? FitnessLoading()
//               : GestureDetector(
//               onTap: () {
//                 FocusManager.instance.primaryFocus?.unfocus();
//               },
//               child: Scaffold(
//                   appBar: AppBar(
//                       elevation: 0,
//                       leading: GestureDetector(
//                         child: Icon(
//                           Icons.arrow_back_ios_new,
//                           color: FlutterFlowTheme.of(context).primaryText,
//                           size: 20,
//                         ),
//                         onTap: () async {
//                           Navigator.pop(context);
//                         },
//                       ),
//                       backgroundColor:
//                       FlutterFlowTheme.of(context).secondaryBackground,
//                       centerTitle: true,
//                       title: Text(
//                           FFLocalizations.of(context).getText('registrati'),
//                           style: FlutterFlowTheme.of(context).title3)),
//                   backgroundColor:
//                   FlutterFlowTheme.of(context).secondaryBackground,
//                   body: vm.isBusy
//                       ? const FitnessLoading()
//                       : SingleChildScrollView(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(15),
//                           child: Text(
//                             FFLocalizations.of(context)
//                                 .getText('insertEmailAndPassword'),
//                             style: FlutterFlowTheme.of(context)
//                                 .bodyText2,
//                           ),
//                         ),
//                         // Campo email
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 15),
//                           child: TextFormField(
//                             controller: vm.emailAddressTEC,
//                             keyboardType: TextInputType.emailAddress,
//                             decoration: InputDecoration(
//                               hintText: FFLocalizations.of(context)
//                                   .getText('email'),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context)
//                                       .primaryBackground,
//                                 ),
//                                 borderRadius:
//                                 BorderRadius.circular(15),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context)
//                                       .secondaryBackground,
//                                 ),
//                                 borderRadius:
//                                 BorderRadius.circular(15),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 15),
//                           child: TextFormField(
//                             controller: vm.usernameTEC,
//                             keyboardType: TextInputType.text,
//                             decoration: InputDecoration(
//                               hintText: FFLocalizations.of(context)
//                                   .getText('username'),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context)
//                                       .primaryBackground,
//                                 ),
//                                 borderRadius:
//                                 BorderRadius.circular(15),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context)
//                                       .secondaryBackground,
//                                 ),
//                                 borderRadius:
//                                 BorderRadius.circular(15),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         // Campo password
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 15),
//                           child: TextFormField(
//                             controller: vm.passwordTEC,
//                             obscureText: true,
//                             decoration: InputDecoration(
//                               hintText: FFLocalizations.of(context)
//                                   .getText('password'),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context)
//                                       .primaryBackground,
//                                 ),
//                                 borderRadius:
//                                 BorderRadius.circular(15),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context)
//                                       .secondaryBackground,
//                                 ),
//                                 borderRadius:
//                                 BorderRadius.circular(15),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         // Campo conferma password
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 15),
//                           child: TextFormField(
//                             controller: vm.confirmPasswordTEC,
//                             obscureText: true,
//                             decoration: InputDecoration(
//                               hintText: FFLocalizations.of(context)
//                                   .getText('confirmPassword'),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context)
//                                       .primaryBackground,
//                                 ),
//                                 borderRadius:
//                                 BorderRadius.circular(15),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: FlutterFlowTheme.of(context)
//                                       .secondaryBackground,
//                                 ),
//                                 borderRadius:
//                                 BorderRadius.circular(15),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding:
//                           const EdgeInsetsDirectional.fromSTEB(
//                               0, 24, 0, 0),
//                           child: FFButtonWidget(
//                             onPressed: () async {
//                               print("Email: ${vm.emailAddressTEC.text}");
// print("Password: ${vm.passwordTEC.text}");
// print("Conferma Password: ${vm.confirmPasswordTEC.text}");
//                                FocusManager.instance.primaryFocus
//                                                 ?.unfocus();
//                                             Navigator.popAndPushNamed(
//                                                 context, AppRoutes.signupStepOneRoute);
//                             },
//                             text: FFLocalizations.of(context)
//                                 .getText('registrati'),
//                             options: FFButtonOptions(
//                               splashColor: Colors.transparent,
//                               width: 230,
//                               height: 50,
//                               color: FlutterFlowTheme.of(context)
//                                   .course20,
//                               textStyle: FlutterFlowTheme.of(context)
//                                   .bodyText1
//                                   .merge(TextStyle(
//                                   color: Colors.white)),
//                               elevation: 0,
//                               borderSide: const BorderSide(
//                                 color: Colors.transparent,
//                                 width: 0,
//                               ),
//                               borderRadius:
//                               BorderRadius.circular(15),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         Row(
//                             mainAxisAlignment:
//                             MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                   TextConstants
//                                       .alreadyHaveAccount,
//                                   style: FlutterFlowTheme.of(context)
//                                       .bodyText1),
//                               SizedBox(width: 5),
//                               GestureDetector(
//                                   onTap: () {
//                                    Navigator.popAndPushNamed(context, AppRoutes.loginRoute);
//                                   },
//                                   child: Text(
//                                     TextConstants.signIn,
//                                     style: FlutterFlowTheme.of(
//                                         context)
//                                         .bodyText1
//                                         .merge(TextStyle(
//                                         color: FlutterFlowTheme.of(
//                                             context)
//                                             .course20)),
//                                   )),
//                             ])
//                       ],
//                     ),
//                   )));
//         });
//   }
// }
