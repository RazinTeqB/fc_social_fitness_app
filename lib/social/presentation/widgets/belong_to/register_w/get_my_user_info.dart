import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:fc_social_fitness/social/core/functions/toast_show.dart';
import 'package:fc_social_fitness/social/presentation/screens/responsive_layout.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/register_w/popup_calling.dart';

class GetMyPersonalInfo extends StatefulWidget {
  final String myPersonalId;
  const GetMyPersonalInfo({Key? key, required this.myPersonalId})
      : super(key: key);

  @override
  State<GetMyPersonalInfo> createState() => _GetMyPersonalInfoState();
}

class _GetMyPersonalInfoState extends State<GetMyPersonalInfo> {
  bool isHeMovedToHome = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      bloc: UserInfoCubit.get(context)
        ..getUserInfo(widget.myPersonalId, getDeviceToken: true),
      builder: (context, userState) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (userState is CubitMyPersonalInfoLoaded) {
            if (!isHeMovedToHome) {
              myPersonalId = widget.myPersonalId;
              Get.offAll(PopupCalling(myPersonalId),);
            }
            isHeMovedToHome = true;
          } else if (userState is CubitGetUserInfoFailed) {
            ToastShow.toastStateError(userState);
          }
        });
        return Container(
          color: Theme.of(context).primaryColor,
        );
      },
    );
  }
}
