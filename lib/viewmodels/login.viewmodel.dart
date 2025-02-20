import 'dart:math';

import 'package:fc_social_fitness/models/api_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_routes.dart';
import '../models/dialog_data.model.dart';
import '../repositories/auth.repository.dart';
import '../social/core/functions/toast_show.dart';
import '../social/core/utility/constant.dart';
import '../social/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../utils/app_database.dart';
import 'base.viewmodel.dart';

class SignInViewModel extends CustomBaseViewModel {
  TextEditingController emailAddressTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController phoneNumberTEC = TextEditingController();
  TextEditingController pinCodeTEC = TextEditingController();
  PhoneNumber phoneNumber = PhoneNumber(phoneNumber: "");
  final BehaviorSubject<bool> _emailValid = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _passwordValid =
      BehaviorSubject<bool>.seeded(false);

  Stream<bool> get validEmailAddress => _emailValid.stream;

  Stream<bool> get validPasswordAddress => _passwordValid.stream;

  final AuthRepository _authRepository = AuthRepository();

  SignInViewModel(BuildContext context) {
    viewContext = context;
  }

  @override
  Future initialise() async {
    setBusy(true);
    super.initialise();
    setBusy(false);
  }

  //as user enters email address, we are doing email validation
  bool validateEmailAddress(String value) {
    return true;
  }

  //as user enters password, we are doing password validation
  bool validatePassword(String value) {
    return true;
  }

  /*void doLoginWithSocial() async {
    setBusy(true);
    final firebaseUserUID = FirebaseAuth.instance.currentUser?.uid;

    //check if the user entered email & password are valid
    //update ui state
    final resultResponse = await _authRepository.loginWithSocial(
      viewContext,
      social_token: firebaseUserUID!,
    );

    if (resultResponse.allGood) {
      await saveUserData(
          resultResponse.body["user"], resultResponse.body["token"]);
      currentUser = await AppDatabase.getCurrentUser();
      await onAuthConfirmed(checkSubscription());
    } else {
      /*dialogData.title = LoginStrings.processFailedTitle;
        dialogData.body = resultResponse.message ?? LoginStrings.processErrorMessage;
        dialogData.dialogType = DialogType.failed;*/
      showAlert();
    }

    setBusy(false);
  }*/
  void doLoginWithSocial() async {
    setBusy(true);
    final firebaseUserUID = FirebaseAuth.instance.currentUser?.uid;

    // Check if the user entered email & password are valid
    final resultResponse = await _authRepository.loginWithSocial(
      viewContext,
      social_token: firebaseUserUID!,
    );

    if (resultResponse.allGood) {
      // Save the token in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', resultResponse.body["token"]);

      await saveUserData(resultResponse.body["user"], resultResponse.body["token"]);
      currentUser = await AppDatabase.getCurrentUser();
      await onAuthConfirmed(checkSubscription());
    } else {
      // Handle login failure
      showAlert();
    }

    setBusy(false);
  }

  Future onAuthConfirmed(bool checkSubscription) async  {
    UserInfoCubit getUserCubit = UserInfoCubit.get(viewContext);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getUserCubit.getUserInfo(FirebaseAuth.instance.currentUser!.uid, getDeviceToken: true);
      String userId = FirebaseAuth.instance.currentUser!.uid;
        myPersonalId = userId;
        if (myPersonalId.isNotEmpty) {
          SharedPreferences sharePrefs = await SharedPreferences.getInstance();
          await sharePrefs.setString("myPersonalId", myPersonalId);
          if (checkSubscription) {
            Navigator.pushNamed(viewContext, AppRoutes.homeRoute, arguments: 0);
          } else {
            Navigator.pushNamed(viewContext, AppRoutes.subscriptionRoute, arguments: true);
          }
        } else {
          ToastShow.toast("NU FUNZION NIEEEEENT");
        }
    });
  }
  void doLogin() async {
    setBusy(true);
    final email = emailAddressTEC.text;
    final password = passwordTEC.text;

    // Check if the user entered email & password are valid
    if (validateEmailAddress(email) && validatePassword(password)) {
      // Update UI state
      try {
        // Attempt to sign in with Firebase
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        // Simulate a call to your backend API to get a token
        final resultResponse = await _authRepository.login(viewContext, email: email, password: password);

        if (resultResponse.allGood) {
          // Save token in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', resultResponse.body["token"]);

          // Proceed with the login using the saved token
          doLoginWithSocial();
        } else {
          // Handle login failure
          dialogData.title = "Errore durante il login";
          dialogData.body = resultResponse.message ?? "Errore sconosciuto";
          dialogData.dialogType = DialogType.failed;
          showAlert();
        }
      } on FirebaseAuthException catch (e) {
        print(e);
        switch (e.code) {
          case "user-not-found":
            dialogData.title = "Errore durante il login";
            dialogData.body = "Utente non trovato";
            dialogData.dialogType = DialogType.failed;
            showAlert();
            break;
          case "wrong-password":
            dialogData.title = "Errore";
            dialogData.body = "Password errata";
            dialogData.dialogType = DialogType.failed;
            showAlert();
            break;
        }
      }
    }
    setBusy(false);
  }

  Future beginPhoneAuth(
      {required Function(String verificationId, int? resendToken)
          onCodeSent}) async {
    ApiResponse response = await _authRepository.checkPhone(viewContext,
        phone: phoneNumber.phoneNumber!);
    if (response.body["phoneNotFound"]) {
      dialogData.title = "Errore";
      dialogData.body = "Numero di telefono non trovato";
      dialogData.dialogType = DialogType.failed;
      showAlert();
    } else {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber.phoneNumber!,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  Future verifySmsCode(
      {required String verificationId, required String smsCode}) async {
    PhoneAuthCredential _credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    try {
      await FirebaseAuth.instance.signInWithCredential(_credential);
      doLoginWithSocial();
    } catch (e) {
      dialogData.title = "Errore";
      dialogData.body = "PIN OTP Errato";
      dialogData.dialogType = DialogType.failed;
      showAlert();
      Navigator.pop(viewContext);
    }
  }

  Future checkPhone({required String phone}) async {
    ApiResponse response = await _authRepository.checkPhone(viewContext,
        phone: phoneNumber.phoneNumber!);
    if (response.body["phoneNotFound"]) {
      dialogData.title = "Errore";
      dialogData.body = "Numero di telefono non trovato";
      dialogData.dialogType = DialogType.failed;
      showAlert();
    }
  }
}
