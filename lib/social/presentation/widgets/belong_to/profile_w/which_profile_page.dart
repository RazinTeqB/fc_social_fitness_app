import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/pages/profile/personal_profile_page.dart';
import 'package:fc_social_fitness/social/presentation/pages/profile/user_profile_page.dart';

class WhichProfilePage extends StatelessWidget {
  final String userId;
  final String userName;
  const WhichProfilePage({Key? key, this.userId = '', this.userName = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userId.isNotEmpty) {
      return userId == myPersonalId
          ? PersonalProfilePage(personalId: userId)
          : UserProfilePage(userId: userId);
    } else {
      return Builder(builder: (context) {
        UserPersonalInfo? myPersonalInfo =
            UserInfoCubit.get(context).myPersonalInfo;

        return userName == myPersonalInfo.userName
            ? PersonalProfilePage(
                userName: userName,
                personalId: userId,
              )
            : UserProfilePage(
                userName: userName,
                userId: userId,
              );
      });
    }
  }
}
