import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/core/functions/toast_show.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/profile_w/show_me_the_users.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';

import '../../../../utils/flutter_flow_theme.util.dart';
import '../../../../utils/internationalization.util.dart';
import '../../cubit/firestoreUserInfoCubit/users_info_cubit.dart';

class UsersWhoLikes extends StatelessWidget {
  final List<dynamic> usersIds;
  final bool showSearchBar;
  final bool showColorfulCircle;
  final bool isThatMyPersonalId;

  const UsersWhoLikes({
    Key? key,
    required this.showSearchBar,
    required this.usersIds,
    required this.isThatMyPersonalId,
    this.showColorfulCircle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<UsersInfoCubit>(context)
        ..getSpecificUsersInfo(usersIds: usersIds),
      buildWhen: (previous, current) =>
          previous != current && current is CubitGettingSpecificUsersLoaded,
      builder: (context, state) {
        if (state is CubitGettingSpecificUsersLoaded) {
          return ShowMeTheUsers(
            usersInfo: state.specificUsersInfo,
            emptyText: FFLocalizations.of(context).getText(StringsManager.noUsers),
            showColorfulCircle: showColorfulCircle,
            isThatMyPersonalId: isThatMyPersonalId,
          );
        }
        if (state is CubitGettingSpecificUsersFailed) {
          ToastShow.toastStateError(state);
          return Center(
            child: Text(FFLocalizations.of(context).getText(StringsManager.somethingWrong),
                style: FlutterFlowTheme.of(context).title1),
          );
        } else {
          return const Center(child: ThineCircularProgress());
        }
      },
    );
  }
}
