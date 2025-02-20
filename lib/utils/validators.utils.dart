import 'dart:async';

class Validators {
  static bool isUsernameValid(String username) {
    return RegExp(
      r"^(?=[a-zA-Z0-9._]{4,20}$)(?!.*[_.]{2})[^_.].*[^_.]$",
    ).hasMatch(username);
  }

  static bool isEmailValid(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  static bool isPhoneNumberValid(String phone) {
    if (phone.length >= 10 && phone.length <= 15) {
      return true;
    } else {
      return false;
    }
  }

  static bool isLenghtValid(String value, int lenght) {
    if (value.length <= lenght) {
      return false;
    } else {
      return true;
    }
  }


  static bool isPasswordValid(String password,
      {bool includeCaps = false, int minLength = 6}) {
    if (password.isEmpty ||
        password.length < minLength ||
        RegExp(r'^(?=.?[A-Z])(?=.?[a-z])(?=.?[0-9])(?=.?[!@#$&*~]).{8,}$').hasMatch(password) != includeCaps) {
      return false;
    } else {
      return true;
    }
  }

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        if (password.length >= 6) {
          sink.add(password);
        } else {
          sink.addError('Password must be at least 6 characters');
        }
      });

  final validatePasswordBool = StreamTransformer<String, bool>.fromHandlers(
      handleData: (password, sink) {
        if (password.length >= 6) {
          sink.add(true);
        } else {
          sink.addError('Password must be at least 6 characters');
        }
      });
}
