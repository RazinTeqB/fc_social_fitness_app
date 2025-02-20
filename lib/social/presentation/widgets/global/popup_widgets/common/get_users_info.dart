import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/core/functions/toast_show.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/profile_w/show_me_the_users.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import '../../../../../../utils/internationalization.util.dart';

class GetUsersInfo extends StatefulWidget {
  final List<dynamic> usersIds;
  final bool isThatFollowers;
  final bool isThatMyPersonalId;

  const GetUsersInfo({
    Key? key,
    required this.isThatMyPersonalId,
    required this.usersIds,
    this.isThatFollowers = true,
  }) : super(key: key);

  @override
  State<GetUsersInfo> createState() => _GetUsersInfoState();
}

class _GetUsersInfoState extends State<GetUsersInfo> {
  ValueNotifier<bool> rebuildUsersInfo = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: rebuildUsersInfo,
      builder: (context, bool rebuildValue, child) =>
          BlocBuilder<UsersInfoCubit, UsersInfoState>(
        bloc: BlocProvider.of<UsersInfoCubit>(context)
          ..getSpecificUsersInfo(usersIds: widget.usersIds),
        buildWhen: (previous, current) {
          if (previous != current &&
              (current is CubitGettingSpecificUsersLoaded)) {
            return true;
          }
          if (rebuildValue && (current is CubitGettingSpecificUsersLoaded)) {
            rebuildUsersInfo.value = false;
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is CubitGettingSpecificUsersLoaded) {
            return ShowMeTheUsers(
              usersInfo: state.specificUsersInfo,
              emptyText: widget.isThatFollowers
                  ? FFLocalizations.of(context).getText(StringsManager.noFollowers)
                  : FFLocalizations.of(context).getText(StringsManager.noFollowings),
              isThatMyPersonalId: widget.isThatMyPersonalId,
            );
          }
          if (state is CubitGettingSpecificUsersFailed) {
            ToastShow.toastStateError(state);
            return Text(FFLocalizations.of(context).getText(StringsManager.somethingWrong));
          } else {
            return const ThineCircularProgress();
          }
        },
      ),
    );
  }
}
