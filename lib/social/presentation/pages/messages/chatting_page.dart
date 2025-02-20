import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/config/routes/app_routes.dart';
import 'package:fc_social_fitness/social/core/functions/toast_show.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/domain/entities/sender_info.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/message/cubit/message_cubit.dart';
import 'package:fc_social_fitness/social/presentation/pages/profile/user_profile_page.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/messages_w/chat_messages.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_app_bar.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';

import '../../../../utils/internationalization.util.dart';

class ChattingPage extends StatefulWidget {
  final SenderInfo? messageDetails;
  final String chatUid;
  final bool isThatGroup;

  const ChattingPage(
      {Key? key,
      this.messageDetails,
      this.chatUid = "",
      this.isThatGroup = false})
      : super(key: key);

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage>
    with TickerProviderStateMixin {
  final ValueNotifier<Message?> deleteThisMessage = ValueNotifier(null);

  final unSend = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return widget.messageDetails != null
        ? scaffold(widget.messageDetails!)
        : getUserInfo(context);
  }

  Widget getUserInfo(BuildContext context) {
    return BlocBuilder<MessageCubit, MessageState>(
      bloc: MessageCubit.get(context)
        ..getSpecificChatInfo(
            isThatGroup: widget.isThatGroup, chatUid: widget.chatUid),
      buildWhen: (previous, current) =>
          previous != current && current is GetSpecificChatLoaded,
      builder: (context, state) {
        if (state is GetSpecificChatLoaded) {
          return scaffold(state.coverMessageDetails);
        } else if (state is GetMessageFailed) {
          ToastShow.toast(state.error);
          return WillPopScope(
              onWillPop: () async => true,
        child: Scaffold(
              body: Center(child: Text(FFLocalizations.of(context).getText(StringsManager.somethingWrong)))));
        } else {
          return const Scaffold(body: ThineCircularProgress());
        }
      },
    );
  }

  Scaffold scaffold(SenderInfo messageDetails) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackgroundAlternate,
      appBar:CustomAppBar.chattingAppBar(messageDetails.receiversInfo!, context),
      body: GestureDetector(
          onTap: () {
            unSend.value = false;
            deleteThisMessage.value = null;
          },
          child: ChatMessages(messageDetails: messageDetails))
    );
  }


  Column buildUserInfo(UserPersonalInfo userInfo) {
    return Column(
      children: [
        circleAvatarOfImage(userInfo),
        const SizedBox(height: 10),
        nameOfUser(userInfo),
        const SizedBox(height: 5),
        userName(userInfo),
        const SizedBox(height: 5),
        someInfoOfUser(userInfo),
        viewProfileButton(userInfo),
      ],
    );
  }

  Widget circleAvatarOfImage(UserPersonalInfo userInfo) {
    return CircleAvatarOfProfileImage(
      bodyHeight: 1000,
      userInfo: userInfo,
      showColorfulCircle: false,
      disablePressed: false,
    );
  }

  Row userName(UserPersonalInfo userInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          userInfo.userName,
          style: FlutterFlowTheme.of(context).bodyText1,
        ),
      ],
    );
  }

  Text nameOfUser(UserPersonalInfo userInfo) {
    return Text(
      userInfo.name,
      style: FlutterFlowTheme.of(context).bodyText1,
    );
  }

  Row someInfoOfUser(UserPersonalInfo userInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${userInfo.followerPeople.length} ${FFLocalizations.of(context).getText(StringsManager.followers)}",
          style: FlutterFlowTheme.of(context).bodyText1,
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          "${userInfo.posts.length} ${FFLocalizations.of(context).getText(StringsManager.posts)}",
          style: FlutterFlowTheme.of(context).bodyText1,
        ),
      ],
    );
  }

  TextButton viewProfileButton(UserPersonalInfo userInfo) {
    return TextButton(
      onPressed: () {
        pushToPage(context, page: UserProfilePage(userId: userInfo.userId));
      },
      child: Text(FFLocalizations.of(context).getText(StringsManager.viewProfile),
          style: FlutterFlowTheme.of(context).bodyText1),
    );
  }
}
