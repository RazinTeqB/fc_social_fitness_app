/*import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fc_social_fitness/views/widgets/custom_text_form_field.widget.dart';
import 'package:fc_social_fitness/views/widgets/fitness_button.widget.dart';
import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:fc_social_fitness/views/widgets/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import '../utils/flutter_flow.util.dart';
import '../utils/flutter_flow_theme.util.dart';
import '../utils/internationalization.util.dart';
import '../viewmodels/signup.viewmodel.dart';
import 'widgets/datetime_picker/flutter_datetime_picker.dart';
import 'widgets/datetime_picker/src/i18n_model.dart';

class SignUpStepTwo extends StatefulWidget {
  const SignUpStepTwo({Key? key, required this.vm}) : super(key: key);
  final SignupViewModel vm;

  @override
  State<SignUpStepTwo> createState() => _SignUpStepTwoState();
}

class _SignUpStepTwoState extends State<SignUpStepTwo> {
  bool isBackPressedOrTouchedOutSide = false;
  bool isDropDownOpened = false;
  bool isPanDown = false;

  @override
  Widget build(BuildContext context) {
    return widget.vm.isBusy
        ? FitnessLoading()
        : GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        resizeToAvoidBottomInset: true,
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
                  "Fase 2 di 2",
                  style: FlutterFlowTheme.of(context).bodyText1,
                ),
                SizedBox(height: 30),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: StreamBuilder<bool>(
                    stream: widget.vm.validName,
                    builder: (context, snapshot) {
                      return CustomTextFormField(
                        fillColor:
                        FlutterFlowTheme.of(context).primaryBackground,
                        hintText: FFLocalizations.of(context).getText('Nome e cognome'),
                        style: TextStyle(
                            color: FlutterFlowTheme.of(context).white),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textEditingController: widget.vm.nameTEC,
                        errorText: snapshot.error,
                        onChanged: widget.vm.validateName,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: StreamBuilder<bool>(
                                stream: widget.vm.validDateBorn,
                                builder: (context, snapshot) {
                                  return CustomTextFormField(
                                    isReadOnly: true,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    hintText: FFLocalizations.of(context)
                                        .getText('data di nascita'),
                                    style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .white),
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    textEditingController:
                                    widget.vm.dateBornItaTEC,
                                    errorText: snapshot.error,
                                    onChanged: widget.vm.validateDateBorn,
                                    onTap: () async {
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          locale: LocaleType.it,
                                          maxTime: DateTime.now(),
                                          //MyApp.of(context).getLocale(),
                                          onChanged: (date) {},
                                          onConfirm: (date) {
                                            setState(() {
                                              widget.vm.dateBornItaTEC.text =
                                                  DateFormat("dd/MM/yyyy")
                                                      .format(date);
                                              widget.vm.dateBornTEC.text =
                                                  DateFormat("MM/dd/yyyy")
                                                      .format(date);
                                              //_dob.text= Utility.getdob(dob);
                                            });
                                          }, currentTime: DateTime.now());
                                    },
                                  );
                                }))),
                    SizedBox(width: 15),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.only(right: 15),
                            child: DropdownButtonFormField2(
                              dropdownElevation: 1,
                              buttonDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                              decoration: InputDecoration(
                                //Add isDense true and zero Padding.
                                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                //Add more decoration as you want here
                                //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                              ),
                              isExpanded: true,
                              hint: Text("Sesso",
                                  style:
                                  FlutterFlowTheme.of(context).bodyText2),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                              iconSize: 20,
                              buttonHeight: 50,
                              buttonPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                              dropdownDecoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              items: widget.vm.genderItems.entries
                                  .map((entry) => DropdownMenuItem<String>(
                                value: entry.key,
                                child: Text(
                                  entry.value,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1,
                                ),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  widget.vm.genderValue = value.toString();
                                });
                              },
                            ))),
                  ],
                ),

                /*AwesomeDropDown(
                                  isPanDown: isPanDown,
                                  dropDownList: ["Uomo", "Donna", "Preferisco non specificare"],
                                  isBackPressedOrTouchedOutSide: isBackPressedOrTouchedOutSide,
                                  selectedItem: widget.vm.gender,
                                  onDropDownItemClick: (selectedItem) {
                                    widget.vm.gender = selectedItem;
                                  },
                                  dropStateChanged: (isOpened) {
                                    isDropDownOpened = isOpened;
                                    if (!isOpened) {
                                      isBackPressedOrTouchedOutSide = false;
                                    }
                                  },
                                ),*/

                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: StreamBuilder<bool>(
                        stream: widget.vm.validBio,
                        builder: (context, snapshot) {
                          return CustomTextFormField(
                            fillColor: FlutterFlowTheme.of(context)
                                .primaryBackground,
                            style: TextStyle(
                                color: FlutterFlowTheme.of(context).white),
                            hintText: "Biografia",
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            textEditingController: widget.vm.bioTEC,
                            errorText: snapshot.error,
                            onChanged: widget.vm.validateBio,
                          );
                        })),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: StreamBuilder<bool>(
                    stream: widget.vm.validHeight,
                    builder: (context, snapshot) {
                      return CustomTextFormField(
                        fillColor:
                        FlutterFlowTheme.of(context).primaryBackground,
                        hintText:
                        "${FFLocalizations.of(context).getText('altezza')} (cm)",
                        style: TextStyle(
                            color: FlutterFlowTheme.of(context).white),
                        keyboardType: TextInputType.numberWithOptions(),
                        textInputAction: TextInputAction.next,
                        textEditingController: widget.vm.heightTEC,
                        errorText: snapshot.error,
                        onChanged: widget.vm.validateHeight,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: StreamBuilder<bool>(
                    stream: widget.vm.validWeight,
                    builder: (context, snapshot) {
                      return CustomTextFormField(
                        fillColor:
                        FlutterFlowTheme.of(context).primaryBackground,
                        hintText:
                        "${FFLocalizations.of(context).getText('peso')} (kg)",
                        style: TextStyle(
                            color: FlutterFlowTheme.of(context).white),
                        keyboardType: TextInputType.numberWithOptions(),
                        textInputAction: TextInputAction.done,
                        textEditingController: widget.vm.weightTEC,
                        errorText: snapshot.error,
                        onChanged: widget.vm.validateWeight,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),
                FFButtonWidget(
                    text: FFLocalizations.of(context).getText('avanti'),
                    onPressed: () {
                      widget.vm.validateSecondStep();
                      FocusManager.instance.primaryFocus?.unfocus();
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
                // Spacer(),
              ],
            )),
      ),
    );
  }
}*/
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fc_social_fitness/views/widgets/custom_text_form_field.widget.dart';
import 'package:fc_social_fitness/views/widgets/fitness_button.widget.dart';
import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:fc_social_fitness/views/widgets/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import '../utils/flutter_flow.util.dart';
import '../utils/flutter_flow_theme.util.dart';
import '../utils/internationalization.util.dart';
import '../viewmodels/signup.viewmodel.dart';
import 'widgets/datetime_picker/flutter_datetime_picker.dart';
import 'widgets/datetime_picker/src/i18n_model.dart';

class SignUpStepTwo extends StatefulWidget {
  const SignUpStepTwo({Key? key, required this.vm}) : super(key: key);
  final SignupViewModel vm;

  @override
  State<SignUpStepTwo> createState() => _SignUpStepTwoState();
}

class _SignUpStepTwoState extends State<SignUpStepTwo> {
  bool isBackPressedOrTouchedOutSide = false;
  bool isDropDownOpened = false;
  bool isPanDown = false;

  @override
  Widget build(BuildContext context) {
    return widget.vm.isBusy
        ? FitnessLoading()
        : GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        resizeToAvoidBottomInset: true,
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
                "Fase 2 di 2",
                style: FlutterFlowTheme.of(context).bodyText1,
              ),
              SizedBox(height: 30),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: StreamBuilder<bool>(
                  stream: widget.vm.validName,
                  builder: (context, snapshot) {
                    return CustomTextFormField(
                      fillColor:
                      FlutterFlowTheme.of(context).primaryBackground,
                      hintText: FFLocalizations.of(context)
                          .getText('Nome e cognome'),
                      style: TextStyle(
                          color: FlutterFlowTheme.of(context).white),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textEditingController: widget.vm.nameTEC,
                      errorText: snapshot.error,
                      onChanged: widget.vm.validateName,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: StreamBuilder<bool>(
                        stream: widget.vm.validDateBorn,
                        builder: (context, snapshot) {
                          return CustomTextFormField(
                            isReadOnly: true,
                            fillColor: FlutterFlowTheme.of(context)
                                .primaryBackground,
                            hintText: FFLocalizations.of(context)
                                .getText('data di nascita'),
                            style: TextStyle(
                                color: FlutterFlowTheme.of(context)
                                    .white),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            textEditingController:
                            widget.vm.dateBornItaTEC,
                            errorText: snapshot.error,
                            onChanged: widget.vm.validateDateBorn,
                            onTap: () async {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  locale: LocaleType.it,
                                  maxTime: DateTime.now(),
                                  onChanged: (date) {},
                                  onConfirm: (date) {
                                    setState(() {
                                      widget.vm.dateBornItaTEC.text =
                                          DateFormat("dd/MM/yyyy")
                                              .format(date);
                                      widget.vm.dateBornTEC.text =
                                          DateFormat("MM/dd/yyyy")
                                              .format(date);
                                    });
                                  }, currentTime: DateTime.now());
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 15),
                      child: DropdownButtonFormField2(
                        dropdownElevation: 1,
                        buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: FlutterFlowTheme.of(context)
                              .primaryBackground,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        isExpanded: true,
                        hint: Text(
                          "Sesso",
                          style: FlutterFlowTheme.of(context).bodyText2,
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        iconSize: 20,
                        buttonHeight: 50,
                        buttonPadding: const EdgeInsets.symmetric(
                            horizontal: 15),
                        dropdownDecoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .primaryBackground,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        items: widget.vm.genderItems.entries
                            .map((entry) => DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(
                            entry.value,
                            style: FlutterFlowTheme.of(context)
                                .bodyText1,
                          ),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            widget.vm.genderValue = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: StreamBuilder<bool>(
                  stream: widget.vm.validBio,
                  builder: (context, snapshot) {
                    return CustomTextFormField(
                      fillColor:
                      FlutterFlowTheme.of(context).primaryBackground,
                      style: TextStyle(
                          color: FlutterFlowTheme.of(context).white),
                      hintText: "Biografia",
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textEditingController: widget.vm.bioTEC,
                      errorText: snapshot.error,
                      onChanged: widget.vm.validateBio,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: StreamBuilder<bool>(
                  stream: widget.vm.validHeight,
                  builder: (context, snapshot) {
                    return CustomTextFormField(
                      fillColor:
                      FlutterFlowTheme.of(context).primaryBackground,
                      hintText: "${FFLocalizations.of(context).getText('altezza')} (cm)",
                      style: TextStyle(
                          color: FlutterFlowTheme.of(context).white),
                      keyboardType: TextInputType.numberWithOptions(),
                      textInputAction: TextInputAction.next,
                      textEditingController: widget.vm.heightTEC,
                      errorText: snapshot.error,
                      onChanged: widget.vm.validateHeight,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: StreamBuilder<bool>(
                  stream: widget.vm.validWeight,
                  builder: (context, snapshot) {
                    return CustomTextFormField(
                      fillColor:
                      FlutterFlowTheme.of(context).primaryBackground,
                      hintText: "${FFLocalizations.of(context).getText('peso')} (kg)",
                      style: TextStyle(
                          color: FlutterFlowTheme.of(context).white),
                      keyboardType: TextInputType.numberWithOptions(),
                      textInputAction: TextInputAction.done,
                      textEditingController: widget.vm.weightTEC,
                      errorText: snapshot.error,
                      onChanged: widget.vm.validateWeight,
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              FFButtonWidget(
                text: FFLocalizations.of(context).getText('avanti'),
                onPressed: () {
                  widget.vm.validateSecondStep();
                  FocusManager.instance.primaryFocus?.unfocus();
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
            ],
          ),
        ),
      ),
    );
  }
}