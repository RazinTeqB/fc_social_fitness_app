import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fc_social_fitness/social/core/resources/assets_manager.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/searchAboutUser/search_about_user_bloc.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../../constants/app_routes.dart';
import '../../../../my_app.dart';
import '../../../../utils/flutter_flow_theme.util.dart';
import '../../../../utils/internationalization.util.dart';
import '../../../../utils/italian_assets_picker_text_delegate.dart';
import '../../../../utils/validators.utils.dart';
import '../../../../viewmodels/base.viewmodel.dart';
import '../../../../views/widgets/custom_text_form_field.widget.dart';
import '../../../core/functions/toast_show.dart';
import '../../cubit/firestoreUserInfoCubit/user_info_cubit.dart';

// ignore: must_be_immutable
class EditProfilePage extends StatefulWidget {
  UserPersonalInfo userInfo;
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController userNameController = TextEditingController(text: "");
  TextEditingController bioController = TextEditingController(text: "");
  TextEditingController heightTEC = TextEditingController(text: "");
  TextEditingController weightTEC = TextEditingController(text: "");
  final BehaviorSubject<bool> heightValid = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> weightValid = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get validHeight => heightValid.stream;

  Stream<bool> get validWeight => weightValid.stream;

  EditProfilePage(this.userInfo, {Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  ValueNotifier<bool> isImageUpload = ValueNotifier(true);
  bool reBuild = false;
  bool userNameChanging = false;
  bool validateEdits = true;
  bool usernameChanged = true;

  @override
  void initState() {
    widget.nameController = TextEditingController(text: widget.userInfo.name);
    widget.userNameController =
        TextEditingController(text: widget.userInfo.userName.toLowerCase());
    widget.bioController = TextEditingController(text: widget.userInfo.bio);
    widget.heightTEC = TextEditingController(
        text: CustomBaseViewModel.statiCcurrentUser?.userData?.height);
    widget.weightTEC = TextEditingController(
        text: CustomBaseViewModel.statiCcurrentUser?.userData?.weight);

    super.initState();
  }

  @override
  Widget build(BuildContext context1) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      buildWhen: (previous, current) {
        if (previous != current && (current is CubitMyPersonalInfoLoaded)) {
          return true;
        }

        if (previous != current && reBuild) {
          reBuild = false;
          return true;
        }
        return false;
      },
      builder: (context, getUserState) {
        UserInfoCubit updateUserCubit = UserInfoCubit.get(context);

        if (getUserState is CubitGetUserInfoFailed) {
          ToastShow.toastStateError(getUserState);
        }
        if (getUserState is CubitMyPersonalInfoLoaded) {
          Future.delayed(Duration.zero, () {
            if (mounted) {
              setState(() {
                widget.userInfo = getUserState.userPersonalInfo;
              });
            }
          });
        }

        return buildScaffold(context, getUserState, updateUserCubit);
      },
    );
  }

  Scaffold buildScaffold(BuildContext context, UserInfoState getUserState,
      UserInfoCubit updateUserCubit) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme
          .of(context)
          .secondaryBackground,
      appBar: isThatMobile
          ? buildAppBar(context, getUserState, updateUserCubit)
          : null,
      body: Column(
        children: [
          circleAvatarAndTextFields(context, updateUserCubit),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, UserInfoState getUserState,
      UserInfoCubit updateUserCubit) {
    return AppBar(
        elevation: 0,
        backgroundColor: FlutterFlowTheme
            .of(context)
            .secondaryBackground,
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.entryRoute,
                  arguments: [2, 2]);
            },
            icon: SvgPicture.asset(
              IconsAssets.cancelIcon,
              color: FlutterFlowTheme
                  .of(context)
                  .primaryText,
              height: 25,
            )),
        title: Text(
          FFLocalizations.of(context).getText(StringsManager.editProfile),
          style: FlutterFlowTheme
              .of(context)
              .bodyText1,
        ),
        actions: actionsWidgets(getUserState, updateUserCubit, context));
  }

  List<Widget> actionsWidgets(dynamic getUserState,
      UserInfoCubit updateUserCubit, BuildContext outContext) {
    return [
      if (validateEdits) ...[
        getUserState is! CubitMyPersonalInfoLoaded
            ? Transform.scale(
            scaleY: 1,
            scaleX: 1.2,
            child: CustomCircularProgress(
                FlutterFlowTheme
                    .of(context)
                    .primaryText))
            : ValueListenableBuilder(
          valueListenable: isImageUpload,
          builder: (context, bool isImageUploadValue, child) =>
              IconButton(
                onPressed: () async {
                  if (isImageUploadValue) {
                    reBuild = true;
                    List<dynamic> charactersOfName = [];
                    String name =
                    widget.userNameController.text.toLowerCase();
                    for (int i = 0; i < name.length; i++) {
                      charactersOfName =
                          charactersOfName + [name.substring(0, i + 1)];
                    }
                    UserPersonalInfo updatedUserInfo = UserPersonalInfo(
                      followerPeople: widget.userInfo.followerPeople,
                      followedPeople: widget.userInfo.followedPeople,
                      posts: widget.userInfo.posts,
                      userName: widget.userNameController.text.toLowerCase(),
                      name: widget.nameController.text,
                      bio: widget.bioController.text,
                      profileImageUrl: widget.userInfo.profileImageUrl,
                      email: widget.userInfo.email,
                      charactersOfName: charactersOfName,
                      height: double.parse(widget.heightTEC.text),
                      weight: double.parse(widget.weightTEC.text),
                      stories: widget.userInfo.stories,
                      userId: widget.userInfo.userId,
                      deviceToken: widget.userInfo.deviceToken,
                      lastThreePostUrls: widget.userInfo.lastThreePostUrls,
                      chatsOfGroups: widget.userInfo.chatsOfGroups,
                    );

                    await updateUserCubit
                        .updateUserInfo(updatedUserInfo)
                        .whenComplete(() {
                      Future.delayed(Duration.zero, () {
                        reBuild = false;
                        Navigator.of(outContext).pushNamed(
                            AppRoutes.entryRoute,
                            arguments: [2, 2]);
                      });
                    });
                  }
                },
                icon: checkIcon(false),
              ),
        )
      ] else
        ...[
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 15),
            child: checkIcon(true),
          )
        ],
    ];
  }

  Icon checkIcon(bool light) {
    return Icon(Icons.check_rounded,
        size: 30, color: FlutterFlowTheme
            .of(context)
            .course20);
  }

  Expanded circleAvatarAndTextFields(BuildContext context,
      UserInfoCubit updateUserCubit) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: textFieldsColumn(updateUserCubit),
        ),
      ),
    );
  }

  Widget textFieldsColumn(UserInfoCubit updateUserCubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        imageCircleAvatar(context),
        const SizedBox(height: 15),
        Center(
          child: InkWell(
            onTap: () async => onTapChangeImage(updateUserCubit),
            child: Text(
              FFLocalizations.of(context)
                  .getText(StringsManager.changeProfilePhoto),
              style: FlutterFlowTheme
                  .of(context)
                  .bodyText1
                  .merge(
                  TextStyle(color: FlutterFlowTheme
                      .of(context)
                      .course20)),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text("Nome e cognome", style: FlutterFlowTheme
            .of(context)
            .bodyText1),
        const SizedBox(height: 15),
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: FlutterFlowTheme
                    .of(context)
                    .primaryBackground),
            child: textFormField(widget.nameController,
                FFLocalizations.of(context).getText(StringsManager.name))),
        const SizedBox(height: 15),
        Text("Nome utente", style: FlutterFlowTheme
            .of(context)
            .bodyText1),
        const SizedBox(height: 15),
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: FlutterFlowTheme
                    .of(context)
                    .primaryBackground),
            child: userNameTextField(context)),
        const SizedBox(height: 15),
        Text("Biografia", style: FlutterFlowTheme
            .of(context)
            .bodyText1),
        const SizedBox(height: 15),
        CustomTextFormField(
          fillColor: FlutterFlowTheme
              .of(context)
              .primaryBackground,
          hintText:
          "${FFLocalizations.of(context).getText(StringsManager.bio)}",
          style: TextStyle(color: FlutterFlowTheme
              .of(context)
              .white),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          textInputAction: TextInputAction.next,
          textEditingController: widget.bioController,
        ),
        SizedBox(height: 15),
        Text("Altezza", style: FlutterFlowTheme
            .of(context)
            .bodyText1),
        SizedBox(height: 15),
        StreamBuilder<bool>(
          stream: widget.validHeight,
          builder: (context, snapshot) {
            return CustomTextFormField(
              fillColor: FlutterFlowTheme
                  .of(context)
                  .primaryBackground,
              hintText:
              "${FFLocalizations.of(context).getText('altezza')} (cm)",
              style: TextStyle(color: FlutterFlowTheme
                  .of(context)
                  .white),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              textEditingController: widget.heightTEC,
              errorText: snapshot.error,
              onChanged: validateHeight,
            );
          },
        ),
        SizedBox(height: 15),
        Text("Peso", style: FlutterFlowTheme
            .of(context)
            .bodyText1),
        SizedBox(height: 15),
        StreamBuilder<bool>(
          stream: widget.validWeight,
          builder: (context, snapshot) {
            return CustomTextFormField(
              fillColor: FlutterFlowTheme
                  .of(context)
                  .primaryBackground,
              hintText: "${FFLocalizations.of(context).getText('peso')} (kg)",
              style: TextStyle(color: FlutterFlowTheme
                  .of(context)
                  .white),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              textEditingController: widget.weightTEC,
              errorText: snapshot.error,
              onChanged: validateWeight,
            );
          },
        ),
        SizedBox(height: 30),
        GestureDetector(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: FlutterFlowTheme
                    .of(context)
                    .course20),
            child: Align(
                child: Text("Cambia password",
                    style: FlutterFlowTheme
                        .of(context)
                        .bodyText1
                        .merge(
                        TextStyle(color: FlutterFlowTheme
                            .of(context)
                            .white))),
                alignment: Alignment.centerLeft),
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed(AppRoutes.changeCredentialOtp, arguments: 0);
          },
        ),
        SizedBox(height: 30)
      ],
    );
  }

  onTapChangeImage(UserInfoCubit updateUserCubit) async {
    File? profileImage = await pushToCustomGallery(context);
    if (profileImage == null) return;
    isImageUpload.value = false;

    await updateUserCubit.uploadProfileImage(
        photo: profileImage,
        userId: widget.userInfo.userId,
        previousImageUrl: widget.userInfo.profileImageUrl);
    isImageUpload.value = true;
  }

  static Future<File?> pushToCustomGallery(BuildContext context) async {
    File? outputFile;

    final List<AssetEntity>? result = await AssetPicker.pickAssets(
        context,
        pickerConfig:
        AssetPickerConfig(maxAssets: 1, requestType: RequestType.image, textDelegate: MyApp.of(context)
        .getLocale()
        ?.countryCode == "en"
        ? EnglishAssetPickerTextDelegate() : ItalianAssetPickerTextDelegate(),
    ));

    return result![0].file;
  }

  Widget userNameTextField(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isImageUpload,
      builder: (context, bool isImageUploadValue, child) =>
          BlocBuilder<SearchAboutUserBloc, SearchAboutUserState>(
            bloc: BlocProvider.of<SearchAboutUserBloc>(context)
              ..add(FindSpecificUser(widget.userNameController.text,
                  searchForSingleLetter: true)),
            buildWhen: (previous, current) =>
            previous != current &&
                (current is SearchAboutUserBlocLoaded) &&
                isImageUploadValue,
            builder: (context, state) {
              List<UserPersonalInfo> usersWithSameUserName = [];
              if (state is SearchAboutUserBlocLoaded) {
                usersWithSameUserName = state.users;
              }
              bool isIExist = usersWithSameUserName.contains(widget.userInfo);
              WidgetsBinding.instance.addPostFrameCallback((_) =>
                  setState(() {
                    validateEdits = usernameChanged &&
                        (isIExist || usersWithSameUserName.isEmpty);
                    userNameChanging =
                        widget.userNameController.text !=
                            widget.userInfo.userName;
                  }));
              return userNameTextFormField(
                widget.userNameController,
                FFLocalizations.of(context).getText(StringsManager.username),
                uniqueUserName: validateEdits,
              );
            },
          ),
    );
  }

  CustomTextFormField userNameTextFormField(TextEditingController controller,
      String text,
      {required bool uniqueUserName}) {
    return CustomTextFormField(
      fillColor: FlutterFlowTheme
          .of(context)
          .primaryBackground,
      hintText: text,
      style: TextStyle(color: FlutterFlowTheme
          .of(context)
          .white),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textEditingController: controller,
      errorText: uniqueUserName && validateEdits
          ? null
          : FFLocalizations.of(context)
          .getText(StringsManager.thisUserNameExist),
      onChanged: (value) {
        setState(() {
          if (widget.userInfo.userName == value) {
            usernameChanged = false;
          } else {
            usernameChanged = true;
          }
        });
        if (value.isEmpty) setState(() => validateEdits = false);
      },
    );
  }

  Icon rightIcon() {
    return const Icon(Icons.check_circle, color: ColorManager.green, size: 27);
  }

  Transform wrongIcon() {
    return Transform.rotate(
      angle: pi / 3.6,
      child: const Icon(
        Icons.add_circle_rounded,
        color: ColorManager.red,
        size: 27,
      ),
    );
  }

  Center imageCircleAvatar(BuildContext context) {
    return Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            userCircleAvatarImage(),
          ],
        ));
  }

  Widget userCircleAvatarImage() {
    bool hasUserPhoto = widget.userInfo.profileImageUrl.isNotEmpty;

    return GestureDetector(
      child: ValueListenableBuilder(
        valueListenable: isImageUpload,
        builder: (context, bool isImageUploadValue, child) =>
            CircleAvatar(
              backgroundImage: isImageUploadValue && hasUserPhoto
                  ? NetworkImage(widget.userInfo.profileImageUrl)
                  : null,
              radius: 50,
              backgroundColor: Theme
                  .of(context)
                  .focusColor,
              child: ClipOval(
                child: !isImageUploadValue
                    ? const ThineCircularProgress(color: ColorManager.white)
                    : (!hasUserPhoto
                    ? Icon(Icons.person,
                    color: FlutterFlowTheme
                        .of(context)
                        .course20)
                    : null),
              ),
            ),
      ),
    );
  }

  CustomTextFormField textFormField(TextEditingController controller,
      String text) {
    return CustomTextFormField(
      fillColor: FlutterFlowTheme
          .of(context)
          .primaryBackground,
      hintText: text,
      maxLines: 10,
      style: TextStyle(color: FlutterFlowTheme
          .of(context)
          .white),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textEditingController: controller,
    );
  }

  bool validateHeight(String value) {
    if (!Validators.isLenghtValid(value, 2)) {
      widget.heightValid
          .addError(FFLocalizations.of(context).getText('isHeightValid'));
      return false;
    } else {
      widget.heightValid.add(true);
      return true;
    }
  }

  bool validateWeight(String value) {
    if (!Validators.isLenghtValid(value, 1)) {
      widget.weightValid
          .addError(FFLocalizations.of(context).getText('isWeightValid'));
      return false;
    } else {
      widget.weightValid.add(true);
      return true;
    }
  }
}
