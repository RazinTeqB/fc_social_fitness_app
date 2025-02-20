import 'package:fc_social_fitness/constants/app_routes.dart';
import 'package:fc_social_fitness/viewmodels/change_password.viewmodel.dart';
import 'package:fc_social_fitness/views/widgets/custom_text_form_field.widget.dart';
import 'package:fc_social_fitness/views/widgets/fitness_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../constants/text_constants.dart';
import '../utils/flutter_flow_theme.util.dart';
import '../utils/internationalization.util.dart';

class ChangeEmailPage extends StatefulWidget {
  ChangeEmailPage({Key? key,required this.vm}) : super(key: key);
  final ChangePasswordViewModel vm;
  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(TextConstants.changePassword, style: TextStyle(color: Colors.black, fontSize: 18)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 140 - MediaQuery.of(context).padding.bottom,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: 15),
                Text(TextConstants.newPassword, style: TextStyle(fontWeight: FontWeight.w600)),
                StreamBuilder<bool>(
                  stream: widget.vm.validEmail,
                  builder: (context, snapshot) {
                    return CustomTextFormField(
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      hintText: FFLocalizations.of(context).getText('email'),
                      //prova
                      style: TextStyle(color: FlutterFlowTheme.of(context).white),
                      togglePassword: true,
                      obscureText: true,
                      textEditingController: widget.vm.emailTEC,
                      errorText: snapshot.error,
                      onChanged: widget.vm.validateEmail,
                    );
                  },
                ),

                Spacer(),
                FitnessButton(
                  title: TextConstants.save,
                  isEnabled: true,
                  onTap: () {
                    widget.vm.doChangeEmail();
                  },
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }}
