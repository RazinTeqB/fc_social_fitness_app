import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/message/cubit/group_chat/message_for_group_chat_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/message/cubit/message_cubit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/config/routes/app_routes.dart';
import 'package:fc_social_fitness/social/core/functions/date_of_now.dart';
import 'package:fc_social_fitness/social/core/functions/toast_show.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/resources/styles_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/core/utility/injector.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:fc_social_fitness/social/domain/entities/sender_info.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/message/bloc/message_bloc.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/users_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/pages/messages/chatting_page.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_smart_refresh.dart';

import '../../../../../my_app.dart';
import '../../../../../utils/flutter_flow_theme.util.dart';
import '../../../../../utils/internationalization.util.dart';

class ListOfMessages extends StatefulWidget {
  final ValueChanged<UserPersonalInfo>? selectChatting;
  final UserPersonalInfo? additionalUser;
  final bool freezeListView;
  UserPersonalInfo myPersonalInfo;

  ListOfMessages(
      {Key? key,
      this.selectChatting,
      this.freezeListView = false,
      this.additionalUser,
      required this.myPersonalInfo})
      : super(key: key);

  @override
  State<ListOfMessages> createState() => _ListOfMessagesState();
}

class _ListOfMessagesState extends State<ListOfMessages> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> onRefreshData(int index) async {
    await UserInfoCubit.get(context).getUserInfo(myPersonalId);
    setState(() {
      widget.myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    });
    await UsersInfoCubit.get(context)
        .getChatUsersInfo(myPersonalInfo: widget.myPersonalInfo);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      child: CustomSmartRefresh(
          onRefreshData: onRefreshData, child: buildBlocBuilder()),
    );
  }

  BlocBuilder<UsersInfoCubit, UsersInfoState> buildBlocBuilder() {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = isThatMobile
        ? mediaQuery.size.height -
            AppBar().preferredSize.height -
            mediaQuery.padding.top
        : 500;
    return BlocBuilder<UsersInfoCubit, UsersInfoState>(
      bloc: UsersInfoCubit.get(context)
        ..getChatUsersInfo(myPersonalInfo: widget.myPersonalInfo),
      buildWhen: (previous, current) =>
          previous != current && current is CubitGettingChatUsersInfoLoaded,
      builder: (context, state) {
        if (state is CubitGettingChatUsersInfoLoaded) {
          bool isThatUserExist = false;
          if (widget.additionalUser != null) {
            state.usersInfo.where((element) {
              bool check = (element.receiversInfo?[0].userId !=
                      widget.additionalUser?.userId) &&
                  !(element.lastMessage?.isThatGroup ?? true);
              if (!check) isThatUserExist = true;
              return true;
            }).toList();
          }
          List<SenderInfo> usersInfo = state.usersInfo;
          if (!isThatUserExist && widget.additionalUser != null) {
            SenderInfo senderInfo =
                SenderInfo(receiversInfo: [widget.additionalUser!]);
            usersInfo.add(senderInfo);
          }
          if (usersInfo.isEmpty) {
            return Center(
              child: Text(
                  FFLocalizations.of(context).getText(StringsManager.noUsers),
                  style: FlutterFlowTheme.of(context).bodyText1),
            );
          } else {
            return buildListView(usersInfo, bodyHeight);
          }
        } else if (state is CubitGettingSpecificUsersFailed) {
          ToastShow.toastStateError(state);
          return Text(
            StringsManager.somethingWrong,
            style: FlutterFlowTheme.of(context).bodyText1,
          );
        } else {
          return const ThineCircularProgress();
        }
      },
    );
  }

  ListView buildListView(List<SenderInfo> usersInfo, num bodyHeight) {
    bool isThatEnglish = MyApp.of(context).getLocale()?.countryCode == "en";
    return ListView.separated(
        physics: widget.freezeListView
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        primary: !widget.freezeListView,
        shrinkWrap: widget.freezeListView,
        itemCount: usersInfo.length,
        itemBuilder: (context, index) {
          Message? theLastMessage = usersInfo[index].lastMessage;
          bool isThatGroup = usersInfo[index].lastMessage?.isThatGroup ?? false;
          return Slidable(
            // Specify a key if the Slidable is dismissible.
            key: const ValueKey(0),
            // The end action pane is the one at the right or the bottom side.
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async{
                    if (isThatGroup) {
                      onRefreshData(0);
                      await MessageForGroupChatCubit.get(context).deleteChat(messageInfo: usersInfo[index].lastMessage!,chatOfGroupUid:usersInfo[index].lastMessage!.chatOfGroupId);
                    } else {
                      onRefreshData(0);
                      await MessageCubit.get(context).deleteChat(messageInfo: usersInfo[index].lastMessage!);
                    }
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: FontAwesomeIcons.bucket,
                  label: 'Cancella',
                ),
              ],
            ),

            // The child of the Slidable is what the user sees when the
            // component is not dragged.
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GestureDetector(
                onTap: () {
                  if (widget.selectChatting != null) {
                    widget.selectChatting!(usersInfo[index].receiversInfo![0]);
                  } else {
                    pushToPage(context,
                        page: BlocProvider<MessageBloc>(
                          create: (context) => injector<MessageBloc>(),
                          child: ChattingPage(messageDetails: usersInfo[index]),
                        ));
                  }
                },
                child: Row(
                  children: [
                    if (isThatGroup) ...[
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                            top: 15,
                            end: isThatEnglish ? 12 : 3,
                            start: isThatEnglish ? 5 : 15),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: -12,
                              left: -10,
                              child: CircleAvatarOfProfileImage(
                                bodyHeight: bodyHeight * 0.7,
                                userInfo: usersInfo[index].receiversInfo![0],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CircleAvatarOfProfileImage(
                                bodyHeight: bodyHeight * 0.7,
                                userInfo: usersInfo[index].receiversInfo![1],
                              ),
                            ),
                          ],
                        ),
                      )
                    ] else ...[
                      CircleAvatarOfProfileImage(
                        bodyHeight: bodyHeight * 0.85,
                        userInfo: usersInfo[index].receiversInfo![0],
                      ),
                    ],
                    const SizedBox(width: 15),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText(usersInfo, index, context),
                          if (theLastMessage != null) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      theLastMessage.message.isEmpty
                                          ? (theLastMessage.imageUrl.isEmpty
                                              ? FFLocalizations.of(context)
                                                  .getText(StringsManager
                                                      .recordedSent)
                                              : FFLocalizations.of(context)
                                                  .getText(
                                                      StringsManager.photoSent))
                                          : theLastMessage.message,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText2),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                    DateOfNow.commentsDateOfNow(
                                        theLastMessage.datePublished),
                                    style: getNormalStyle(
                                        color: ColorManager.grey)),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 20));
  }

  Text buildText(List<SenderInfo> usersInfo, int index, BuildContext context) {
    bool isThatGroup = usersInfo[index].lastMessage?.isThatGroup ?? false;
    List<UserPersonalInfo> receiverInfo = usersInfo[index].receiversInfo!;
    String text = isThatGroup
        ? "${receiverInfo[0].userName}, ${receiverInfo[1].userName}${receiverInfo.length > 2 ? ", ..." : ""}"
        : receiverInfo[0].userName;
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: FlutterFlowTheme.of(context).bodyText1,
    );
  }
}
