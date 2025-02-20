import 'package:flutter/material.dart';
import 'package:fc_social_fitness/social/core/functions/date_of_now.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/message/cubit/message_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';

class CustomShareButton extends StatefulWidget {
  final Post postInfo;
  final String textOfButton;
  final UserPersonalInfo publisherInfo;
  final TextEditingController messageTextController;
  final List<UserPersonalInfo> selectedUsersInfo;
  final ValueChanged<bool> clearTexts;
  const CustomShareButton({
    Key? key,
    required this.publisherInfo,
    required this.clearTexts,
    required this.textOfButton,
    required this.messageTextController,
    required this.selectedUsersInfo,
    required this.postInfo,
  }) : super(key: key);

  @override
  State<CustomShareButton> createState() => _CustomShareButtonState();
}

class _CustomShareButtonState extends State<CustomShareButton> {
  late UserPersonalInfo myPersonalInfo;
  final isThatLoading = ValueNotifier(false);
  @override
  void initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Builder(builder: (context) {
        MessageCubit messageCubit = MessageCubit.get(context);
        return InkWell(
          onTap: () async {
            isThatLoading.value = true;
            for (final selectedUser in widget.selectedUsersInfo) {
              await messageCubit.sendMessage(
                messageInfo:
                    createSharedMessage(selectedUser),
              );
              if (widget.messageTextController.text.isNotEmpty) {
                await messageCubit.sendMessage(
                    messageInfo: createCaptionMessage(selectedUser));
              }
            }
            // ignore: use_build_context_synchronously
            await Navigator.of(context).maybePop();
            widget.clearTexts(true);
          },
          child: buildDoneButton(),
        );
      }),
    );
  }

  Message createCaptionMessage(UserPersonalInfo userInfoWhoIShared) {
    return Message(
      datePublished: DateOfNow.dateOfNow(),
      message: widget.messageTextController.text,
      senderId: myPersonalId,
      senderInfo: myPersonalInfo,
      receiversIds: [userInfoWhoIShared.userId],
      isThatImage: false,
    );
  }

  Message createSharedMessage(UserPersonalInfo userInfoWhoIShared) {
    bool isThatImage = widget.postInfo.isThatImage;
    String imageUrl = isThatImage
        ? widget.postInfo.imagesUrls.length > 1
            ? widget.postInfo.imagesUrls[0]
            : widget.postInfo.postUrl
        : widget.postInfo.coverOfVideoUrl;
    dynamic userId = userInfoWhoIShared.userId;
    return Message(
      datePublished: DateOfNow.dateOfNow(),
      message: widget.postInfo.caption,
      senderId: myPersonalId,
      senderInfo: myPersonalInfo,
      receiversIds: [userId],
      isThatImage: true,
      isThatVideo: !isThatImage,
      sharedPostId: widget.postInfo.postUid,
      imageUrl: imageUrl,
      isThatPost: true,
      ownerOfSharedPostId: widget.publisherInfo.userId,
      multiImages: widget.postInfo.imagesUrls.length > 1,
    );
  }

  Widget buildDoneButton() {
    return ValueListenableBuilder(
      valueListenable: isThatLoading,
      builder: (context, bool isThatLoadingValue, child) => Container(
        height: 50.0,
        width: double.infinity,
        padding: const EdgeInsetsDirectional.only(start: 17, end: 17),
        decoration: BoxDecoration(
          color:
              isThatLoadingValue ? ColorManager.lightBlue : ColorManager.blue,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: !isThatLoadingValue
              ? Text(
                  widget.textOfButton,
                  style: FlutterFlowTheme.of(context).bodyText1,
                )
              : circularProgress(),
        ),
      ),
    );
  }

  Widget circularProgress() {
    return const Center(
      child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
              color: ColorManager.white, strokeWidth: 2)),
    );
  }
}
