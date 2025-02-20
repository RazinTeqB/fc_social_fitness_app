import 'package:fc_social_fitness/constants/app_routes.dart';
import 'package:fc_social_fitness/viewmodels/change_password.viewmodel.dart';
import 'package:fc_social_fitness/views/widgets/custom_text_form_field.widget.dart';
import 'package:fc_social_fitness/views/widgets/fitness_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../constants/text_constants.dart';
import '../utils/flutter_flow_theme.util.dart';
import '../utils/internationalization.util.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({Key? key, required this.vm}) : super(key: key);
  final ChangePasswordViewModel vm;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(TextConstants.changePassword,
              style: FlutterFlowTheme.of(context).title3),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(15),
            child: StreamBuilder<bool>(
              stream: widget.vm.validPassword,
              builder: (context, snapshot) {
                return CustomTextFormField(
                  fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  hintText: "Nuova password",
                  //prova
                  style: TextStyle(color: FlutterFlowTheme.of(context).white),
                  togglePassword: true,
                  obscureText: true,
                  textEditingController: widget.vm.passwordTEC,
                  errorText: snapshot.error,
                  onChanged: widget.vm.validatePassword,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: StreamBuilder<bool>(
              stream: widget.vm.validConfirmPassword,
              builder: (context, snapshot) {
                return CustomTextFormField(
                  fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  hintText: "Conferma nuova password",
                  //prova
                  style: TextStyle(color: FlutterFlowTheme.of(context).white),
                  togglePassword: true,
                  obscureText: true,
                  textEditingController: widget.vm.confirmPasswordTEC,
                  errorText: snapshot.error,
                  onChanged: widget.vm.validateConfirmPassword,
                );
              },
            ),
          ),
          SizedBox(height: 15),
          Padding(
              padding: EdgeInsets.all(15),
              child: GestureDetector(
                  onTap: () {
                    widget.vm.doChangePassword();
                  },
                  child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: FlutterFlowTheme.of(context).course20,
                      ),
                      child: Center(
                        child: widget.vm.isBusy
                            ? CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.0)
                            : Text("Salva",
                                style: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .merge(TextStyle(color: Colors.white))),
                      ))))
        ]),
      ),
    );
  }
}
