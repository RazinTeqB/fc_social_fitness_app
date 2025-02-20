import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:fc_social_fitness/views/widgets/flutter_flow_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stacked/stacked.dart';
import '../constants/app_routes.dart';
import '../constants/text_constants.dart';
import '../utils/flutter_flow_theme.util.dart';
import '../utils/internationalization.util.dart';
import '../viewmodels/login.viewmodel.dart';
import 'widgets/custom_text_form_field.widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignInViewModel>.reactive(
        viewModelBuilder: () => SignInViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return WillPopScope(
              onWillPop: () async => false,
              child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: vm.isBusy
                      ? FitnessLoading()
                      : Scaffold(
                          resizeToAvoidBottomInset: true,
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          body: SingleChildScrollView(
                              child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 50),
                                _createHeader(context),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    "Accedi o unisciti a noi",
                                    style: FlutterFlowTheme.of(context).title3,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _createForm(context, vm),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  child: Container(
                                    width: double.infinity,
                                    child: Text(TextConstants.forgotPassword,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1
                                            .merge(TextStyle(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .course20)),
                                        textAlign: TextAlign.right),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        AppRoutes.changeCredentialOtp,
                                        arguments: 0);
                                  },
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _createSignInButton(context, vm),
                                    SizedBox(width: 15),
                                    /*Expanded(
                                        child: FFButtonWidget(
                                            text: FFLocalizations.of(context)
                                                .getText('accedi'),
                                            onPressed: () {
                                              vm.showCustomBottomSheet(
                                                context,
                                                content: _createPhoneAuth(
                                                    context, vm),
                                              );
                                            },
                                            options: FFButtonOptions(
                                              splashColor: Colors.transparent,
                                              height: 50,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .course20,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1
                                                      .merge(TextStyle(
                                                          color: Colors.white)),
                                              elevation: 0,
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ))),*/
                                  ],
                                ),
                                const SizedBox(height: 30),
                                _createDoNotHaveAccountText(context)
                              ],
                            ),
                          )),
                        )));
        });
  }

  Widget _createPhoneAuth(BuildContext context, SignInViewModel vm) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            FFLocalizations.of(context).getText('accedi'),
            style: FlutterFlowTheme.of(context).title3,
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 15),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  FFLocalizations.of(context).getText('inserisci'),
                  style: FlutterFlowTheme.of(context).bodyText2,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
        Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: InternationalPhoneNumberInput(
              selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.DROPDOWN,
                  showFlags: true,
                  useEmoji: true,
                  setSelectorButtonAsPrefixIcon: true),
              countries: ["IT", "US"],
              keyboardType: TextInputType.phone,
              onInputChanged: (PhoneNumber number) {
                vm.phoneNumber = number;
              },
              textStyle: FlutterFlowTheme.of(context).bodyText1,
              autoFocus: true,
              textFieldController: vm.phoneNumberTEC,
              hintText: FFLocalizations.of(context).getText('numero'),
              inputDecoration: InputDecoration(
                labelText: '',
                labelStyle: FlutterFlowTheme.of(context).bodyText1,
                hintText: FFLocalizations.of(context).getText('inserisci'),
                hintStyle: FlutterFlowTheme.of(context).bodyText2,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).primaryBackground,
                contentPadding: EdgeInsets.all(15),
              ),
            )),
        SizedBox(height: 25),
        FFButtonWidget(
            text: FFLocalizations.of(context).getText('accediNumero'),
            onPressed: () async {
              await vm.beginPhoneAuth(
                  onCodeSent: (String verificationId, int? resendToken) async {
                Navigator.pop(context);
                vm.showCustomBottomSheet(
                  context,
                  content: _verifySmsCode(context, vm, verificationId),
                );
              });
            },
            options: FFButtonOptions(
              splashColor: Colors.transparent,
              width: 300,
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
        SizedBox(height: 25),
      ],
    );
  }
}

Widget _verifySmsCode(
  BuildContext context,
  SignInViewModel vm,
  String verificationId,
) {
  return // Generated code for this Column Widget...
      Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          FFLocalizations.of(context).getText('conferma'),
          style: FlutterFlowTheme.of(context).title3,
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
        child: Text(
          FFLocalizations.of(context).getText('messaggio'),
          textAlign: TextAlign.start,
          style: FlutterFlowTheme.of(context).bodyText2,
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 0),
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
          autoDisposeControllers: false,
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
            inactiveFillColor: FlutterFlowTheme.of(context).secondaryBackground,
            selectedFillColor: FlutterFlowTheme.of(context).secondaryText,
          ),
          controller: vm.pinCodeTEC,
          onChanged: (_) => {},
        ),
      ),
      FFButtonWidget(
          text: FFLocalizations.of(context).getText('avanti'),
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
          )),
      SizedBox(height: 20)
    ],
  );
}

Widget _createHeader(BuildContext context) {
  return Container(
      margin: EdgeInsets.all(30),
      height: 200,
      width: 200,
      child: Image.asset(FlutterFlowTheme.of(context).logoColor));
}

Widget _createSignInButton(BuildContext context, SignInViewModel vm) {
  return Expanded(
      child: FFButtonWidget(
          text: FFLocalizations.of(context).getText('login'),
          onPressed: () {
            vm.doLogin();
          },
          options: FFButtonOptions(
            splashColor: Colors.transparent,
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
          )));
}

Widget _createDoNotHaveAccountText(BuildContext context) {
  return Center(
    child: RichText(
      text: TextSpan(
        text: TextConstants.doNotHaveAnAccount,
        style: FlutterFlowTheme.of(context).bodyText1,
        children: [
          TextSpan(
            text: " ${TextConstants.signUp}",
            style: FlutterFlowTheme.of(context)
                .bodyText1
                .merge(TextStyle(color: FlutterFlowTheme.of(context).course20)),
            recognizer: TapGestureRecognizer()
              ..onTap = () =>
                  Navigator.pushNamed(context, AppRoutes.signupNumberRoute),
          ),
        ],
      ),
    ),
  );
}

Widget _createForm(BuildContext context, SignInViewModel vm) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      StreamBuilder<bool>(
        stream: vm.validEmailAddress,
        builder: (context, snapshot) {
          return CustomTextFormField(
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            hintText: FFLocalizations.of(context).getText('email'),
            style: FlutterFlowTheme.of(context).bodyText1,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            textEditingController: vm.emailAddressTEC,
            errorText: snapshot.error,
            onChanged: vm.validateEmailAddress,
          );
        },
      ),
      SizedBox(height: 25),
      StreamBuilder<bool>(
        stream: vm.validPasswordAddress,
        builder: (context, snapshot) {
          return CustomTextFormField(
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            hintText: FFLocalizations.of(context).getText('password'),
            style: TextStyle(color: FlutterFlowTheme.of(context).white),
            togglePassword: true,
            obscureText: true,
            textEditingController: vm.passwordTEC,
            errorText: snapshot.error,
            onChanged: vm.validatePassword,
          );
        },
      ),
    ],
  );
}
