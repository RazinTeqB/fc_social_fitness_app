import 'package:fc_social_fitness/viewmodels/change_password.viewmodel.dart';
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
import '../utils/flutter_flow_theme.util.dart';
import '../utils/internationalization.util.dart';

class ChangeCredentialOtp extends StatefulWidget {
  const ChangeCredentialOtp({Key? key, required this.page}) : super(key: key);
  final int page;

  @override
  State<ChangeCredentialOtp> createState() => _ChangeCredentialOtpState();
}

class _ChangeCredentialOtpState extends State<ChangeCredentialOtp> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChangePasswordViewModel>.reactive(
        viewModelBuilder: () =>
            ChangePasswordViewModel(context, pageValue: widget.page),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, vm, child) {
          return GestureDetector(
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
                      title: Text("Recupera password",
                          style: FlutterFlowTheme.of(context).title3)),
                  backgroundColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  body: vm.isBusy
                      ? const FitnessLoading()
                      : Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                vm.currentUser == null
                                    ? Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Text(
                                            "Inserisci il numero di cellulare per recuperare la password",
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText2,
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Text(
                                            "jknijojrfiorjof",
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText2,
                                          ),
                                        ),
                                      )
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    bottom:
                                    MediaQuery.of(context).viewInsets.top,
                                    left: 15,
                                    right: 15),
                                child: vm.currentUser == null
                                    ? InternationalPhoneNumberInput(
                                          selectorConfig: SelectorConfig(
                                              selectorType:
                                                  PhoneInputSelectorType
                                                      .DROPDOWN,
                                              showFlags: true,
                                              useEmoji: true,
                                              setSelectorButtonAsPrefixIcon:
                                                  true),
                                          countries: ["IT", "US"],
                                          keyboardType: TextInputType.phone,
                                          onInputChanged: (PhoneNumber number) {
                                            vm.phoneNumber = number;
                                          },
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyText1,
                                          autoFocus: true,
                                          textFieldController:
                                              vm.phoneNumberTEC,
                                          hintText: FFLocalizations.of(context)
                                              .getText('numero'),
                                          inputDecoration: InputDecoration(
                                            labelText: '',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyText1,
                                            hintText:
                                                FFLocalizations.of(context)
                                                    .getText('inserisci'),
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyText2,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                width: 0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryBackground,
                                            contentPadding: EdgeInsets.all(15),
                                          ),
                                        )
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: Text(
                                          vm.currentUser!.phone!,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1,
                                        ))),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 24, 0, 0),
                              child: vm.isBusy?CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0):FFButtonWidget(
                                onPressed: () async {
                                  await vm.beginPhoneAuth(
                                    phoneNumber: vm.phoneNumber.phoneNumber!,
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
                                text: "Recupera password",
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
                            ),
                          ],
                        )));
        });
  }

  Widget _verifySmsCode(
    BuildContext context,
    ChangePasswordViewModel vm,
    String verificationId,
  ) {
    return // Generated code for this Column Widget...
        Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
          child: vm.isBusy?CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0):Text(
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
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 15,vertical: 10),
          child: PinCodeTextField(
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
        SizedBox(height: 10),
        GestureDetector(
          child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: FlutterFlowTheme.of(context).course20),
              child: vm.isBusy
                  ? CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.0)
                  : Text(FFLocalizations.of(context).getText('step'),
                      style: FlutterFlowTheme.of(context)
                          .bodyText1
                          .merge(TextStyle(color: Colors.white)))),
          onTap: () async {
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
