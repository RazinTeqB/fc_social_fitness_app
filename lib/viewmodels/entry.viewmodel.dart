import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../social/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'base.viewmodel.dart';

class EntryViewModel extends CustomBaseViewModel {
  EntryViewModel(BuildContext context) {
    viewContext = context;
  }

  @override
  Future initialise() async {
    setBusy(true);
    UserInfoCubit getUserCubit = UserInfoCubit.get(viewContext);
    if(FirebaseAuth.instance.currentUser!=null)
      {
        await getUserCubit.getUserInfo(FirebaseAuth.instance.currentUser!.uid, getDeviceToken: true);
      }
    await super.initialise();
    setBusy(false);
  }

}