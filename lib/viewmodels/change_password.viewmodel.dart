import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:rxdart/rxdart.dart';

import '../constants/app_routes.dart';
import '../models/api_response.dart';
import '../models/dialog_data.model.dart';
import '../repositories/auth.repository.dart';
import '../utils/app_database.dart';
import '../utils/internationalization.util.dart';
import '../utils/validators.utils.dart';
import 'base.viewmodel.dart';

class ChangePasswordViewModel extends CustomBaseViewModel {
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController confirmPasswordTEC = TextEditingController();
  final BehaviorSubject<bool> _passwordValid =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _confirmPasswordValid =
      BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<bool> _emailValid =
  BehaviorSubject<bool>.seeded(false);

  final AuthRepository _authRepository = AuthRepository();
  TextEditingController pinCodeTEC = TextEditingController();
  UserCredential? userPhone;
  PhoneNumber phoneNumber = PhoneNumber(phoneNumber: "");
  Stream<bool> get validPassword => _passwordValid.stream;
  TextEditingController phoneNumberTEC = TextEditingController();
  Stream<bool> get validConfirmPassword => _confirmPasswordValid.stream;


  Stream<bool> get validEmail=> _emailValid.stream;
  TextEditingController emailTEC = TextEditingController();

  int? resendToken = 0;
  int page = 0;
  late PhoneAuthCredential phoneAuthCredential;
  ChangePasswordViewModel(BuildContext context, {String? phoneNumberString,int? pageValue}) {
    viewContext = context;
    if(pageValue!=null)
      {
        page = pageValue;
      }
  }

  @override
  Future initialise() async {
    setBusy(true);
    await super.initialise();
    setBusy(false);
  }



  bool validateEmail(String value) {
    if (!Validators.isEmailValid(value)) {
      _emailValid
          .addError(FFLocalizations.of(viewContext).getText('isEmailValid'));
      return false;
    } else {
      _emailValid.add(true);
      return true;
    }
  }

  bool validatePassword(String value) {
    if (!Validators.isPasswordValid(value)) {
      _passwordValid
          .addError(FFLocalizations.of(viewContext).getText('isPasswordValid'));
      return false;
    } else {
      _passwordValid.add(true);
      return true;
    }
  }

  bool validateConfirmPassword(String value) {
    if (value == passwordTEC.text) {
      _confirmPasswordValid.add(true);
      return true;
    } else {
      _confirmPasswordValid.addError(
          FFLocalizations.of(viewContext).getText('isConfirmPasswordValid'));
      return false;
    }
  }

  Future<bool> checkPhone({required String phone}) async {
    ApiResponse response = await _authRepository.checkPhone(viewContext, phone: phone);
    if (!response.body["phoneNotFound"]) {
      dialogData.title = "Errore";
      dialogData.body = "Numero di telefono già registrato";
      dialogData.dialogType = DialogType.failed;
      showAlert();
      return response.body["phoneNotFound"];
    }else{
      return response.body["phoneNotFound"];
    }
  }


  Future beginPhoneAuth(
      {required String phoneNumber, required Function(String verificationId, int? resendToken)
      onCodeSent}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: currentUser!=null? currentUser!.phone!: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: onCodeSent,
      forceResendingToken: resendToken,
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future verifySmsCode(
      {required String verificationId, required String smsCode}) async {
    phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    try{
      userPhone = await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      switch(page)
      {
        case 0:
          Navigator.pushNamed(viewContext, AppRoutes.changePassword, arguments: this);
          break;
        case 1:
          Navigator.pushNamed(viewContext, AppRoutes.changeEmail, arguments: this);
          break;
        default:
          Navigator.pushNamed(viewContext, AppRoutes.loginRoute, arguments: this);
          break;
      }
    }catch(e)
    {
      dialogData.title = "Errore";
      dialogData.body = "PIN OTP Errato";
      dialogData.dialogType = DialogType.failed;
      showAlert();
      Navigator.pop(viewContext);
    }
  }
void doChangePassword() async {
    if(validateConfirmPassword(passwordTEC.text) && validateConfirmPassword(confirmPasswordTEC.text))
      {
        User user = FirebaseAuth.instance.currentUser!;
        user.reauthenticateWithCredential(phoneAuthCredential).then((value) {
          user.updatePassword(passwordTEC.text).then((value) async{

            final resultResponse = await _authRepository.loginWithSocial(
              viewContext,
              social_token: user.uid,
            );
            if(resultResponse.allGood)
              {
                await saveUserData(resultResponse.body["user"], resultResponse.body["token"]);
                currentUser = await AppDatabase.getCurrentUser();
                ApiResponse response =  await _authRepository.updateUser(viewContext,{
                  "password": passwordTEC.text
                });
                await doLogout();
                if(response.allGood)
                {
                  dialogData.title = "OK";
                  dialogData.body = "Password aggiornata con successo";
                  dialogData.dialogType = DialogType.success;
                  showAlert();
                  if(currentUser==null)
                  {
                    Navigator.pushNamed(viewContext, AppRoutes.loginRoute);
                  }else{
                    //todosocial
                    //Navigator.push(viewContext, EditProfilePage.getRoute());
                  }
                }else{
                  dialogData.title = "Error";
                  dialogData.body = "Io ci ho provato, ma non ci son riuscito";
                  dialogData.dialogType = DialogType.failed;
                  showAlert();
                  Navigator.pushNamed(viewContext, AppRoutes.loginRoute);
                }
              }else{
              dialogData.title = "Error";
              dialogData.body = "Cioè, ci sta proprio il problema";
              dialogData.dialogType = DialogType.failed;
              showAlert();
              Navigator.pushNamed(viewContext, AppRoutes.loginRoute);
            }
          }).onError((error, stackTrace) {
            dialogData.title = "Error";
            dialogData.body = "Eefdefnherkjfjhrekf";
            dialogData.dialogType = DialogType.failed;
            showAlert();
            Navigator.pushNamed(viewContext, AppRoutes.loginRoute);
          });
        }).onError((error, stackTrace) {
          dialogData.title = "Error";
          dialogData.body = "ejkfbnrjkfnrkjfn";
          dialogData.dialogType = DialogType.failed;
          showAlert();
          Navigator.pushNamed(viewContext, AppRoutes.loginRoute);
        });
      }else{
      dialogData.title = "Error";
      dialogData.body = "Errore durante il cambio della password";
      dialogData.dialogType = DialogType.failed;
      showAlert();
      Navigator.pushNamed(viewContext, AppRoutes.loginRoute);
    }
  }


  void changeUserData()async{

  }



  void doChangeEmail() async {
    if(validateEmail(emailTEC.text))
    {
      User user = FirebaseAuth.instance.currentUser!;
      user.reauthenticateWithCredential(phoneAuthCredential).then((value) {
        user.updateEmail(emailTEC.text).then((value) async{
          ApiResponse response =  await _authRepository.updateUser(viewContext,{
            "email":emailTEC.text
          });
          if(response.allGood)
          {
            dialogData.title = "OK";
            dialogData.body = "Email aggiornata con successo";
            dialogData.dialogType = DialogType.success;
            await saveUserData(response.body["user"],currentUser!.token!);
            currentUser = await AppDatabase.getCurrentUser();
            //todosocial
            //Navigator.push(viewContext, EditProfilePage.getRoute());
          }
        }).onError((error, stackTrace) {
          dialogData.title = "Error";
          dialogData.body = "Eefdefnherkjfjhrekf";
          dialogData.dialogType = DialogType.failed;
          showAlert();
        });
      }).onError((error, stackTrace) {
        dialogData.title = "Error";
        dialogData.body = "ejkfbnrjkfnrkjfn";
        dialogData.dialogType = DialogType.failed;
        showAlert();
      });
    }else{
      dialogData.title = "Error";
      dialogData.body = "Errore durante il cambio della password";
      dialogData.dialogType = DialogType.failed;
      showAlert();
    }
  }
}
