import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fc_social_fitness/social/config/routes/customRoutes/hero_dialog_route.dart';
import 'package:fc_social_fitness/social/core/resources/assets_manager.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/resources/styles_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/time_line_w/send_to_users.dart';

import '../../../../../utils/flutter_flow_theme.util.dart';
import '../../../../../utils/internationalization.util.dart';
import '../../../../../utils/sliding_sheet/src/sheet.dart';
import '../../../../../utils/sliding_sheet/src/specs.dart';

class ShareButton extends StatefulWidget {
  final ValueNotifier<Post> postInfo;
  final Widget? shareWidget;
  final bool isThatForVideoPage;
  const ShareButton(
      {Key? key,
      required this.postInfo,
      this.shareWidget,
      this.isThatForVideoPage = false})
      : super(key: key);

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  final _bottomSheetMessageTextController = TextEditingController();
  final _bottomSheetSearchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return shareButton();
  }

  Widget shareButton() {
    return GestureDetector(
      onTap: () async {
          if (widget.shareWidget != null) {
            await Navigator.of(context).maybePop();
          }
          return await draggableBottomSheet();
      },
      child: widget.shareWidget ??
          Padding(
            padding: EdgeInsetsDirectional.only(
                start: widget.isThatForVideoPage ? 0 : 15.0),
            child: iconsOfImagePost(IconsAssets.send1Icon),
          ),
    );
  }


  SvgPicture iconsOfImagePost(String path) {
    return SvgPicture.asset(
      path,
      color: widget.isThatForVideoPage
          ? ColorManager.white
          : FlutterFlowTheme.of(context).primaryText,
      height: !widget.isThatForVideoPage ? 22 : 25,
    );
  }

  Future<void> draggableBottomSheet() async {
    return showSlidingBottomSheet<void>(
      context,
      builder: (BuildContext context) => SlidingSheetDialog(
        cornerRadius: 16,
        minHeight: 200,
        color: Theme.of(context).splashColor,
        snapSpec: const SnapSpec(
          initialSnap: 1,
          snappings: [.4, 1, .7],
        ),
        builder: buildSheet,
        headerBuilder: (context, state) =>
            Material(child: upperWidgets(context)),
      ),
    );
  }

  Column upperWidgets(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        dashIcon(context),
        Row(
          children: [
            postImage(),
            const SizedBox(width: 12),
            textFieldOfMessage(),
          ],
        ),
        searchBar(context)
      ],
    );
  }

  Padding searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
          top: 40.0, end: 20, start: 20, bottom: 10),
      child: Container(
        width: double.infinity,
        height: 35,
        decoration: BoxDecoration(
            color: Theme.of(context).chipTheme.backgroundColor,
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          cursorColor: ColorManager.teal,
          style: FlutterFlowTheme.of(context).bodyText1,
          controller: _bottomSheetSearchTextController,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                size: 20,
                color: Theme.of(context).textTheme.displayLarge!.color!,
              ),
              contentPadding: const EdgeInsetsDirectional.all(12),
              hintText: FFLocalizations.of(context).getText(StringsManager.search),
              hintStyle: FlutterFlowTheme.of(context).bodyText1,
              border: InputBorder.none),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  Flexible textFieldOfMessage() {
    return Flexible(
      child: TextField(
        controller: _bottomSheetMessageTextController,
        cursorColor: ColorManager.teal,
        style: FlutterFlowTheme.of(context).bodyText1,
        decoration: InputDecoration(
          hintText: FFLocalizations.of(context).getText(StringsManager.writeMessage),
          hintStyle: FlutterFlowTheme.of(context).bodyText2,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Padding postImage() {
    Post postInfo = widget.postInfo.value;
    String postImageUrl = postInfo.imagesUrls.length > 1
        ? postInfo.imagesUrls[0]
        : postInfo.postUrl;
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(
        width: 50,
        height: 45,
        decoration: BoxDecoration(
          color: ColorManager.grey,
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: NetworkImage(
                postInfo.isThatImage ? postImageUrl : postInfo.coverOfVideoUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Padding dashIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 10),
      child: Container(
        width: 45,
        height: 4.5,
        decoration: BoxDecoration(
          color: Theme.of(context).textTheme.headlineMedium!.color,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  clearTextsController(bool clearText) {
    setState(() {
      if (clearText) {
        _bottomSheetMessageTextController.clear();
        _bottomSheetSearchTextController.clear();
      }
    });
  }

  Widget buildSheet(_, __) => Material(
        child: SendToUsers(
          publisherInfo: widget.postInfo.value.publisherInfo!,
          messageTextController: _bottomSheetMessageTextController,
          postInfo: widget.postInfo.value,
          clearTexts: clearTextsController,
          selectedUsersInfo: ValueNotifier<List<UserPersonalInfo>>([]),
        ),
      );
}
