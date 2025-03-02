import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/domain/entities/registered_user.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/register_w/popup_calling.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/register_w/register_widgets.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_elevated_button.dart';
import 'package:fc_social_fitness/social/core/functions/toast_show.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/internationalization.util.dart';

class LoginPage extends StatefulWidget {
  final SharedPreferences sharePrefs;
  const LoginPage({Key? key, required this.sharePrefs}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxBool isHeMovedToHome = false.obs;
  ValueNotifier<bool> isToastShowed = ValueNotifier(false);
  ValueNotifier<bool> isUserIdReady = ValueNotifier(true);
  ValueNotifier<bool> validateEmail = ValueNotifier(false);
  ValueNotifier<bool> validatePassword = ValueNotifier(false);

  @override
  dispose() {
    super.dispose();
    isToastShowed.dispose();
    isUserIdReady.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RegisterWidgets(
      customTextButton: customTextButton(),
      emailController: emailController,
      passwordController: passwordController,
      validateEmail: validateEmail,
      validatePassword: validatePassword,
    );
  }

  Widget customTextButton() {
    return Builder(builder: (context) {
      UserInfoCubit getUserCubit = UserInfoCubit.get(context);

      return blocBuilder(getUserCubit);
    });
  }

  BlocBuilder<FirebaseAuthCubit, FirebaseAuthCubitState> blocBuilder(
      UserInfoCubit getUserCubit) {
    return BlocBuilder<FirebaseAuthCubit, FirebaseAuthCubitState>(
      buildWhen: (previous, current) => true,
      builder: (context, authState) =>
          buildBlocBuilder(context, authState, getUserCubit),
    );
  }

  Widget buildBlocBuilder(
      context, FirebaseAuthCubitState authState, UserInfoCubit getUserCubit) {
    return ValueListenableBuilder(
      valueListenable: isToastShowed,
      builder: (context, bool isToastShowedValue, child) {
        FirebaseAuthCubit authCubit = FirebaseAuthCubit.get(context);
        if (authState is CubitAuthConfirmed) {
          onAuthConfirmed(getUserCubit, authCubit);
        } else if (authState is CubitAuthFailed && !isToastShowedValue) {
          isToastShowed.value = true;
          isUserIdReady.value = true;
          ToastShow.toastStateError(authState);
        }
        return loginButton(authCubit);
      },
    );
  }

  onAuthConfirmed(UserInfoCubit getUserCubit, FirebaseAuthCubit authCubit) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getUserCubit.getUserInfo(authCubit.user!.uid, getDeviceToken: true);
      String userId = authCubit.user!.uid;
      isUserIdReady.value = true;
      if (!isHeMovedToHome.value) {
        myPersonalId = userId;
        if (myPersonalId.isNotEmpty) {
          await widget.sharePrefs.setString("myPersonalId", myPersonalId);
          Get.offAll(PopupCalling(myPersonalId));
        } else {
          ToastShow.toast(FFLocalizations.of(context).getText(StringsManager.somethingWrong));
        }
      }
      isHeMovedToHome.value = true;
    });
  }

  Widget loginButton(FirebaseAuthCubit authCubit) {
    return ValueListenableBuilder(
      valueListenable: isUserIdReady,
      builder: (context, bool isUserIdReadyValue, child) =>
          ValueListenableBuilder(
        valueListenable: validateEmail,
        builder: (context, bool validateEmailValue, child) =>
            ValueListenableBuilder(
          valueListenable: validatePassword,
          builder: (context, bool validatePasswordValue, child) {
            bool validate = validatePasswordValue && validateEmailValue;

            return CustomElevatedButton(
              isItDone: isUserIdReadyValue,
              nameOfButton: FFLocalizations.of(context).getText(StringsManager.logIn),
              blueColor: validate,
              onPressed: () async {
                if (validate) {
                  isUserIdReady.value = false;
                  isToastShowed.value = false;
                  await authCubit.logIn(RegisteredUser(
                      email: emailController.text,
                      password: passwordController.text));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
