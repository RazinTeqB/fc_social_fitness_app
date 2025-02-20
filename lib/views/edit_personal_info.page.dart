import 'package:fc_social_fitness/views/widgets/custom_text_form_field.widget.dart';
import 'package:fc_social_fitness/views/widgets/datetime_picker/flutter_datetime_picker.dart';
import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../constants/app_routes.dart';
import '../my_app.dart';
import '../utils/flutter_flow.util.dart';
import '../utils/flutter_flow_theme.util.dart';
import '../utils/internationalization.util.dart';
import '../viewmodels/signup.viewmodel.dart';

class EditPersonalInfo extends StatefulWidget {
  const EditPersonalInfo({Key? key}) : super(key: key);

  @override
  State<EditPersonalInfo> createState() => _EditPersonalInfoState();
}

class _EditPersonalInfoState extends State<EditPersonalInfo> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupViewModel>.reactive(
        viewModelBuilder: () => SignupViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return vm.isBusy
              ? FitnessLoading()
              : WillPopScope(
                  onWillPop: () async => true,
                  child: Scaffold(
                    backgroundColor:
                        FlutterFlowTheme.of(context).secondaryBackground,
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
                      centerTitle: true,
                      backgroundColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      iconTheme: IconThemeData(
                          color: FlutterFlowTheme.of(context).black),
                      title: Text(
                        'Modifica Profilo',
                        style: FlutterFlowTheme.of(context).title3,
                      ),
                      actions: <Widget>[
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            //todo update data
                          },
                          child: Center(
                            child: Text(
                              FFLocalizations.of(context).getText('salva'),
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .merge(TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .course20)),
                            ),
                          ),
                        ),
                        SizedBox(width: 15)
                      ],
                    ),
                    body: SingleChildScrollView(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Nome",
                              style: FlutterFlowTheme.of(context).bodyText1),
                          SizedBox(height: 15),
                          StreamBuilder<bool>(
                            stream: vm.validName,
                            builder: (context, snapshot) {
                              return CustomTextFormField(
                                fillColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                hintText:
                                    FFLocalizations.of(context).getText('nome'),
                                style: TextStyle(
                                    color: FlutterFlowTheme.of(context).white),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                textEditingController: vm.nameTEC,
                                errorText: snapshot.error,
                                onChanged: vm.validateName,
                              );
                            },
                          ),
                          //_entry(FFLocalizations.of(context).getText('nome'), controller: _name),
                          SizedBox(height: 15),
                          Text("Cognome",
                              style: FlutterFlowTheme.of(context).bodyText1),
                          SizedBox(height: 15),
                          Text("Bio",
                              style: FlutterFlowTheme.of(context).bodyText1),
                          //_entry(FFLocalizations.of(context).getText('bio'), controller: _bio),
                          SizedBox(height: 15),
                          StreamBuilder<bool>(
                            stream: vm.validBio,
                            builder: (context, snapshot) {
                              return CustomTextFormField(
                                fillColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                hintText: "Biografia",
                                style: TextStyle(
                                    color: FlutterFlowTheme.of(context).white),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                textEditingController: vm.bioTEC,
                                errorText: snapshot.error,
                                onChanged: vm.validateBio,
                              );
                            },
                          ),
                          SizedBox(height: 15),
                          Text("Nome utente",
                              style: FlutterFlowTheme.of(context).bodyText1),
                          SizedBox(height: 15),
                          StreamBuilder<bool>(
                            stream: vm.validUsername,
                            builder: (context, snapshot) {
                              return CustomTextFormField(
                                fillColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                hintText: vm.currentUser!.username!,
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
                          SizedBox(height: 15),
                          Text(
                            "Data di nascita",
                            style: FlutterFlowTheme.of(context).bodyText1,
                          ),
                          SizedBox(height: 15),
                          //todo aggiornamento data di nascita
                          /*GestureDetector(
                            onTap: showCalender,
                            child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                width: double.infinity,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(_dob.text,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1))),
                          ),*/
                          SizedBox(height: 15),
                          Text("Altezza",
                              style: FlutterFlowTheme.of(context).bodyText1),
                          SizedBox(height: 15),
                          StreamBuilder<bool>(
                            stream: vm.validHeight,
                            builder: (context, snapshot) {
                              return CustomTextFormField(
                                fillColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                hintText:
                                    "${FFLocalizations.of(context).getText('altezza')} (cm)",
                                style: TextStyle(
                                    color: FlutterFlowTheme.of(context).white),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                textEditingController: vm.heightTEC,
                                errorText: snapshot.error,
                                onChanged: vm.validateHeight,
                              );
                            },
                          ),
                          SizedBox(height: 15),

                          Text("Peso",
                              style: FlutterFlowTheme.of(context).bodyText1),
                          SizedBox(height: 15),
                          StreamBuilder<bool>(
                            stream: vm.validWeight,
                            builder: (context, snapshot) {
                              return CustomTextFormField(
                                fillColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                hintText:
                                    "${FFLocalizations.of(context).getText('peso')} (kg)",
                                style: TextStyle(
                                    color: FlutterFlowTheme.of(context).white),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                textEditingController: vm.weightTEC,
                                errorText: snapshot.error,
                                onChanged: vm.validateWeight,
                              );
                            },
                          ),
                          SizedBox(height: 30),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: FlutterFlowTheme.of(context).course20),
                              child: Align(
                                  child: Text("Cambia password",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .merge(TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .white))),
                                  alignment: Alignment.centerLeft),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  AppRoutes.changeCredentialOtp,
                                  arguments: 0);
                            },
                          ),
                          SizedBox(height: 30),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: FlutterFlowTheme.of(context).course20),
                              child: Align(
                                  child: Text("Cambia email",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .merge(TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .white))),
                                  alignment: Alignment.centerLeft),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  AppRoutes.changeCredentialOtp,
                                  arguments: 1);
                            },
                          ),
                          SizedBox(height: 30)
                        ],
                      ),
                    )),
                  ));
        });
  }
  //todo picker data di nascita
  /*void showCalender() async {
    await DatePicker.showDatePicker(context,
        showTitleActions: true,
        locale: MyApp.of(context).getLocale(),
        onChanged: (date) {}, onConfirm: (date) {
      setState(() {
        _dob.text = DateFormat("MM/dd/yyyy").format(date);
        //_dob.text= Utility.getdob(dob);
      });
    }, currentTime: DateTime.now());
  }*/
}
