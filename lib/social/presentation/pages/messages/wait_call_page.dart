import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/presentation/cubit/callingRooms/bloc/calling_status_bloc.dart';
import 'package:fc_social_fitness/social/presentation/pages/messages/video_call_page.dart';
import 'package:fc_social_fitness/social/presentation/cubit/callingRooms/calling_rooms_cubit.dart';

import '../../../../utils/flutter_flow_theme.util.dart';

class VideoCallPage extends StatelessWidget {
  final List<UserPersonalInfo> usersInfo;
  final UserPersonalInfo myPersonalInfo;

  const VideoCallPage({
    Key? key,
    required this.usersInfo,
    required this.myPersonalInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorManager.lowOpacityGrey,
      body: BlocBuilder<CallingRoomsCubit, CallingRoomsState>(
          buildWhen: (previous, current) =>
              previous != current && current is CallingRoomsLoaded,
          bloc: CallingRoomsCubit.get(context)
            ..createCallingRoom(
                myPersonalInfo: myPersonalInfo, callThoseUsersInfo: usersInfo),
          builder: (callingRoomContext, callingRoomState) {
            if (callingRoomState is CallingRoomsLoaded) {
              return callingRoomsLoaded(callingRoomState, callingRoomContext);
            } else if (callingRoomState is CallingRoomsFailed) {
              return whichFailedText(callingRoomState, callingRoomContext);
            } else {
              return callingLoadingPage(context);
            }
          },
        ),

    );
  }

  Widget callingRoomsLoaded(CallingRoomsLoaded roomsState, BuildContext context) {
    return BlocBuilder<CallingStatusBloc, CallingStatusState>(
      bloc: CallingStatusBloc.get(context)..add(LoadCallingStatus(roomsState.channelId)),
      builder: (context, callingStatusState) {
        bool isAllUsersCanceled = callingStatusState is CallingStatusLoaded &&
            callingStatusState.callingStatus == false;

        bool isThereAnyProblem = callingStatusState is CallingStatusFailed;

        if (isAllUsersCanceled || isThereAnyProblem) {
          return canceledText(roomsState, context);
        } else {
          return callPage(roomsState);
        }
      },
    );
  }

  Widget callPage(CallingRoomsLoaded roomsState) {
    return CallPage(
      channelName: roomsState.channelId,
      role: ClientRoleType.clientRoleBroadcaster,
      userCallingType: UserCallingType.sender,
      usersInfo: usersInfo,
    );
  }

  Widget canceledText(CallingRoomsLoaded roomsState, BuildContext context) {
    List<dynamic> usersIds = [];
    usersInfo.where((element) {
      usersIds.add(element.userId);
      return true;
    }).toList();
    CallingRoomsCubit.get(context)
        .deleteTheRoom(channelId: roomsState.channelId, usersIds: usersIds);
    Navigator.of(context).maybePop();

     WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2)).then((value) {
      });
    });
    return const Center(
        child: Text("Cancellata...",
            style: TextStyle(fontSize: 20, color: Colors.black87)));
  }

  Widget whichFailedText(CallingRoomsFailed state, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1)).then((value) {
        Navigator.of(context).maybePop();
      });
    });
    if (state.error == "Busy") {
      String message = usersInfo.length > 1
          ? "They are all busy..."
          : '${usersInfo[0].name} is Busy...';
      return Center(child: Text(message));
    } else {
      return const Center(child: Text("Call ended..."));
    }
  }

  Widget callingLoadingPage(BuildContext context) {
    return Center(
      child: Text("Connessione...",
          style: FlutterFlowTheme.of(context).bodyText1),
    );
  }
}
