import 'dart:io';
import 'dart:typed_data';
import 'package:fc_social_fitness/utils/flutter_flow_icon_button.dart';
import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:fc_social_fitness/views/home.page.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/core/functions/date_of_now.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/resources/styles_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/core/utility/injector.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/register_w/popup_calling.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:mime/mime.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../utils/internationalization.util.dart';
import '../../widgets/global/custom_widgets/custom_gallery_display.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  bool isSwitched = false;
  final isItDone = ValueNotifier(true);
  late File? selectedFile;

  TextEditingController captionController = TextEditingController(text: "");
  late UserPersonalInfo myPersonalInfo;
  bool isThatImage = false;
  late Map<Uint8List, bool> selectedByte = {};

  File? firstImage;

  @override
  void initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 40,right: 10),
      child: BlocProvider<PostCubit>(
        create: (context) => injector<PostCubit>(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          floatingActionButton: Container(
            padding: EdgeInsets.only(bottom: 50),
            child: FloatingActionButton(
              foregroundColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              elevation: 2,
              onPressed: null,
              backgroundColor: FlutterFlowTheme.of(context).course20,
              child: ValueListenableBuilder(
                valueListenable: isItDone,
                builder: (context, bool isItDoneValue, child) => !isItDoneValue
                    ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                      )
                    : IconButton(
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        color: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: () async {
                          if (firstImage != null) {
                            createPost(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                content: Text(
                                    "Per creare un post devi prima selezionare un immagine.",
                                    style:
                                        FlutterFlowTheme.of(context).bodyText1)));
                          }
                        },
                        icon: Icon(
                          Icons.check_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  height: 100),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 10.0, end: 10, top: 10),
                child: Row(
                  children: [
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              File? filePicked =
                                  await CustomImagePickerPlus.pickBoth(context);
                              if (filePicked != null) {
                                setState(() {
                                  selectedFile = filePicked;
                                  String? mimeType =
                                      lookupMimeType(filePicked.path);
                                  selectedByte[filePicked.readAsBytesSync()] =
                                      mimeType!.startsWith('image/');
                                  isThatImage = mimeType.startsWith('image/');
                                  firstImage = filePicked;
                                });
                              } else {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            "Nessuna immagine selezionata",
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1
                                                .merge(TextStyle(
                                                    color: Colors.white)))));
                              }
                            },
                            child: isThatImage
                                ? Image.file(firstImage!)
                                : Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.slow_motion_video_sharp,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: captionController,
                        cursorColor: ColorManager.teal,
                        style: FlutterFlowTheme.of(context).bodyText1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: FFLocalizations.of(context)
                              .getText(StringsManager.writeACaption),
                          hintStyle: FlutterFlowTheme.of(context).bodyText1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              /*buildText(StringsManager.tagPeople.tr),
              const Divider(),
              buildText(StringsManager.addLocation.tr),
              const Divider(),
              buildText(StringsManager.alsoPostTo.tr),
              Row(
                children: [
                  Expanded(child: buildText(StringsManager.facebook.tr)),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      isSwitched = value;
                    },
                    activeTrackColor: ColorManager.blue,
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Padding buildText(String text) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
          start: 7, end: 7, bottom: 10, top: 10),
      child: Text(
        text,
        style: FlutterFlowTheme.of(context).bodyText2,
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).focusColor),
        backgroundColor: FlutterFlowTheme.of(context).course7,
        title: Text(
          FFLocalizations.of(context).getText(StringsManager.newPost),
          style: getNormalStyle(color: Theme.of(context).focusColor),
        ),
        actions: actionsWidgets(context));
  }

  List<Widget> actionsWidgets(BuildContext context) {
    return [
      ValueListenableBuilder(
        valueListenable: isItDone,
        builder: (context, bool isItDoneValue, child) => !isItDoneValue
            ? CustomCircularProgress(FlutterFlowTheme.of(context).primaryText)
            : IconButton(
                onPressed: () async => createPost(context),
                icon: const Icon(
                  Icons.check_rounded,
                  size: 30,
                  color: ColorManager.blue,
                ),
              ),
      ),
    ];
  }

  Future<void> createPost(BuildContext context) async {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setState(() => isItDone.value = false));
    Post postInfo;
    File selectedFile = firstImage!;
    Uint8List? convertedBytes;
    if (!isThatImage) {
      convertedBytes = await createThumbnail(selectedFile);
      postInfo = addPostInfo();
    } else {
      Uint8List byte = await selectedFile.readAsBytes();
      postInfo = addPostInfo();
    }
    if (!mounted) return;

    PostCubit postCubit = BlocProvider.of<PostCubit>(context, listen: false);
    await postCubit.createPost(postInfo, selectedFile,
        coverOfVideo: convertedBytes);

    if (postCubit.newPostInfo != null) {
      if (!mounted) return;

      await UserInfoCubit.get(context).updateUserPostsInfo(
          userId: myPersonalId, postInfo: postCubit.newPostInfo!);
      await postCubit.getPostsInfo(
          postsIds: myPersonalInfo.posts, isThatMyPosts: true);
      WidgetsBinding.instance
          .addPostFrameCallback((_) => setState(() => isItDone.value = true));
    }
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomePage(
            activeTab: 2,
          ),
        ),
        (route) => false);
  }

  Future<Uint8List?> createThumbnail(File selectedFile) async {
    final Uint8List? convertImage = await VideoThumbnail.thumbnailData(
      video: selectedFile.path,
      imageFormat: ImageFormat.PNG,
    );

    return convertImage;
  }

  Post addPostInfo() {
    return Post(
      aspectRatio: 1,
      publisherId: myPersonalId,
      datePublished: DateOfNow.dateOfNow(),
      caption: captionController.text,
      imagesUrls: [],
      comments: [],
      likes: [],
    );
  }
}
