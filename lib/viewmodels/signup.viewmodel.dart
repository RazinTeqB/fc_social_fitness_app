import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:rxdart/rxdart.dart';
import '../constants/app_routes.dart';
import '../constants/app_strings.dart';
import '../models/api_response.dart';
import '../models/dialog_data.model.dart';
import '../models/user.model.dart' as user_model;
import '../repositories/auth.repository.dart';
import '../social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../social/presentation/cubit/firestoreUserInfoCubit/add_new_user_cubit.dart';
import '../utils/app_database.dart';
import '../utils/internationalization.util.dart';
import '../utils/shared_manager.dart';
import '../utils/validators.utils.dart';
import 'base.viewmodel.dart';
import 'login.viewmodel.dart';

class SignupViewModel extends CustomBaseViewModel {
  TextEditingController emailAddressTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController confirmPasswordTEC = TextEditingController();
  TextEditingController usernameTEC = TextEditingController();
  PhoneNumber phoneNumber = PhoneNumber(phoneNumber: "");
  TextEditingController phoneNumberTEC = TextEditingController();
  TextEditingController pinCodeTEC = TextEditingController();
  UserCredential? phoneUserCredential;
  UserCredential? userPhone;
  UserCredential? emailPasswordUserCredential;
  TextEditingController nameTEC = TextEditingController();
  TextEditingController bioTEC = TextEditingController();
  TextEditingController heightTEC = TextEditingController();
  TextEditingController weightTEC = TextEditingController();
  TextEditingController dateBornTEC = TextEditingController();
  TextEditingController dateBornItaTEC = TextEditingController();
  TextEditingController dayTEC = TextEditingController();
  TextEditingController monthTEC = TextEditingController();
  TextEditingController yearTEC = TextEditingController();
  
  Map<String, String> genderItems = {
    "0": "Uomo",
    "1": "Donna",
    "2": "Non specificato"
  };

  String genderValue = "0";
  final AuthRepository _authRepository = AuthRepository();

  final BehaviorSubject<bool> _emailValid = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _passwordValid =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _confirmPasswordValid =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _usernameValid =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _phoneValid = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _nameValid = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _bioValid = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _bornDateValid =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _heightValid =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _weightValid =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _dateBornValid =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _dayValid = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _monthValid = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _yearValid = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get validEmailAddress => _emailValid.stream;

  Stream<bool> get validPassword => _passwordValid.stream;

  Stream<bool> get validConfirmPassword => _confirmPasswordValid.stream;

  Stream<bool> get validUsername => _usernameValid.stream;

  Stream<bool> get validName => _nameValid.stream;


  Stream<bool> get validBio => _bioValid.stream;

  Stream<bool> get validBornDate => _bornDateValid.stream;

  Stream<bool> get validHeight => _heightValid.stream;

  Stream<bool> get validWeight => _weightValid.stream;

  Stream<bool> get validDateBorn => _dateBornValid.stream;

  Stream<bool> get validDay => _dayValid.stream;

  Stream<bool> get validMonth => _monthValid.stream;

  Stream<bool> get validYear => _yearValid.stream;

  bool isEnabled = true;
  int? resendToken = 0;

  SignupViewModel(BuildContext context) {
    viewContext = context;
  }

  @override
  Future initialise() async {
    setBusy(true);
    await super.initialise();
    if (currentUser != null) {
      nameTEC.text = currentUser!.userData!.name!;
      bioTEC.text = currentUser!.userData!.bio!;
      usernameTEC.text = currentUser!.username!;
      heightTEC.text = currentUser!.userData!.height!;
      weightTEC.text = currentUser!.userData!.weight!;
    }
    setBusy(false);
  }

  bool validateDateBorn(String value) {
    if (!Validators.isLenghtValid(value, 1)) {
      _dateBornValid
          .addError(FFLocalizations.of(viewContext).getText('isDateBornValid'));
      return false;
    } else {
      _dateBornValid.add(true);
      return true;
    }
  }
  bool validateDay(String value) {
    return true;
  }

  bool validateMonth(String value) {
    return true;
  }

  bool validateYear(String value) {
    return true;
  }

  //todo check email e username duplicati
  //as user enters email address, we are doing email validation
  bool validateEmailAddress(String value) {
    if (!Validators.isEmailValid(value)) {
      _emailValid
          .addError(FFLocalizations.of(viewContext).getText('isEmailValid'));
      return false;
    } else {
      _emailValid.add(true);
      return true;
    }
  }

  bool validateUsername(String value) {
    if (!Validators.isUsernameValid(value)) {
      _usernameValid
          .addError(FFLocalizations.of(viewContext).getText('isUsernameValid'));
      return false;
    } else {
      _usernameValid.add(true);
      return true;
    }
  }

  bool checkUsername(String value) {
    if (!Validators.isUsernameValid(value)) {
      _usernameValid
          .addError(FFLocalizations.of(viewContext).getText('isUsernameValid'));
      return false;
    } else {
      _usernameValid.add(true);
      return true;
    }
  }

  //as user enters password, we are doing password validation
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

  bool validateName(String value) {
    if (!Validators.isLenghtValid(value, 3)) {
      _nameValid
          .addError(FFLocalizations.of(viewContext).getText('isNameValid'));
      return false;
    } else {
      _nameValid.add(true);
      return true;
    }
  }



  bool validateBio(String value) {
      return true;
  }

  bool validateHeight(String value) {
    if (!Validators.isLenghtValid(value, 2)) {
      _heightValid
          .addError(FFLocalizations.of(viewContext).getText('isHeightValid'));
      return false;
    } else {
      _heightValid.add(true);
      return true;
    }
  }

  bool validateWeight(String value) {
    if (!Validators.isLenghtValid(value, 1)) {
      _weightValid
          .addError(FFLocalizations.of(viewContext).getText('isWeightValid'));
      return false;
    } else {
      _weightValid.add(true);
      return true;
    }
  }

  Future updateUserData() async {
    setBusy(true);
    final username = usernameTEC.text;
    final name = nameTEC.text;
    final bio = bioTEC.text;
    final height = heightTEC.text;
    final weight = weightTEC.text;
    final gender = genderValue;

    //check if the user entered email & password are valid
    if (validateBio(bio) &&
        validateName(name) &&
        validateUsername(username) &&
        validateWeight(weight) &&
        validateHeight(height)) {
      //update ui state
      final resultResponse = await _authRepository.updateUserData(viewContext, {
        "name": nameTEC.text,
        "bio": bioTEC.text,
        "height": heightTEC.text,
        "weight": weightTEC.text,
        "gender": genderValue.toString(),
      });
      if (resultResponse.allGood) {
        dialogData.title = "Modifica completata";
        dialogData.body = "Dati aggiornati con successo";
        dialogData.dialogType = DialogType.success;
        await saveUserData(resultResponse.body["user"], currentUser!.token!);
        currentUser = await AppDatabase.getCurrentUser();
        showAlert();
      } else {
        dialogData.title = "Errore";
        dialogData.body = "Errore durante l'aggiornamento dei dati";
        dialogData.dialogType = DialogType.failed;
        showAlert();
      }
    }
  }


Future doSignup() async {
  setBusy(true);
  
  final email = emailAddressTEC.text;
  final password = passwordTEC.text;
  final username = usernameTEC.text.toLowerCase();
  final phone = phoneNumber.phoneNumber;
  final name = nameTEC.text;
  final bio = bioTEC.text;
  final dateBorn = dateBornTEC.text;
  final height = heightTEC.text;
  final weight = weightTEC.text;
  final gender = genderValue;

  // Stampa i parametri per il debug
  print("Parametri inviati al backend:");
  print("email: $email");
  print("password: $password");
  print("username: $username");
  print("phone: $phone");
  print("name: $name");
  print("gender: $gender");
  print("bio: $bio");
  print("dateBorn: $dateBorn");
  print("height: $height");
  print("weight: $weight");

  if (validateEmailAddress(email) &&
      validatePassword(password) &&
      validateUsername(username)) {
    try {
      // Creazione dell'utente in Firebase Auth
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      
      final firebaseUser = userCredential.user;
      final firebaseToken = await firebaseUser?.uid;
      
      if (firebaseUser == null || firebaseToken == null) {
        throw Exception("Errore nella creazione dell'utente Firebase.");
      }

      // Effettua la registrazione nel backend
      final resultResponse = await _authRepository.signup(viewContext,
        email: email,
        password: password,
        username: username,
        firebaseToken: firebaseToken,
        phone: "33333333333",
        name: name,
        gender: gender,
        bio: bio,
        dateBorn: dateBorn,
        height: height,
        weight: weight,
      );

      // Stampa il risultato del backend per il debug
      print("Risultato della risposta del backend:");
      print("Body: ${resultResponse.body}");

      // Controlla la risposta del backend
      if (resultResponse.allGood && 
          resultResponse.body is Map &&
          resultResponse.body.containsKey("user") &&
          resultResponse.body.containsKey("token")) {
        
        await saveUserData(resultResponse.body["user"], resultResponse.body["token"]);
        
        // Creazione dell'oggetto UserPersonalInfo
        List<dynamic> charactersOfName = [];
        String nameOfLower = username.toLowerCase();
        for (int i = 0; i < nameOfLower.length; i++) {
          charactersOfName.add(nameOfLower.substring(0, i + 1));
        }
        
        UserPersonalInfo newUserInfo = UserPersonalInfo(
          name: name,
          charactersOfName: charactersOfName,
          email: email,
          userName: username,
          bio: bio,
          profileImageUrl: "",
          userId: firebaseUser.uid,
          followerPeople: const [],
          followedPeople: const [],
          posts: const [],
          chatsOfGroups: const [],
          stories: const [],
          lastThreePostUrls: const [],
        );

        // Aggiunta dell'utente al Firestore tramite Cubit
        FirestoreAddNewUserCubit userCubit = FirestoreAddNewUserCubit.get(viewContext);
        userCubit.addNewUser(newUserInfo);

        // Login automatico dopo la registrazione
        SignInViewModel(viewContext).doLoginWithSocial();
        
        // Navigate to the main screen
        Navigator.pushNamed(viewContext, AppRoutes.entryRoute, arguments: true);

      } else {
        // Gestione del caso in cui la risposta non contenga le chiavi attese
        print("Errore: `resultResponse.body` non contiene le chiavi 'user' o 'token'.");
        dialogData.title = "Errore";
        dialogData.body = "Errore nella risposta del backend.";
        dialogData.dialogType = DialogType.failed;
        showAlert();
      }
    } on FirebaseAuthException catch (e) {
      // Gestione specifica degli errori Firebase
      print("Errore Firebase Auth: $e");
      String errorMessage;
      switch (e.code) {
        case "email-already-in-use":
          errorMessage = "Email già in uso";
          break;
        case "invalid-email":
          errorMessage = "Email non valida";
          break;
        case "weak-password":
          errorMessage = "Password troppo debole";
          break;
        default:
          errorMessage = "Errore sconosciuto durante la registrazione";
          break;
      }
      dialogData.title = "Errore";
      dialogData.body = errorMessage;
      dialogData.dialogType = DialogType.failed;
      showAlert();
    } catch (e) {
      // Gestione generale degli errori
      print("Errore generale durante la registrazione: $e");
      dialogData.title = "Errore";
      dialogData.body = "Si è verificato un errore imprevisto.";
      dialogData.dialogType = DialogType.failed;
      showAlert();
    }
  } else {
    // Messaggio di errore se i dati non sono validi
    dialogData.title = "Errore";
    dialogData.body = "Dati di registrazione non validi.";
    dialogData.dialogType = DialogType.failed;
    showAlert();
  }

  setBusy(false);
}
  Future saveUserData(dynamic userObject, String token) async {
    //this is variable is inherited from HttpService
    final mUser = user_model.User.formJson(userJSONObject: userObject);
    mUser.token = token;
    await AppDatabase.deleteCurrentUser();
    await AppDatabase.storeUser(mUser);
    //
    /*_firebaseMessaging.subscribeToTopic("all");
    _firebaseMessaging.subscribeToTopic(mUser.role);
    _firebaseMessaging.subscribeToTopic(mUser.id.toString());*/

    //save to shared pref
    SharedManager.prefs!.setBool(AppStrings.authenticated, true);
  }

  Future beginPhoneAuth(
      {required Function(String verificationId, int? resendToken)
          onCodeSent}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber.phoneNumber!,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: onCodeSent,
      forceResendingToken: resendToken,
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<bool> checkPhone({required String phone}) async {
    ApiResponse response =
        await _authRepository.checkPhone(viewContext, phone: phone);
    if (!response.body["phoneNotFound"]) {
      dialogData.title = "Errore";
      dialogData.body = "Numero di telefono già registrato";
      dialogData.dialogType = DialogType.failed;
      showAlert();
      return response.body["phoneNotFound"];
    } else {
      return response.body["phoneNotFound"];
    }
  }

  void validateSecondStep() async {
    final name = nameTEC.text;
    /*final bio = bioTEC.text;
    final height = heightTEC.text;
    final weight = weightTEC.text;*/
    final dateBorn = dateBornTEC.text;

    if (validateName(name) &&
        /*validateHeight(height) &&
        validateWeight(weight) &&*/
        validateDateBorn(dateBorn) /*&&
        validateBio(bio)*/) {
      try {
        AuthCredential phoneAuthCredential = EmailAuthProvider.credential(
            email: emailAddressTEC.text, password: passwordTEC.text);
        userPhone?.user?.linkWithCredential(phoneAuthCredential);
        doSignup();
      } on FirebaseAuthException catch (e) {
        print(e);
        switch (e.code) {
          case "email-already-in-use":
            dialogData.title = "Errore";
            dialogData.body = "Email già in uso";
            dialogData.dialogType = DialogType.failed;
            showAlert();
            Navigator.pushNamed(viewContext, AppRoutes.loginRoute);
            break;
          case "credential-already-in-use":
            FirebaseAuth.instance.currentUser?.delete();
            dialogData.title = "Errore";
            dialogData.body = "Numero già in uso";
            dialogData.dialogType = DialogType.failed;
            showAlert();
            Navigator.pushNamed(viewContext, AppRoutes.loginRoute);
            break;
        }
      }
    } else {
      dialogData.title = "Errore";
      dialogData.body = "Devi compilare tutti i campi per proseguire!";
      dialogData.dialogType = DialogType.failed;
      showAlert();
    }
  }

  void validateFirstStep() async {
    final email = emailAddressTEC.text;
    final password = passwordTEC.text;
    final username = usernameTEC.text;
    //todo check parametri
    if (validateEmailAddress(email) &&
        validatePassword(password) &&
        validateUsername(username)) {
      final response = await _authRepository.checkEmailUsername(viewContext,
          username: username, email: email);
      if (response.body["usernameNotFound"]) {
        if (response.body["emailNotFound"]) {
          Navigator.pushNamed(viewContext, AppRoutes.signupStepTwoRoute,
              arguments: this);
        } else {
          dialogData.title = "Errore";
          dialogData.body = "Email già in uso";
          dialogData.dialogType = DialogType.failed;
          showAlert();
        }
      } else {
        dialogData.title = "Errore";
        dialogData.body = "Username già in uso";
        dialogData.dialogType = DialogType.failed;
        showAlert();
      }
    } else {
      dialogData.title = "Errore";
      dialogData.body = "Devi compilare tutti i campi per proseguire!";
      dialogData.dialogType = DialogType.failed;
      showAlert();
    }
  }

  Future verifySmsCode(
      {required String verificationId, required String smsCode}) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    try {
      userPhone =
          await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      Navigator.pushNamed(viewContext, AppRoutes.signupStepOneRoute,
          arguments: this);
    } catch (e) {
      dialogData.title = "Errore";
      dialogData.body = "PIN OTP Errato";
      dialogData.dialogType = DialogType.failed;
      showAlert();
      Navigator.pop(viewContext);
    }
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:rxdart/rxdart.dart';
// import '../constants/app_routes.dart';
// import '../constants/app_strings.dart';
// import '../models/api_response.dart';
// import '../models/dialog_data.model.dart';
// import '../models/user.model.dart' as user_model;
// import '../repositories/auth.repository.dart';
// import '../social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
// import '../social/presentation/cubit/firestoreUserInfoCubit/add_new_user_cubit.dart';
// import '../utils/app_database.dart';
// import '../utils/internationalization.util.dart';
// import '../utils/shared_manager.dart';
// import '../utils/validators.utils.dart';
// import 'base.viewmodel.dart';

// class SignupViewModel extends CustomBaseViewModel {
//   TextEditingController emailAddressTEC = TextEditingController();
//   TextEditingController passwordTEC = TextEditingController();
//   TextEditingController confirmPasswordTEC = TextEditingController();
//   TextEditingController usernameTEC = TextEditingController();
//   TextEditingController nameTEC = TextEditingController();
//   TextEditingController bioTEC = TextEditingController();
//   TextEditingController heightTEC = TextEditingController();
//   TextEditingController weightTEC = TextEditingController();
//   TextEditingController dateBornTEC = TextEditingController();
//   TextEditingController dateBornItaTEC = TextEditingController();

//   String genderValue = "0";
//   Map<String, String> genderItems = {
//     "0": "Uomo",
//     "1": "Donna",
//     "2": "Non specificato"
//   };

//   UserCredential? emailPasswordUserCredential;

//   //String genderValue = "0";
//   final AuthRepository _authRepository = AuthRepository();

//   final BehaviorSubject<bool> _emailValid = BehaviorSubject<bool>.seeded(false);
//   final BehaviorSubject<bool> _passwordValid = BehaviorSubject<bool>.seeded(false);
//   final BehaviorSubject<bool> _confirmPasswordValid = BehaviorSubject<bool>.seeded(false);
//   final BehaviorSubject<bool> _usernameValid = BehaviorSubject<bool>.seeded(false);
//   final BehaviorSubject<bool> _nameValid = BehaviorSubject<bool>.seeded(false);
//   final BehaviorSubject<bool> _bioValid = BehaviorSubject<bool>.seeded(false);
//   final BehaviorSubject<bool> _dateBornValid = BehaviorSubject<bool>.seeded(false);
//   final BehaviorSubject<bool> _heightValid = BehaviorSubject<bool>.seeded(false);
//   final BehaviorSubject<bool> _weightValid = BehaviorSubject<bool>.seeded(false);

//   Stream<bool> get validEmailAddress => _emailValid.stream;
//   Stream<bool> get validPassword => _passwordValid.stream;
//   Stream<bool> get validConfirmPassword => _confirmPasswordValid.stream;
//   Stream<bool> get validUsername => _usernameValid.stream;
//   Stream<bool> get validName => _nameValid.stream;
//   Stream<bool> get validBio => _bioValid.stream;
//   Stream<bool> get validDateBorn => _dateBornValid.stream;
//   Stream<bool> get validHeight => _heightValid.stream;
//   Stream<bool> get validWeight => _weightValid.stream;

//   bool isEnabled = true;

//   SignupViewModel(BuildContext context) {
//     viewContext = context;
//   }

//   @override
//   Future initialise() async {
//     setBusy(true);
//     await super.initialise();
//     if (currentUser != null) {
//       nameTEC.text = currentUser!.userData!.name!;
//       bioTEC.text = currentUser!.userData!.bio!;
//       usernameTEC.text = currentUser!.username!;
//       heightTEC.text = currentUser!.userData!.height!;
//       weightTEC.text = currentUser!.userData!.weight!;
//     }
//     setBusy(false);
//   }

//   bool validateEmailAddress(String value) {
//     if (!Validators.isEmailValid(value)) {
//       _emailValid.addError(FFLocalizations.of(viewContext).getText('isEmailValid'));
//       return false;
//     } else {
//       _emailValid.add(true);
//       return true;
//     }
//   }

//   bool validateUsername(String value) {
//     if (!Validators.isUsernameValid(value)) {
//       _usernameValid.addError(FFLocalizations.of(viewContext).getText('isUsernameValid'));
//       return false;
//     } else {
//       _usernameValid.add(true);
//       return true;
//     }
//   }

//   bool validatePassword(String value) {
//     if (!Validators.isPasswordValid(value)) {
//       _passwordValid.addError(FFLocalizations.of(viewContext).getText('isPasswordValid'));
//       return false;
//     } else {
//       _passwordValid.add(true);
//       return true;
//     }
//   }

//   bool validateConfirmPassword(String value) {
//     if (value == passwordTEC.text) {
//       _confirmPasswordValid.add(true);
//       return true;
//     } else {
//       _confirmPasswordValid.addError(FFLocalizations.of(viewContext).getText('isConfirmPasswordValid'));
//       return false;
//     }
//   }

//   bool validateName(String value) {
//     if (!Validators.isLenghtValid(value, 3)) {
//       _nameValid.addError(FFLocalizations.of(viewContext).getText('isNameValid'));
//       return false;
//     } else {
//       _nameValid.add(true);
//       return true;
//     }
//   }

//   bool validateBio(String value) {
//     if (!Validators.isLenghtValid(value, 5)) {
//       _bioValid.addError(FFLocalizations.of(viewContext).getText('isBioValid'));
//       return false;
//     } else {
//       _bioValid.add(true);
//       return true;
//     }
//   }

//   bool validateDateBorn(String value) {
//     if (value.isEmpty) {
//       _dateBornValid.addError(FFLocalizations.of(viewContext).getText('isDateBornValid'));
//       return false;
//     } else {
//       _dateBornValid.add(true);
//       return true;
//     }
//   }

//   bool validateHeight(String value) {
//     if (double.tryParse(value) == null) {
//       _heightValid.addError(FFLocalizations.of(viewContext).getText('isHeightValid'));
//       return false;
//     } else {
//       _heightValid.add(true);
//       return true;
//     }
//   }

//   bool validateWeight(String value) {
//     if (double.tryParse(value) == null) {
//       _weightValid.addError(FFLocalizations.of(viewContext).getText('isWeightValid'));
//       return false;
//     } else {
//       _weightValid.add(true);
//       return true;
//     }
//   }

//   void validateSecondStep() async {
//     final name = nameTEC.text;
//     final bio = bioTEC.text;
//     final height = heightTEC.text;
//     final weight = weightTEC.text;
//     final dateBorn = dateBornTEC.text;

//     if (validateName(name) &&
//         validateHeight(height) &&
//         validateWeight(weight) &&
//         validateDateBorn(dateBorn) &&
//         validateBio(bio)) {
//       try {
//         doSignup();
//       } catch (e) {
//         dialogData.title = "Errore";
//         dialogData.body = "Errore durante la registrazione";
//         dialogData.dialogType = DialogType.failed;
//         showAlert();
//       }
//     } else {
//       dialogData.title = "Errore";
//       dialogData.body = "Compila tutti i campi correttamente!";
//       dialogData.dialogType = DialogType.failed;
//       showAlert();
//     }
//   }

//   Future doSignup() async {
//     setBusy(true);
//     final email = emailAddressTEC.text;
//     final password = passwordTEC.text;
//     final username = usernameTEC.text.toLowerCase();
//     final name = nameTEC.text;
//     final bio = bioTEC.text;
//     final dateBorn = dateBornTEC.text;
//     final height = heightTEC.text;
//     final weight = weightTEC.text;
//     final gender = genderValue;

//     if (validateEmailAddress(email) &&
//         validatePassword(password) &&
//         validateUsername(username)) {
//       try {
//         emailPasswordUserCredential = await FirebaseAuth.instance
//             .createUserWithEmailAndPassword(email: email, password: password);

//         final resultResponse = await _authRepository.signup(viewContext,
//             email: email,
//             password: password,
//             username: username,
//             firebaseToken: FirebaseAuth.instance.currentUser?.uid,
//             phone: null,
//             name: name,
//             gender: gender,
//             bio: bio,
//             dateBorn: dateBorn,
//             height: height,
//             weight: weight);

//         if (resultResponse.allGood) {
//           await saveUserData(resultResponse.body["user"], resultResponse.body["token"]);

//           String fullName = "$username";
//           List<dynamic> charactersOfName = [];
//           String nameOfLower = fullName.toLowerCase();

//           for (int i = 0; i < nameOfLower.length; i++) {
//             charactersOfName = charactersOfName + [nameOfLower.substring(0, i + 1)];
//           }

//           UserPersonalInfo newUserInfo = UserPersonalInfo(
//               name: "$name",
//               charactersOfName: charactersOfName,
//             email: email,
//             userName: username,
//             bio: bio,
//             profileImageUrl: "",
//             userId: FirebaseAuth.instance.currentUser!.uid,
//             followerPeople: const [],
//             followedPeople: const [],
//             posts: const [],
//             chatsOfGroups: const [],
//             stories: const [],
//             lastThreePostUrls: const [],
//           );
//           FirestoreAddNewUserCubit userCubit = FirestoreAddNewUserCubit.get(viewContext);
//           userCubit.addNewUser(newUserInfo);

//           Navigator.pushNamed(viewContext, AppRoutes.entryRoute, arguments: true);
//         } else {
//           dialogData.title = "Errore";
//           dialogData.body = "Errore durante la registrazione";
//           dialogData.dialogType = DialogType.failed;
//           showAlert();
//         }
//       } catch (e) {
//         print(e.toString());
//         dialogData.title = "Errore";
//         dialogData.body = "Errore durante la creazione dell'account";
//         dialogData.dialogType = DialogType.failed;
//         showAlert();
//       }
//     } else {
//       dialogData.title = "Errore";
//       dialogData.body = "Compila tutti i campi correttamente!";
//       dialogData.dialogType = DialogType.failed;
//       showAlert();
//     }
//     setBusy(false);
//   }

//   Future saveUserData(dynamic userObject, String token) async {
//     final mUser = user_model.User.formJson(userJSONObject: userObject);
//     mUser.token = token;
//     await AppDatabase.deleteCurrentUser();
//     await AppDatabase.storeUser(mUser);
//     SharedManager.prefs!.setBool(AppStrings.authenticated, true);
//   }

//   void validateFirstStep() async {
//     final email = emailAddressTEC.text;
//     final password = passwordTEC.text;
//     final username = usernameTEC.text;
//     if (validateEmailAddress(email) &&
//         validatePassword(password) &&
//         validateUsername(username)) {
//       final response = await _authRepository.checkEmailUsername(viewContext,
//           username: username, email: email);
//       if (response.body["usernameNotFound"]) {
//         if (response.body["emailNotFound"]) {
//           Navigator.pushNamed(viewContext, AppRoutes.signupStepTwoRoute, arguments: this);
//         } else {
//           dialogData.title = "Errore";
//           dialogData.body = "Email già in uso";
//           dialogData.dialogType = DialogType.failed;
//           showAlert();
//         }
//       } else {
//         dialogData.title = "Errore";
//         dialogData.body = "Username già in uso";
//         dialogData.dialogType = DialogType.failed;
//         showAlert();
//       }
//     } else {
//       dialogData.title = "Errore";
//       dialogData.body = "Devi compilare tutti i campi per proseguire!";
//       dialogData.dialogType = DialogType.failed;
//       showAlert();
//     }
//   }
// }