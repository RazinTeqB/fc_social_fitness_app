import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/core/functions/toast_show.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_linears_progress.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_share_button.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';
import '../../../../../utils/internationalization.util.dart';

class SendToUsers extends StatefulWidget {
  final TextEditingController messageTextController;
  final UserPersonalInfo publisherInfo;
  final Post postInfo;
  final ValueChanged<bool> clearTexts;
  final ValueNotifier<List<UserPersonalInfo>> selectedUsersInfo;
  final bool checkBox;
  const SendToUsers({
    Key? key,
    this.checkBox = false,
    required this.publisherInfo,
    required this.clearTexts,
    required this.selectedUsersInfo,
    required this.messageTextController,
    required this.postInfo,
  }) : super(key: key);

  @override
  State<SendToUsers> createState() => _SendToUsersState();
}

class _SendToUsersState extends State<SendToUsers> {
  late UserPersonalInfo myPersonalInfo;
  @override
  void initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersInfoCubit, UsersInfoState>(
      bloc: BlocProvider.of<UsersInfoCubit>(context)
        ..getFollowersAndFollowingsInfo(
            followersIds: myPersonalInfo.followerPeople,
            followingsIds: myPersonalInfo.followedPeople),
      buildWhen: (previous, current) =>
          previous != current && (current is CubitFollowersAndFollowingsLoaded),
      builder: (context, state) {
        if (state is CubitFollowersAndFollowingsLoaded) {
          return buildBodyOfSheet(state);
        }
        if (state is CubitGettingSpecificUsersFailed) {
          ToastShow.toastStateError(state);
          return Text(FFLocalizations.of(context).getText(StringsManager.somethingWrong));
        } else {
          return isThatMobile
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    SizedBox(height: 1, child: ThineLinearProgress()),
                  ],
                )
              : const Scaffold(
                  body: SizedBox(height: 1, child: ThineLinearProgress()),
                );
        }
      },
    );
  }

  Widget buildBodyOfSheet(CubitFollowersAndFollowingsLoaded state) {
    List<UserPersonalInfo> usersInfo =
        state.followersAndFollowingsInfo.followersInfo;
    for (final i in state.followersAndFollowingsInfo.followingsInfo) {
      if (!usersInfo.contains(i)) usersInfo.add(i);
    }
    return ValueListenableBuilder(
      valueListenable: widget.selectedUsersInfo,
      builder: (context, List<UserPersonalInfo> selectedUsersValue, child) {
        if (isThatMobile) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              buildUsers(usersInfo, selectedUsersValue),
              if (selectedUsersValue.isNotEmpty)
                CustomShareButton(
                  postInfo: widget.postInfo,
                  clearTexts: widget.clearTexts,
                  publisherInfo: widget.publisherInfo,
                  messageTextController: widget.messageTextController,
                  selectedUsersInfo: selectedUsersValue,
                  textOfButton: FFLocalizations.of(context).getText(StringsManager.done),
                ),
            ],
          );
        } else {
          return buildUsers(usersInfo, selectedUsersValue);
        }
      },
    );
  }

  Padding buildUsers(List<UserPersonalInfo> usersInfo,
      List<UserPersonalInfo> selectedUsersValue) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
          end: 15, start: 15, bottom: 50, top: 20),
      child: ListView.separated(
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        itemBuilder: (context, index) =>
            buildUserInfo(context, usersInfo[index], selectedUsersValue),
        itemCount: usersInfo.length,
        separatorBuilder: (context, _) => const SizedBox(height: 0),
      ),
    );
  }

  Row buildUserInfo(BuildContext context, UserPersonalInfo userInfo,
      List<UserPersonalInfo> selectedUsersValue) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: ColorManager.customGrey,
          backgroundImage: userInfo.profileImageUrl.isNotEmpty
              ? CachedNetworkImageProvider(userInfo.profileImageUrl)
              : null,
          radius: 23,
          child: userInfo.profileImageUrl.isEmpty
              ? Icon(
                  Icons.person,
                  color: FlutterFlowTheme.of(context).course20,
                  size: 25,
                )
              : null,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userInfo.name,
                style: FlutterFlowTheme.of(context).bodyText1,
              ),
              Text(
                userInfo.userName,
                style: FlutterFlowTheme.of(context).bodyText1,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            setState(() {
              if (!selectedUsersValue.contains(userInfo)) {
                widget.selectedUsersInfo.value.add(userInfo);
              } else {
                widget.selectedUsersInfo.value.remove(userInfo);
              }
              widget.clearTexts(false);
            });
          },
          child: whichChild(context, selectedUsersValue.contains(userInfo)),
        ),
      ],
    );
  }

  Widget whichChild(BuildContext context, bool selectedUserValue) {
    return widget.checkBox
        ? checkBox(context, selectedUserValue)
        : whichContainerOfText(context, selectedUserValue);
  }

  Widget checkBox(BuildContext context, bool selectedUserValue) {
    return Container(
      padding: EdgeInsetsDirectional.all(0),
      decoration: BoxDecoration(
        color: !selectedUserValue
            ? FlutterFlowTheme.of(context).course20.withOpacity(0.5)
            : FlutterFlowTheme.of(context).course20,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: const Center(
        child: Icon(Icons.check_rounded, color: ColorManager.white, size: 17),
      ),
    );
  }

  Widget whichContainerOfText(BuildContext context, bool selectedUserValue) {
    return !selectedUserValue
        ? containerOfFollowText(
            context, FFLocalizations.of(context).getText(StringsManager.send), selectedUserValue)
        : containerOfFollowText(
            context, FFLocalizations.of(context).getText(StringsManager.undo), selectedUserValue);
  }

  Widget containerOfFollowText(
      BuildContext context, String text, bool selectedUserValue) {
    return Container(
      height: 30.0,
      padding: const EdgeInsetsDirectional.only(start: 17, end: 17),
      decoration: BoxDecoration(
        color: selectedUserValue
            ? FlutterFlowTheme.of(context).course20.withOpacity(0.5)
            : FlutterFlowTheme.of(context).course20,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Text(
          text,
          style: FlutterFlowTheme.of(context).bodyText1.merge(TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
