import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/config/routes/app_routes.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/styles_manager.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/domain/entities/calling_status.dart';
import 'package:fc_social_fitness/social/presentation/cubit/callingRooms/calling_rooms_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/pages/messages/video_call_page.dart';

class CallingRingingPage extends StatefulWidget {
  final String channelId;
  final VoidCallback clearMoving;
  const CallingRingingPage(
      {Key? key, required this.channelId, required this.clearMoving})
      : super(key: key);

  @override
  State<CallingRingingPage> createState() => _CallingRingingPageState();
}

class _CallingRingingPageState extends State<CallingRingingPage> {
  bool pop = false;
  @override
  void dispose() {
    widget.clearMoving();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body:  BlocBuilder<CallingRoomsCubit, CallingRoomsState>(
          bloc: CallingRoomsCubit.get(context)
            ..getUsersInfoInThisRoom(channelId: widget.channelId),
          builder: (context, state) {
            if (pop) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => pop = false);
                Navigator.of(context).maybePop();
              });
            }
            if (state is UsersInfoInRoomLoaded) {
              return callingLoadingPage(state.usersInfo);
            } else {
              return waitingText();
            }
          },
        ),
    );
  }

  Future<void> onTapAcceptButton() async {
    UserPersonalInfo myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    await CallingRoomsCubit.get(context).joinToRoom(
        channelId: widget.channelId, myPersonalInfo: myPersonalInfo);
    if (!mounted) return;

    await pushToPage(
      context,
      page: CallPage(
        channelName: widget.channelId,
        role: ClientRoleType.clientRoleBroadcaster,
        userCallingType: UserCallingType.receiver,
      ),
      withoutRoot: false,
    );
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setState(() => pop = true));
  }

  Future<void> onTapCancelButton() async {
    UserPersonalInfo myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    await CallingRoomsCubit.get(context).leaveTheRoom(
      userId: myPersonalInfo.userId,
      channelId: widget.channelId,
      isThatAfterJoining: false,
    );
    if (!mounted) return;
    Navigator.of(context).maybePop();
  }

  Widget waitingText() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Qualcuno ti sta chiamando",
            style: getNormalStyle(color: ColorManager.white),
          ),
          Text(
            "Attendi il caricamento...",
            style: getNormalStyle(color: ColorManager.white),
          ),
        ],
      ),
    );
  }

  Widget callingLoadingPage(List<UsersInfoInCallingRoom> userInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 100),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userInfo[0].profileImageUrl!),
            ),
            const SizedBox(height: 30),
            Text(userInfo[0].name!,
                style: FlutterFlowTheme.of(context).bodyText1),
            const SizedBox(height: 10),
            Text('In chiamata...',
                style:FlutterFlowTheme.of(context).bodyText1),
          ],
        ),
        const Spacer(),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            GestureDetector(
              onTap: onTapCancelButton,
              child: const CircleAvatar(
                radius: 32,
                backgroundColor: ColorManager.red,
                child: Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: 35.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: onTapAcceptButton,
              child: const CircleAvatar(
                radius: 32,
                backgroundColor: ColorManager.green,
                child: Icon(
                  Icons.call,
                  color: Colors.white,
                  size: 35.0,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
