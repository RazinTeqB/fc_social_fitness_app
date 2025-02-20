import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fc_social_fitness/social/config/routes/app_routes.dart';
import 'package:fc_social_fitness/social/core/functions/date_of_now.dart';
import 'package:fc_social_fitness/social/core/functions/toast_show.dart';
import 'package:fc_social_fitness/social/core/resources/assets_manager.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/resources/styles_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/domain/entities/sender_info.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/message/bloc/message_bloc.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/message/cubit/group_chat/message_for_group_chat_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/message/cubit/message_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/pages/profile/user_profile_page.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/messages_w/chat_page_component/shared_message.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/messages_w/record_view.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_linears_progress.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;
import '../../../../../utils/internationalization.util.dart';
import '../../../customPackages/audio_recorder/social_media_recoder.dart'; // import this
import 'package:image/image.dart' as img;

/// It's not clean enough
class ChatMessages extends StatefulWidget {
  final SenderInfo messageDetails;

  const ChatMessages({Key? key, required this.messageDetails})
      : super(key: key);

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages>
    with TickerProviderStateMixin {
  final ValueNotifier<List<Message>> globalMessagesInfo = ValueNotifier([]);
  final ValueNotifier<int?> indexOfGarbageMessage = ValueNotifier(null);
  final ValueNotifier<Message?> deleteThisMessage = ValueNotifier(null);
  final ValueNotifier<Message?> newMessageInfo = ValueNotifier(null);
  final scrollControl = ScrollController();
  final _textController = ValueNotifier(TextEditingController());
  final isDeleteMessageDone = ValueNotifier(false);
  final isMessageLoaded = ValueNotifier(false);
  final appearIcons = ValueNotifier(true);
  final reLoad = ValueNotifier(false);
  late List<UserPersonalInfo> receiversInfo;
  final records = ValueNotifier('');
  late AnimationController _colorAnimationController;
  late Animation _colorTween;
  late UserPersonalInfo myPersonalInfo;
  String senderIdForGroup = "";
  String profileImageOfSender = "";
  int itemIndex = 0;
  String senderIdForProfileImage = "";
  AudioPlayer audioPlayer = AudioPlayer();
  int tempLengthOfRecord = 0;

  Future<void> scrollToLastIndex(BuildContext context) async {
    await scrollControl.animateTo(scrollControl.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.easeInOutQuart);
  }

  @override
  void initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    _colorAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _colorTween = ColorTween(begin: Colors.purple, end: Colors.blue)
        .animate(_colorAnimationController);
    receiversInfo = widget.messageDetails.receiversInfo ?? [myPersonalInfo];
    super.initState();
  }

  @override
  void didUpdateWidget(ChatMessages oldWidget) {
    if (widget.messageDetails != oldWidget.messageDetails) {
      newMessageInfo.value = null;
      globalMessagesInfo.value = [];
      isMessageLoaded.value = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool check = (widget.messageDetails.lastMessage?.isThatGroup) ?? false;
    return GestureDetector(onTap:(){
      FocusScope.of(context).unfocus();
    },child:widget.messageDetails.isThatGroupChat || check
        ? buildGroupChat(context)
        : buildSingleChat(context));
  }

  Widget buildGroupChat(BuildContext context) {
    if (widget.messageDetails.lastMessage == null ||
        widget.messageDetails.lastMessage!.chatOfGroupId.isEmpty) {
      return buildMessages(context, []);
    } else {
      return ValueListenableBuilder(
        valueListenable: reLoad,
        builder: (context, bool reLoadValue, child) =>
            BlocBuilder<MessageBloc, MessageBlocState>(
          bloc: BlocProvider.of<MessageBloc>(context)
            ..add(LoadMessagesForGroupChat(
                groupChatUid:
                    widget.messageDetails.lastMessage!.chatOfGroupId)),
          builder: (context, state) {
            if (state is MessageBlocLoaded) {
              return buildMessages(context, state.messages);
            } else {
              return isThatMobile
                  ? buildCircularProgress()
                  : const ThineLinearProgress();
            }
          },
        ),
      );
    }
  }

  Widget buildSingleChat(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: reLoad,
      builder: (context, bool reLoadValue, child) =>
          BlocBuilder<MessageBloc, MessageBlocState>(
        bloc: BlocProvider.of<MessageBloc>(context)
          ..add(LoadMessagesForSingleChat(receiversInfo[0].userId)),
        builder: (context, state) {
          if (state is MessageBlocLoaded) {
            return buildMessages(context, state.messages);
          } else {
            return buildCircularProgress();
          }
        },
      ),
    );
  }

  Widget buildMessages(BuildContext context, List<Message> messages) {
    return ValueListenableBuilder(
      valueListenable: newMessageInfo,
      builder: (context, Message? newMessageValue, child) =>
          ValueListenableBuilder(
        valueListenable: globalMessagesInfo,
        builder: (context, List<Message> globalMessagesValue, child) =>
            ValueListenableBuilder(
          valueListenable: isMessageLoaded,
          builder: (context, bool isMessageLoadedValue, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (messages.length >= globalMessagesValue.length) {
                globalMessagesInfo.value = messages;
                if (itemIndex < globalMessagesValue.length - 1 &&
                    isThatMobile) {
                  itemIndex = globalMessagesValue.length - 1;
                  scrollToLastIndex(context);
                }
              }
              if (newMessageValue != null && isMessageLoadedValue) {
                isMessageLoaded.value = false;
                globalMessagesInfo.value.add(newMessageValue);
              }
            });
            return whichListOfMessages(globalMessagesValue, context);
          },
        ),
      ),
    );
  }

  whichListOfMessages(List<Message> globalMessagesValue, BuildContext context) {
    return buildMassagesForMobile(globalMessagesValue, context);
  }

  Widget buildMassagesForMobile(
      List<Message> globalMessagesValue, BuildContext context) {
    return Stack(
      children: [
        Padding(
            padding: const EdgeInsetsDirectional.only(
                end: 10, start: 10, top: 10, bottom: 40),
            child: globalMessagesValue.isNotEmpty
                ? notificationListenerForMobile(globalMessagesValue)
                : buildUserInfo(context)),
        Align(
            alignment: Alignment.bottomCenter,
            child: textForm()),
      ],
    );
  }

  Widget notificationListenerForMobile(List<Message> globalMessagesValue) {
    return ListView.separated(
        controller: scrollControl,
        itemBuilder: (context, index) {
          int indexForMobile = index != 0 ? index - 1 : 0;
          return Column(
            children: [
              if (index == 0) buildUserInfo(context),
              buildTheMessage(globalMessagesValue,
                  globalMessagesValue[indexForMobile].datePublished, index),
              if (index == globalMessagesValue.length - 1)
                const SizedBox(height: 50),
            ],
          );
        },
        itemCount: globalMessagesValue.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 5));
  }

  Widget buildCircularProgress() => const ThineCircularProgress();

  Column buildUserInfo(BuildContext context) {
    return Column(
      children: [
        circleAvatarOfImage(),
        const SizedBox(height: 10),
        nameOfUser(),
        if (receiversInfo.length == 1) ...[
          const SizedBox(height: 5),
          userName(),
          //const SizedBox(height: 5),
          //someInfoOfUser(),
          viewProfileButton(context),
        ],
      ],
    );
  }

  Widget buildTheMessage(
      List<Message> messagesInfo, String previousDateOfMessage, int index) {
    Message messageInfo = messagesInfo[index];
    bool isThatMe = false;
    bool createProfileImage = false;

    if (messageInfo.senderId == myPersonalId) isThatMe = true;
    bool checkForSenderNameInGroup;

    if (!isThatMe && senderIdForGroup != messageInfo.senderId) {
      senderIdForGroup = messageInfo.senderId;
      checkForSenderNameInGroup = true;
    } else {
      checkForSenderNameInGroup = false;
    }
    if (senderIdForProfileImage.isEmpty && !isThatMe) {
      senderIdForProfileImage = messageInfo.senderId;
    }
    int i = index + 1 < messagesInfo.length ? index + 1 : index;
    if (!isThatMe && messagesInfo[i].senderId != senderIdForProfileImage) {
      senderIdForProfileImage = messagesInfo[i].senderId;
      createProfileImage = true;
    }
    if (index == messagesInfo.length - 1) {
      senderIdForProfileImage = messagesInfo[i].senderId;
      createProfileImage = true;
    }
    String theDate = DateOfNow.chattingDateOfNow(
        messageInfo.datePublished, previousDateOfMessage);
    bool isLangArabic = false;
    return Column(
      children: [
        if (theDate.isNotEmpty)
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 15, top: 15),
              child: Text(
                theDate,
                style: FlutterFlowTheme.of(context).bodyText2,
              ),
            ),
          ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isThatMe) ...[
              buildProfileImage(
                  createProfileImage && senderIdForProfileImage.isNotEmpty),
            ],
            const SizedBox(width: 10),
            if (isThatMe) const SizedBox(width: 100),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: newMessageInfo,
                  builder: (context, Message? newMessageInfoValue, child) =>
                      Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (checkForSenderNameInGroup) ...[
                        senderNameText(context, messageInfo),
                        const SizedBox(height: 5),
                      ],
                      buildMessageForMobile(isThatMe, messageInfo)
                    ],
                  ),
                ),
            ),
            if (!isThatMe) const SizedBox(width: 85),
            if (!isLangArabic) ...[buildVisibility(messageInfo, false)],
          ],
        ),
      ],
    );
  }

  Visibility buildVisibility(Message messageInfo, bool rotateIcon) {
    return Visibility(
      visible: messageInfo.senderId == myPersonalId &&
          messageInfo.messageUid.isEmpty,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 5.0),
        child: rotateIcon
            ? Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: sendIcon(),
              )
            : sendIcon(),
      ),
    );
  }

  SvgPicture sendIcon() {
    return SvgPicture.asset(
      IconsAssets.send2Icon,
      height: 25,
      color: FlutterFlowTheme.of(context).primaryText,
    );
  }

  Visibility buildProfileImage(bool createProfileImage) {
    int indexOfUserInfo = 0;
    if (createProfileImage) {
      indexOfUserInfo = widget.messageDetails.receiversIds
              ?.indexOf(senderIdForProfileImage) ??
          0;
      indexOfUserInfo = indexOfUserInfo == -1 ? 0 : indexOfUserInfo;
    }
    return Visibility(
      visible: createProfileImage,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: CircleAvatarOfProfileImage(
        bodyHeight: 350,
        userInfo: receiversInfo[indexOfUserInfo],
        showColorfulCircle: false,
      ),
    );
  }

  BlocBuilder<UserInfoCubit, UserInfoState> senderNameText(
      BuildContext context, Message messageInfo) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      buildWhen: (previous, current) =>
          previous != current && current is CubitUserLoaded,
      bloc: UserInfoCubit.get(context)
        ..getUserInfo(messageInfo.senderId, isThatMyPersonalId: false),
      builder: (context, state) {
        UserPersonalInfo? userInfo;
        if (state is CubitUserLoaded) userInfo = state.userPersonalInfo;
        return Text(userInfo?.name ?? "",
            style: FlutterFlowTheme.of(context).bodyText1);
      },
    );
  }

  Align buildMessageForMobile(bool isThatMe, Message messageInfo) {
    String message = messageInfo.message;
    String imageUrl = messageInfo.imageUrl;
    String recordedUrl = messageInfo.recordedUrl;
    Widget messageWidget =
        messageInfo.isThatRecord || messageInfo.recordedUrl.isNotEmpty
            ? recordMessage(messageInfo.lengthOfRecord, recordedUrl, isThatMe)
            : (messageInfo.isThatPost
                ? SharedMessage(
                    messageInfo: messageInfo,
                    isThatMe: isThatMe,
                  )
                : (messageInfo.isThatImage
                    ? imageMessage(messageInfo, imageUrl)
                    : textMessage(message, isThatMe)));

    return Align(
      alignment: isThatMe
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: AnimatedBuilder(
          animation: _colorAnimationController,
          builder: (_, __) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: messageInfo.isThatPost
                      ? FlutterFlowTheme.of(context)
                          .secondaryBackgroundAlternate
                      : (isThatMe
                          ? FlutterFlowTheme.of(context).primaryBackground
                          : FlutterFlowTheme.of(context)
                              .secondaryBackgroundAlternate),

                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                padding: !messageInfo.isThatImage
                    ? const EdgeInsetsDirectional.only(
                        start: 10, end: 10, bottom: 8, top: 8)
                    : const EdgeInsetsDirectional.all(0),
                child: messageWidget,
              )),
    );
  }

  Container buildMessage(
      bool isThatMe, Message messageInfo, Widget messageWidget) {
    return Container(
      decoration: BoxDecoration(
        color: isThatMe
            ? FlutterFlowTheme.of(context).secondaryBackgroundAlternate
            : FlutterFlowTheme.of(context).secondaryBackgroundAlternate,
        borderRadius: const BorderRadiusDirectional.all(Radius.circular(25)),
        /*border:
            isThatMe ? null : Border.all(color: ColorManager.lowOpacityGrey),*/
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      padding: !messageInfo.isThatImage
          ? const EdgeInsets.symmetric(vertical: 15, horizontal: 25)
          : const EdgeInsetsDirectional.all(0),
      child: messageWidget,
    );
  }

  ValueListenableBuilder<String> recordMessage(
      int lengthOfRecord, String recordedUrl, bool isThatMe) {
    return ValueListenableBuilder(
      valueListenable: records,
      builder: (context, String recordsValue, child) => SizedBox(
        width: isThatMobile ? 500 : 240,
        child: RecordView(
          urlRecord: recordedUrl.isEmpty ? recordsValue : recordedUrl,
          isThatLocalRecorded: recordedUrl.isEmpty,
          lengthOfRecord:
              recordedUrl.isEmpty ? tempLengthOfRecord : lengthOfRecord,
          isThatMe: isThatMe,
        ),
      ),
    );
  }

  SizedBox imageMessage(Message messageInfo, String imageUrl) {
    return SizedBox(
      height: 300,
      width: 210,
      child: NetworkDisplay(
        isThatImage: messageInfo.isThatImage,
        url: imageUrl,
      ),
    );
  }

  Text textMessage(String message, bool isThatMe) {
    TextStyle style = isThatMe
        ? FlutterFlowTheme.of(context).bodyText1
        : FlutterFlowTheme.of(context).bodyText1;
    style = isThatMobile
        ? FlutterFlowTheme.of(context).bodyText1
        : FlutterFlowTheme.of(context).bodyText1;
    return Text(message, style: style);
  }


  Widget textForm() => Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(0)),
              height: 80,
              padding: EdgeInsetsDirectional.only(
                  start: 15, end: 15, bottom: 0),
              margin: const EdgeInsetsDirectional.only(start: 0, end: 0),
              child: Builder(builder: (context) {
                MessageCubit messageCubit = MessageCubit.get(context);
                MessageForGroupChatCubit messageForGroupChatCubit =
                    MessageForGroupChatCubit.get(context);
                return rowOfTextField(messageCubit, messageForGroupChatCubit);
              }),
            ),
          ),
        ],
      );

  Future<void> showIcons(bool show) async {
    if (show) {
      await Future.delayed(const Duration(milliseconds: 500), () {});
    }
    appearIcons.value = show;
  }

  Widget rowOfTextField(MessageCubit messageCubit,
      MessageForGroupChatCubit messageForGroupChatCubit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        pickImageFromCamera(messageCubit, messageForGroupChatCubit),
        messageTextField(),
        ValueListenableBuilder(
          valueListenable: _textController,
          builder: (context, TextEditingController textValue, child) {
            if (textValue.text.isNotEmpty) {
              return sendButton(
                  messageCubit, textValue, messageForGroupChatCubit);
            } else {
             return Row(children: [
               ValueListenableBuilder(
                valueListenable: appearIcons,
                builder: (context, bool appearIconsValue, child) => Visibility(
                  visible: true,
                  child: Row(
                    children: [
                      SocialMediaRecorder(
                        showIcons: showIcons,
                        slideToCancelText: FFLocalizations.of(context)
                            .getText(StringsManager.slideToCancel),
                        cancelText: FFLocalizations.of(context)
                            .getText(StringsManager.cancel),
                        sendRequestFunction:
                            (File soundFile, int lengthOfRecordInSecond) async {
                          tempLengthOfRecord = lengthOfRecordInSecond * 1000000;
                          records.value = soundFile.path;
                          isMessageLoaded.value = true;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {});
                          });
                          if (widget.messageDetails.isThatGroupChat ||
                              widget.messageDetails.lastMessage!.isThatGroup) {
                            newMessageInfo.value =
                                newMessageForGroup(isThatRecord: true);
                            if (!mounted) return;
                            await MessageForGroupChatCubit.get(context)
                                .sendMessage(
                                    messageInfo:
                                        newMessageForGroup(isThatRecord: true),
                                    recordFile: soundFile);
                            if (!mounted) return;
                            bool check = widget.messageDetails.lastMessage
                                    ?.chatOfGroupId.isEmpty ??
                                true;
                            if (check) {
                              Message lastMessage =
                                  MessageForGroupChatCubit.getLastMessage(
                                      context);
                              widget.messageDetails.lastMessage = lastMessage;
                            }
                          } else {
                            newMessageInfo.value =
                                newMessage(isThatRecord: true);

                            await messageCubit.sendMessage(
                                messageInfo: newMessage(isThatRecord: true),
                                recordFile: soundFile);
                          }
                          newMessageInfo.value = null;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {});
                          });

                          if (!mounted) return;
                          scrollToLastIndex(context);
                          records.value = "";
                          tempLengthOfRecord = 0;
                        },
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                ),
              ),
            ValueListenableBuilder(
            valueListenable: appearIcons,
            builder: (context, bool appearIconsValue, child) =>
                Visibility(child: pickPhoto(messageCubit, messageForGroupChatCubit),visible: appearIconsValue,))
              ],);
            }
          },
        )
      ],
    );
  }

  Widget pickImageFromCamera(MessageCubit messageCubit,
      MessageForGroupChatCubit messageForGroupChatCubit) {
    return ValueListenableBuilder(
      valueListenable: appearIcons,
      builder: (context, bool appearIconsValue, child) => Visibility(
        visible: appearIconsValue,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(end: 10.0),
          child: GestureDetector(
            onTap: () async {
              final XFile? photo = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 100, requestFullMetadata: true);
              if (photo != null) {
                //File? pickImage = File(photo.path);
                final img.Image capturedImage = img.decodeImage(await File(photo.path).readAsBytes())!;
                final img.Image orientedImage = img.bakeOrientation(capturedImage);
                File? pickImage = await File(photo.path).writeAsBytes(img.encodeJpg(orientedImage));

                Uint8List byte = pickImage.readAsBytesSync();
                isMessageLoaded.value = true;
                if(widget.messageDetails.lastMessage!=null)
                  {
                    if (widget.messageDetails.isThatGroupChat ||
                        widget.messageDetails.lastMessage!.isThatGroup) {
                      newMessageInfo.value = newMessageForGroup(isThatImage: true);
                      newMessageInfo.value!.localImage = byte;
                      await messageForGroupChatCubit.sendMessage(
                          messageInfo: newMessageForGroup(isThatImage: true),
                          pathOfPhoto: pickImage);
                      if (!mounted) return;
                      bool check = widget
                          .messageDetails.lastMessage?.chatOfGroupId.isEmpty ??
                          true;
                      if (check) {
                        Message lastMessage =
                        MessageForGroupChatCubit.getLastMessage(context);
                        widget.messageDetails.lastMessage = lastMessage;
                      }
                    } else {
                      newMessageInfo.value = newMessage(isThatImage: true);
                      newMessageInfo.value!.localImage = byte;
                      messageCubit.sendMessage(
                          messageInfo: newMessage(isThatImage: true),
                          pathOfPhoto: pickImage);
                    }
                  }else{
                  if (widget.messageDetails.isThatGroupChat) {
                    newMessageInfo.value = newMessageForGroup(isThatImage: true);
                    newMessageInfo.value!.localImage = byte;
                    await messageForGroupChatCubit.sendMessage(
                        messageInfo: newMessageForGroup(isThatImage: true),
                        pathOfPhoto: pickImage);
                    if (!mounted) return;
                    bool check = widget
                        .messageDetails.lastMessage?.chatOfGroupId.isEmpty ??
                        true;
                    if (check) {
                      Message lastMessage = MessageForGroupChatCubit.getLastMessage(context);
                      widget.messageDetails.lastMessage = lastMessage;
                    }
                  } else {
                    newMessageInfo.value = newMessage(isThatImage: true);
                    newMessageInfo.value!.localImage = byte;
                    messageCubit.sendMessage(
                        messageInfo: newMessage(isThatImage: true),
                        pathOfPhoto: pickImage);
                    print("non gruppo uno");
                  }
                }

                if (!mounted) return;
                WidgetsBinding.instance.addPostFrameCallback((_)async {
                  scrollToLastIndex(context);
                });
              } else {
                ToastShow.toast(FFLocalizations.of(context)
                    .getText(StringsManager.noImageSelected));
              }
            },
            child: CircleAvatar(
              backgroundColor: FlutterFlowTheme.of(context).course20,
              radius: 20,
              child: const ClipOval(
                clipBehavior: Clip.none,
                child: Icon(
                  Icons.camera_alt,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget messageTextField() {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: appearIcons,
        builder: (context, bool appearIconsValue, child) => Visibility(
          child: ValueListenableBuilder(
            valueListenable: _textController,
            builder: (context, TextEditingController textValue, child) =>
                TextFormField(
              style: FlutterFlowTheme.of(context).bodyText1,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              cursorColor: FlutterFlowTheme.of(context).course20,
              maxLines: null,
              decoration: InputDecoration.collapsed(
                  hintText: FFLocalizations.of(context)
                      .getText(StringsManager.messageP),
                  hintStyle: FlutterFlowTheme.of(context).bodyText2),
              autofocus: false,
              onChanged: (text){
                setState(() {

                });
              },
              controller: textValue,
              cursorWidth: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget sendButton(MessageCubit messageCubit, TextEditingController textValue,
      MessageForGroupChatCubit messageForGroupChatCubit) {
    return ValueListenableBuilder(
      valueListenable: appearIcons,
      builder: (context, bool appearIconsValue, child) => Visibility(
        visible: true,
        child: GestureDetector(
          onTap: () async {
            if (_textController.value.text.isNotEmpty) {
              if (widget.messageDetails.lastMessage != null) {
                if (widget.messageDetails.isThatGroupChat ||
                    widget.messageDetails.lastMessage!.isThatGroup) {
                  await MessageForGroupChatCubit.get(context)
                      .sendMessage(messageInfo: newMessageForGroup());
                  if (!mounted) return;
                  bool check = widget
                          .messageDetails.lastMessage?.chatOfGroupId.isEmpty ??
                      true;
                  if (check) {
                    Message lastMessage =
                        MessageForGroupChatCubit.getLastMessage(context);
                    widget.messageDetails.lastMessage = lastMessage;
                  }
                } else {
                  messageCubit.sendMessage(messageInfo: newMessage());
                }
              } else {
                if (widget.messageDetails.isThatGroupChat) {
                  await MessageForGroupChatCubit.get(context)
                      .sendMessage(messageInfo: newMessageForGroup());
                  if (!mounted) return;
                  bool check = widget
                          .messageDetails.lastMessage?.chatOfGroupId.isEmpty ??
                      true;
                  if (check) {
                    setState(() {
                      Message lastMessage =
                          MessageForGroupChatCubit.getLastMessage(context);
                      widget.messageDetails.lastMessage = lastMessage;
                    });
                  }
                } else {
                  messageCubit.sendMessage(messageInfo: newMessage());
                }
              }
              if (!mounted) return;
              WidgetsBinding.instance.addPostFrameCallback((_)async {
                scrollToLastIndex(context);
              });
              _textController.value.text = "";
            }
          },
          child: Text(
            FFLocalizations.of(context).getText(StringsManager.send),
            style: getMediumStyle(
              color: textValue.text.isNotEmpty
                  ? const Color.fromARGB(255, 33, 150, 243)
                  : const Color.fromARGB(255, 147, 198, 246),
            ),
          ),
        ),
      ),
    );
  }

  Widget pickSticker() {
    return GestureDetector(
      child: SvgPicture.asset(
        "assets/icons/sticker.svg",
        height: 25,
        color: FlutterFlowTheme.of(context).primaryText,
      ),
    );
  }
  Future<File?> copyAsset() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File tempFile = File('$tempPath/copy.png');
    ByteData bd = await rootBundle.load('assets/images/image.png');
    await tempFile.writeAsBytes(bd.buffer.asUint8List(), flush: true);
    return tempFile;
  }
  Widget pickPhoto(MessageCubit messageCubit,
      MessageForGroupChatCubit messageForGroupChatCubit) {
    return GestureDetector(
      onTap: () async {
        final XFile? photo = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (photo != null) {
          //File pickImage = File(photo.path);
          final img.Image capturedImage = img.decodeImage(await File(photo.path).readAsBytes())!;
          final img.Image orientedImage = img.bakeOrientation(capturedImage);
          File? pickImage = await File(photo.path).writeAsBytes(img.encodeJpg(orientedImage));
          Uint8List byte = pickImage.readAsBytesSync();
          isMessageLoaded.value = true;
          if(widget.messageDetails.lastMessage!=null)
            {
              if (widget.messageDetails.isThatGroupChat ||
                  widget.messageDetails.lastMessage!.isThatGroup) {
                newMessageInfo.value = newMessageForGroup(isThatImage: true);
                newMessageInfo.value!.localImage = byte;
                await messageForGroupChatCubit.sendMessage(
                    messageInfo: newMessageForGroup(isThatImage: true),
                    pathOfPhoto: pickImage);
                if (!mounted) return;
                bool check = widget
                    .messageDetails.lastMessage?.chatOfGroupId.isEmpty ??
                    true;
                if (check) {
                  Message lastMessage =
                  MessageForGroupChatCubit.getLastMessage(context);
                  widget.messageDetails.lastMessage = lastMessage;
                }
              } else {
                newMessageInfo.value = newMessage(isThatImage: true);
                newMessageInfo.value!.localImage = byte;
                messageCubit.sendMessage(
                    messageInfo: newMessage(isThatImage: true),
                    pathOfPhoto: pickImage);
              }
            }else{
            if (widget.messageDetails.isThatGroupChat) {
              newMessageInfo.value = newMessageForGroup(isThatImage: true);
              newMessageInfo.value!.localImage = byte;
              await messageForGroupChatCubit.sendMessage(
                  messageInfo: newMessageForGroup(isThatImage: true),
                  pathOfPhoto: pickImage);
              if (!mounted) return;
              bool check = widget.messageDetails.lastMessage?.chatOfGroupId.isEmpty ??
                  true;
              if (check) {
                Message lastMessage =
                MessageForGroupChatCubit.getLastMessage(context);
                widget.messageDetails.lastMessage = lastMessage;
              }
            } else {
              newMessageInfo.value = newMessage(isThatImage: true);
              newMessageInfo.value!.localImage = byte;
              messageCubit.sendMessage(
                  messageInfo: newMessage(isThatImage: true),
                  pathOfPhoto: pickImage);
            }
          }

          if (!mounted) return;
          WidgetsBinding.instance.addPostFrameCallback((_)async {
            scrollToLastIndex(context);
          });
        } else {
          ToastShow.toast(FFLocalizations.of(context)
              .getText(StringsManager.noImageSelected));
        }
      },
      child: SvgPicture.asset(
        isThatMobile ? IconsAssets.gallery : IconsAssets.galleryBold,
        height: isThatMobile ? 25 : 25,
        color: FlutterFlowTheme.of(context).primaryText,
      ),
    );
  }

  Message newMessageForGroup(
      {bool isThatImage = false, bool isThatRecord = false}) {
    List<dynamic> usersIds = [];
    for (final userInfo in receiversInfo) {
      usersIds.add(userInfo.userId);
    }
    return Message(
      datePublished: DateOfNow.dateOfNow(),
      message: _textController.value.text,
      senderId: myPersonalId,
      senderInfo: myPersonalInfo,
      receiversIds: usersIds,
      isThatImage: isThatImage,
      isThatRecord: isThatRecord,
      lengthOfRecord: tempLengthOfRecord,
      isThatGroup: true,
      chatOfGroupId: widget.messageDetails.lastMessage?.chatOfGroupId ?? "",
    );
  }

  Message newMessage(
      {String blurHash = "",
      bool isThatImage = false,
      bool isThatRecord = false}) {
    dynamic userId = receiversInfo[0].userId;
    return Message(
      datePublished: DateOfNow.dateOfNow(),
      message: _textController.value.text,
      senderId: myPersonalId,
      senderInfo: myPersonalInfo,
      lengthOfRecord: tempLengthOfRecord,
      isThatRecord: isThatRecord,
      receiversIds: [userId],
      isThatImage: isThatImage,
    );
  }

  Widget circleAvatarOfImage() {
    bool check = widget.messageDetails.lastMessage?.isThatGroup ?? false;
    if (widget.messageDetails.isThatGroupChat || check) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 115,
              top: -18,
              child: CircleAvatarOfProfileImage(
                bodyHeight: 700,
                userInfo: receiversInfo[1],
                showColorfulCircle: false,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CircleAvatarOfProfileImage(
                bodyHeight: 700,
                userInfo: receiversInfo[0],
                showColorfulCircle: false,
              ),
            ),
          ],
        ),
      );
    } else {
      return CircleAvatarOfProfileImage(
          userInfo: receiversInfo[0],
          bodyHeight: 950,
          showColorfulCircle: false);
    }
  }

  Row userName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          receiversInfo[0].userName,
          style: FlutterFlowTheme.of(context).bodyText1,
        ),
      ],
    );
  }

  Widget nameOfUser() {
    int length = receiversInfo.length;
    length = length >= 3 ? 3 : length;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            length,
            (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Text(
                  index == 2
                      ? "....."
                      : "${receiversInfo[index].name}${length > 1 ? ',' : ""}",
                  style: FlutterFlowTheme.of(context).bodyText1,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Row someInfoOfUser() {
    UserPersonalInfo userInfo = receiversInfo[0];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${userInfo.followerPeople.length} ${FFLocalizations.of(context).getText(StringsManager.followers)}",
          style: FlutterFlowTheme.of(context).bodyText1,
        ),
        const SizedBox(width: 15),
        Text(
            "${userInfo.posts.length} ${FFLocalizations.of(context).getText(StringsManager.posts)}",
            style: FlutterFlowTheme.of(context).bodyText1),
      ],
    );
  }

  TextButton viewProfileButton(BuildContext context) {
    dynamic userId = receiversInfo[0].userId;

    return TextButton(
      onPressed: () {
        pushToPage(context, page: UserProfilePage(userId: userId));
      },
      child: Text(
        FFLocalizations.of(context).getText(StringsManager.viewProfile),
        style: FlutterFlowTheme.of(context).bodyText2,
      ),
    );
  }
}
