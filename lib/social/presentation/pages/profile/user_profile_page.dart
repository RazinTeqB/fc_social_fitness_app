import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/config/routes/app_routes.dart';
import 'package:fc_social_fitness/social/core/functions/date_of_now.dart';
import 'package:fc_social_fitness/social/core/functions/toast_show.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/utility/injector.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/notification.dart';
import 'package:fc_social_fitness/social/domain/entities/notification_check.dart';
import 'package:fc_social_fitness/social/domain/entities/sender_info.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/message/bloc/message_bloc.dart';
import 'package:fc_social_fitness/social/presentation/cubit/follow/follow_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/notification/notification_cubit.dart';
import 'package:fc_social_fitness/social/presentation/pages/messages/chatting_page.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/profile_w/bottom_sheet.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/profile_w/profile_page.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/profile_w/recommendation_people.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_app_bar.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';

import '../../../../utils/flutter_flow_theme.util.dart';
import '../../../../utils/internationalization.util.dart';
import '../../../core/utility/constant.dart';
import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../cubit/firestoreUserInfoCubit/user_info_cubit.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;
  final String userName;

  const UserProfilePage({Key? key, required this.userId, this.userName = ''})
      : super(key: key);

  @override
  State<UserProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<UserProfilePage> {
  ValueNotifier<bool> rebuildUserInfo = ValueNotifier(false);
  late UserPersonalInfo myPersonalInfo;
  late ValueNotifier<UserPersonalInfo> userInfo;

  @override
  initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  dispose() {
    rebuildUserInfo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return scaffold();
  }

  Future<void> getData() async {
    widget.userName.isNotEmpty
        ? (await BlocProvider.of<UserInfoCubit>(context)
            .getUserFromUserName(widget.userName))
        : (await BlocProvider.of<UserInfoCubit>(context)
            .getUserInfo(widget.userId, isThatMyPersonalId: false));
    rebuildUserInfo.value = true;
  }

  Widget scaffold() {
    return ValueListenableBuilder(
      valueListenable: rebuildUserInfo,
      builder: (context, bool rebuildUserInfoValue, child) =>
          BlocBuilder<UserInfoCubit, UserInfoState>(
        bloc: widget.userName.isNotEmpty
            ? (BlocProvider.of<UserInfoCubit>(context)
              ..getUserFromUserName(widget.userName))
            : (BlocProvider.of<UserInfoCubit>(context)
              ..getUserInfo(widget.userId, isThatMyPersonalId: false)),
        buildWhen: (previous, current) {
          if (previous != current && current is CubitUserLoaded) {
            return true;
          }
          if (rebuildUserInfoValue && current is CubitUserLoaded) {
            rebuildUserInfo.value = false;
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is CubitUserLoaded) {
            userInfo = ValueNotifier(state.userPersonalInfo);
            return Scaffold(
              appBar: isThatMobile
                  ? CustomAppBar.menuOfUserAppBar(
                      context, state.userPersonalInfo.userName, bottomSheet)
                  : null,
              body: ProfilePage(
                  isThatMyPersonalId: false,
                  userId: widget.userId,
                  getData: getData,
                  userInfo: userInfo,
                  widgetsAboveTapBars: widgetsAboveTapBarsForMobile(state)),
            );
          } else if (state is CubitGetUserInfoFailed) {
            ToastShow.toastStateError(state);
            return Text(
              FFLocalizations.of(context).getText(StringsManager.somethingWrong),
              style: FlutterFlowTheme.of(context).bodyText1,
            );
          } else {
            return const ThineCircularProgress();
          }
        },
      ),
    );
  }

  Future<void> bottomSheet() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomBottomSheet(
          headIcon: Container(),
          bodyText: buildTexts(),
        );
      },
    );
  }

  Padding buildTexts() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          textOfBottomSheet(FFLocalizations.of(context).getText(StringsManager.report)),
          const SizedBox(height: 15),
          textOfBottomSheet(FFLocalizations.of(context).getText(StringsManager.block)),
          const SizedBox(height: 15),
          textOfBottomSheet(FFLocalizations.of(context).getText(StringsManager.aboutThisAccount)),
          const SizedBox(height: 15),
          textOfBottomSheet(FFLocalizations.of(context).getText(StringsManager.restrict)),
          const SizedBox(height: 15),
          textOfBottomSheet(FFLocalizations.of(context).getText(StringsManager.hideYourStory)),
          const SizedBox(height: 15),
          textOfBottomSheet(FFLocalizations.of(context).getText(StringsManager.copyProfileURL)),
          const SizedBox(height: 15),
          textOfBottomSheet(FFLocalizations.of(context).getText(StringsManager.shareThisProfile)),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Text textOfBottomSheet(String text) {
    return Text(text, style: FlutterFlowTheme.of(context).bodyText1);
  }

  List<Widget> widgetsAboveTapBarsForMobile(UserInfoState userInfoState) {
    return [
      followButton(userInfoState),
      const SizedBox(width: 15),
      messageButton(),
      const SizedBox(width: 15),
    ];
  }

  Widget followButtonForWeb() {
    return BlocBuilder<FollowCubit, FollowState>(
      builder: (context, stateOfFollow) {
        bool isThatFollowing =
            myPersonalInfo.followedPeople.contains(userInfo.value.userId);
        bool isFollowLoading = stateOfFollow is CubitFollowThisUserLoading;
        Widget child = isFollowLoading
            ? const CupertinoActivityIndicator(color: ColorManager.black)
            : (isThatFollowing
                ? const Icon(
                    Icons.person,
                    color: ColorManager.black,
                    size: 18,
                  )
                : Text(
          FFLocalizations.of(context).getText(StringsManager.follow),
                    style: FlutterFlowTheme.of(context).bodyText1,
                  ));
        return ValueListenableBuilder(
          valueListenable: userInfo,
          builder: (__, UserPersonalInfo userInfoValue, _) => GestureDetector(
            onTap: () async => onTapFollowButton(userInfoValue),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 9, vertical: isThatFollowing ? 4 : 6),
              decoration: BoxDecoration(
                color: isThatFollowing
                    ? ColorManager.transparent
                    : ColorManager.red,
                border: isThatFollowing
                    ? Border.all(
                        color: ColorManager.lowOpacityGrey,
                        width: 1,
                      )
                    : null,
                borderRadius: BorderRadius.circular(3),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }

  Widget followButton(UserInfoState userInfoState) {
    return BlocBuilder<FollowCubit, FollowState>(
      builder: (context, stateOfFollow) {
        return ValueListenableBuilder(
          valueListenable: userInfo,
          builder: (context, UserPersonalInfo userInfoValue, child) => Expanded(
            child: InkWell(
                onTap: () async => onTapFollowButton(userInfoValue),
                child: whichContainerOfText(stateOfFollow, userInfoValue)),
          ),
        );
      },
    );
  }

  Widget whichContainerOfText(
      FollowState stateOfFollow, UserPersonalInfo userInfoValue) {
    if (stateOfFollow is CubitFollowThisUserFailed) {
      ToastShow.toastStateError(stateOfFollow);
    }
    bool isThatFollower =
        myPersonalInfo.followerPeople.contains(userInfoValue.userId);
    return !myPersonalInfo.followedPeople.contains(userInfoValue.userId)
        ? containerOfFollowText(
            text: isThatFollower
                ? FFLocalizations.of(context).getText(StringsManager.followBack)
                : FFLocalizations.of(context).getText(StringsManager.follow),
            isThatFollowers: false,
          )
        : containerOfFollowText(
            text: FFLocalizations.of(context).getText(StringsManager.following),
            isThatFollowers: true,
          );
  }

  void onTapFollowButton(UserPersonalInfo userInfoValue) {
    if (myPersonalInfo.followedPeople.contains(userInfoValue.userId)) {
      BlocProvider.of<FollowCubit>(context).unFollowThisUser(
          followingUserId: userInfoValue.userId, myPersonalId: myPersonalId);
      myPersonalInfo.followedPeople.remove(userInfoValue.userId);
      userInfo.value.followerPeople.remove(myPersonalId);
      //for notification
      BlocProvider.of<NotificationCubit>(context).deleteNotification(
          notificationCheck: createNotificationCheck(userInfoValue));
    } else {
      BlocProvider.of<FollowCubit>(context).followThisUser(
          followingUserId: userInfoValue.userId, myPersonalId: myPersonalId);
      myPersonalInfo.followedPeople.add(userInfoValue.userId);
      userInfo.value.followerPeople.add(myPersonalId);
      //for notification
      BlocProvider.of<NotificationCubit>(context).createNotification(
          newNotification: createNotification(userInfoValue));
    }
    setState(() {});
  }

  NotificationCheck createNotificationCheck(UserPersonalInfo userInfo) {
    return NotificationCheck(
      senderId: myPersonalId,
      receiverId: userInfo.userId,
      isThatLike: false,
      isThatPost: false,
    );
  }

  CustomNotification createNotification(UserPersonalInfo userInfo) {
    return CustomNotification(
      text: "ha iniziato a seguirti.",
      time: DateOfNow.dateOfNow(),
      senderId: myPersonalId,
      receiverId: userInfo.userId,
      personalUserName: myPersonalInfo.userName,
      personalProfileImageUrl: myPersonalInfo.profileImageUrl,
      isThatLike: false,
      isThatPost: false,
      senderName: myPersonalInfo.userName,
    );
  }

  Expanded messageButton() {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          pushToPage(context,
              page: BlocProvider<MessageBloc>(
                create: (context) => injector<MessageBloc>(),
                child: ChattingPage(
                    messageDetails:
                        SenderInfo(receiversInfo: [userInfo.value])),
              ));
        },
        child: containerOfFollowText(
          text: FFLocalizations.of(context).getText(StringsManager.message),
          isThatFollowers: true,
        ),
      ),
    );
  }

  Container containerOfFollowText({
    required String text,
    required bool isThatFollowers,
  }) {
    return Container(
      height: 35.0,
      decoration: BoxDecoration(
        color: isThatFollowers
            ? FlutterFlowTheme.of(context).primaryBackground
            : FlutterFlowTheme.of(context).course20,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Text(
          text,
          style: FlutterFlowTheme.of(context).bodyText1,
        ),
      ),
    );
  }
}
