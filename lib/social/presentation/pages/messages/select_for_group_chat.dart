import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/config/routes/app_routes.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/styles_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/core/functions/toast_show.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/core/utility/injector.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/domain/entities/sender_info.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/message/bloc/message_bloc.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/users_info_reel_time/users_info_reel_time_bloc.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/messages_w/chat_messages.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_app_bar.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_linears_progress.dart';

import '../../../../utils/flutter_flow_theme.util.dart';
import '../../../../utils/internationalization.util.dart';

class SelectForGroupChat extends StatefulWidget {
  const SelectForGroupChat({Key? key}) : super(key: key);

  @override
  State<SelectForGroupChat> createState() => _SelectForGroupChatState();
}

class _SelectForGroupChatState extends State<SelectForGroupChat> {
  final selectedUsersInfo = ValueNotifier<List<UserPersonalInfo>>([]);
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: buildAppBar(),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: scrollController,
                reverse: true,
                physics: const BouncingScrollPhysics(),
                child: ValueListenableBuilder(
                  valueListenable: selectedUsersInfo,
                  builder: (context,
                      List<UserPersonalInfo> selectedUsersInfoValue, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selectedUsersInfoValue.isEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3.0, vertical: 17),
                            child: Text(
                              "Select users",
                              style: FlutterFlowTheme.of(context).bodyText2,
                            ),
                          ),
                        ] else ...[
                          ...List.generate(
                            selectedUsersInfoValue.length,
                            (index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 3.0, vertical: 5),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 13.5),
                                  decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).course20,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Text(
                                      selectedUsersInfoValue[index].name,
                                      style: FlutterFlowTheme.of(context).bodyText1.merge(TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        buildBlocBuilder(),
      ]),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      elevation: 0,
      title: Text("New message",
          style: FlutterFlowTheme.of(context).bodyText1),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new,
            size: 25,
            color: FlutterFlowTheme.of(context).primaryText),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        ValueListenableBuilder(
          valueListenable: selectedUsersInfo,
          builder:
              (context, List<UserPersonalInfo> selectedUsersInfoValue, child) =>
                  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
            child: GestureDetector(
              onTap: () {
                if(selectedUsersInfoValue.isNotEmpty)
                  {
                    pushToPage(context,
                        page: GroupMessages(
                            selectedUsersInfoValue: selectedUsersInfoValue));
                  }
              },
              child: Text("Chat",
                  style: FlutterFlowTheme.of(context).bodyText1),
            ),
          ),
        )
      ],
    );
  }

  BlocBuilder<UsersInfoReelTimeBloc, UsersInfoReelTimeState>
      buildBlocBuilder() {
    return BlocBuilder<UsersInfoReelTimeBloc, UsersInfoReelTimeState>(
      bloc: UsersInfoReelTimeBloc.get(context)..add(LoadAllUsersInfoInfo()),
      buildWhen: (previous, current) =>
          previous != current && current is AllUsersInfoLoaded,
      builder: (context, state) {
        if (state is AllUsersInfoLoaded) {
          List<UserPersonalInfo> usersInfo = state.allUsersInfoInReelTime;
          return buildUsers(usersInfo);
        }
        if (state is CubitGettingSpecificUsersFailed) {
          ToastShow.toastStateError(state);
          return Text(FFLocalizations.of(context).getText(StringsManager.somethingWrong));
        } else {
          return isThatMobile
              ? const ThineLinearProgress()
              : const Scaffold(
                  body: SizedBox(height: 1, child: ThineLinearProgress()),
                );
        }
      },
    );
  }

  Padding buildUsers(List<UserPersonalInfo> usersInfo) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 15, start: 15, top: 80.0),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        addAutomaticKeepAlives: false,
        itemBuilder: (context, index) {
          return buildUserInfo(context, usersInfo[index]);
        },
        itemCount: usersInfo.length,
        separatorBuilder: (context, _) => const SizedBox(height: 15),
      ),
    );
  }

  Widget buildUserInfo(BuildContext context, UserPersonalInfo userInfo) {
    return ValueListenableBuilder(
      valueListenable: selectedUsersInfo,
      builder: (context, List<UserPersonalInfo> selectedUsersInfoValue, child) {
        bool isUserSelected = selectedUsersInfoValue.contains(userInfo);
        return GestureDetector(
          onTap: () async {
            if (!isUserSelected) {
              selectedUsersInfo.value.add(userInfo);
            } else {
              selectedUsersInfo.value.remove(userInfo);
            }
            setState(() {});
            scrollController.animateTo(0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutQuart);
          },
          child: Container(
            color: ColorManager.transparent,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: ColorManager.customGrey,
                  backgroundImage: userInfo.profileImageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(userInfo.profileImageUrl,
                          maxWidth: 120, maxHeight: 120)
                      : null,
                  radius: 30,
                  child: userInfo.profileImageUrl.isEmpty
                      ? Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 30,
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
                checkBox(context, isUserSelected),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget checkBox(BuildContext context, bool isUserSelected) {
    return Container(
      padding: const EdgeInsetsDirectional.all(2),
      decoration: BoxDecoration(
        color: !isUserSelected
            ? FlutterFlowTheme.of(context).secondaryText.withOpacity(.5)
            : FlutterFlowTheme.of(context).course20,
        
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: const Center(
        child: Icon(Icons.check_rounded, color: ColorManager.white, size: 17),
      ),
    );
  }
}

class GroupMessages extends StatelessWidget {
  final List<UserPersonalInfo> selectedUsersInfoValue;
  const GroupMessages({Key? key, required this.selectedUsersInfoValue})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SenderInfo messageDetails = SenderInfo(
        receiversInfo: selectedUsersInfoValue, isThatGroupChat: selectedUsersInfoValue.length>1);
    return WillPopScope(
        onWillPop: () async => true,
    child:Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: CustomAppBar.chattingAppBar(selectedUsersInfoValue, context),
      body: BlocProvider<MessageBloc>(
        create: (context) => injector<MessageBloc>(),
        child: ChatMessages(messageDetails: messageDetails),
      ),
    ));
  }
}
