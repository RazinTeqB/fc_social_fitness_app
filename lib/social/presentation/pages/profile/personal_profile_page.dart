import 'dart:async';
import 'package:fc_social_fitness/constants/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:fc_social_fitness/social/config/routes/app_routes.dart';
import 'package:fc_social_fitness/social/config/themes/theme_service.dart';
import 'package:fc_social_fitness/social/core/resources/assets_manager.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/resources/styles_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/core/utility/injector.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/users_info_reel_time/users_info_reel_time_bloc.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/profile_w/bottom_sheet.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/profile_w/profile_page.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/profile_w/recommendation_people.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_gallery_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/flutter_flow_theme.util.dart';
import '../../../../utils/internationalization.util.dart';
import '../../../core/functions/toast_show.dart';
import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../cubit/firebaseAuthCubit/firebase_auth_cubit.dart';
import '../../cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../register/login_page.dart';
import 'edit_profile_page.dart';

class PersonalProfilePage extends StatefulWidget {
  final String personalId;
  final String userName;

  const PersonalProfilePage(
      {Key? key, required this.personalId, this.userName = ''})
      : super(key: key);

  @override
  State<PersonalProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<PersonalProfilePage> {
  final SharedPreferences sharePrefs = injector<SharedPreferences>();
  final rebuildUserInfo = ValueNotifier(false);
  Size imageSize = const Size(0.00, 0.00);
  final darkTheme = ValueNotifier(false);
  List<Size> imagesSize = [];

  @override
  void initState() {
    darkTheme.value = ThemeMode.dark == ThemeOfApp().theme;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return scaffold();
  }

  Future<void> getData() async {
    widget.userName.isNotEmpty
        ? (await BlocProvider.of<UserInfoCubit>(context)
            .getUserFromUserName(widget.userName))
        : (await BlocProvider.of<UserInfoCubit>(context)
            .getUserInfo(widget.personalId));
    rebuildUserInfo.value = true;
  }

  Widget scaffold() {
    return WillPopScope(
      onWillPop: () async => true,
      child: ValueListenableBuilder(
        valueListenable: rebuildUserInfo,
        builder: (context, bool rebuildValue, child) =>
            BlocBuilder<UserInfoCubit, UserInfoState>(
          bloc: widget.userName.isNotEmpty
              ? (BlocProvider.of<UserInfoCubit>(context)
                ..getUserFromUserName(widget.userName))
              : (BlocProvider.of<UserInfoCubit>(context)
                ..getUserInfo(widget.personalId, getDeviceToken: true)),
          buildWhen: (previous, current) {
            if (previous != current && current is CubitMyPersonalInfoLoaded) {
              return true;
            }
            if (previous != current && current is CubitGetUserInfoFailed) {
              return true;
            }
            if (rebuildValue) {
              rebuildUserInfo.value = false;
              return true;
            }
            return false;
          },
          builder: (context, state) {
            if (state is CubitMyPersonalInfoLoaded) {
              return Scaffold(
                backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                appBar: isThatMobile
                    ? PreferredSize(
                  preferredSize: Size.fromHeight(70), // here the desired height
                  child: appBar(state.userPersonalInfo.userName))
                    : null,
                body: ProfilePage(
                  isThatMyPersonalId: true,
                  getData: getData,
                  userId: state.userPersonalInfo.userId,
                  userInfo: ValueNotifier(state.userPersonalInfo),
                  widgetsAboveTapBars: isThatMobile
                      ? widgetsAboveTapBarsForMobile(state.userPersonalInfo)
                      : widgetsAboveTapBarsForWeb(state.userPersonalInfo),
                ),
              );
            } else if (state is CubitGetUserInfoFailed) {
              ToastShow.toastStateError(state);
              return Text(FFLocalizations.of(context).getText(StringsManager.noPosts),
                  style: FlutterFlowTheme.of(context).bodyText1);
            } else {
              return const ThineCircularProgress();
            }
          },
        ),
      ),
    );
  }

  AppBar appBar(String userName) {
    return AppBar(
        elevation: 0,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        centerTitle: false,
        title: Text(userName,
            style: FlutterFlowTheme.of(context).bodyText1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              size: 25,
              color: FlutterFlowTheme.of(context).primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        /*actions: [
          IconButton(
            icon: SvgPicture.asset(
              IconsAssets.addIcon,
              color: Theme.of(context).focusColor,
              height: 22.5,
            ),
            onPressed: () => bottomSheet(),
          ),
          IconButton(
            icon: SvgPicture.asset(
              IconsAssets.menuIcon,
              color: Theme.of(context).focusColor,
              height: 30,
            ),
            onPressed: () async => bottomSheet(createNewData: false),
          ),
          const SizedBox(width: 5)
        ]*/);
  }

  Future<void> bottomSheet({bool createNewData = true}) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => CustomBottomSheet(
        bodyText: bodyTextOfBottomSheet(createNewData),
        headIcon: bottomSheetHeadIcon(),
      ),
    );
  }

  ValueListenableBuilder<bool> bottomSheetHeadIcon() {
    return ValueListenableBuilder(
        valueListenable: darkTheme,
        builder: (context, bool themeValue, child) {
          Color themeOfApp =
              themeValue ? ColorManager.white : ColorManager.black;
          return Text(FFLocalizations.of(context).getText(StringsManager.create),
              style: getBoldStyle(color: themeOfApp, fontSize: 17));
        });
  }

  Padding bodyTextOfBottomSheet(bool createNewData) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: createNewData ? columnOfCreateData() : columnOfThemeData(),
    );
  }

  Column columnOfCreateData() {
    return Column(
      children: [
        createPost(),
        customDivider(),
        createVideo(),
        customDivider(),
        createStory(),
        customDivider(),
        createNewLive(),
        customDivider(),
        Container(
          height: 50,
        )
      ],
    );
  }

  Divider customDivider() =>
      const Divider(indent: 40, endIndent: 15, color: ColorManager.grey);

  Column columnOfThemeData() {
    return Column(
      children: [
       // changeLanguage(),
        customDivider(),
        changeMode(),
        customDivider(),
        logOut(),
        customDivider(),
        Container(
          height: 50,
        )
      ],
    );
  }

  /*GetBuilder<AppLanguage> changeLanguage() {
    return GetBuilder<AppLanguage>(
      init: AppLanguage(),
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            controller.changeLanguage();
            //Phoenix.rebirth(context);
            Get.updateLocale(Locale(controller.appLocale));
          },
          child: createSizedBox(StringsManager.changeLanguage.tr,
              icon: Icons.language_rounded),
        );
      },
    );
  }*/

  GestureDetector changeMode() {
    return GestureDetector(
      onTap: () {
        Get.changeThemeMode(
            ThemeOfApp().loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
        ThemeOfApp().saveThemeToBox(!ThemeOfApp().loadThemeFromBox());
        darkTheme.value = ThemeMode.dark == ThemeOfApp().theme;
      },
      child: createSizedBox(FFLocalizations.of(context).getText(StringsManager.changeTheme),
          icon: Icons.brightness_4_outlined),
    );
  }

  Widget logOut() {
    return BlocBuilder<FirebaseAuthCubit, FirebaseAuthCubitState>(
        builder: (context, state) {
      FirebaseAuthCubit authCubit = FirebaseAuthCubit.get(context);
      if (state is CubitAuthSignOut) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          sharePrefs.clear();
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            CupertinoPageRoute(
                builder: (_) => LoginPage(sharePrefs: sharePrefs),
                maintainState: false),
            (route) => false,
          );
        });
      } else if (state is CubitAuthConfirming) {
        ToastShow.toast(FFLocalizations.of(context).getText(StringsManager.loading));
      } else if (state is CubitAuthFailed) {
        ToastShow.toastStateError(state);
      }
      return GestureDetector(
        child: createSizedBox(FFLocalizations.of(context).getText(StringsManager.logOut),
            icon: Icons.logout_rounded),
        onTap: () async {
          await authCubit.signOut(userId: widget.personalId);
        },
      );
    });
  }

  List<Widget> widgetsAboveTapBarsForMobile(UserPersonalInfo userInfo) {
    return [
      editProfileButtonForMobile(userInfo),
      SizedBox(width: 15),
      /*
      const RecommendationPeople(),
      const SizedBox(width: 10),*/
    ];
  }

  Expanded editProfileButtonForMobile(UserPersonalInfo userInfo) {
    return Expanded(
      child: Builder(builder: (buildContext) {
        UserPersonalInfo myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
        UserPersonalInfo? info = UsersInfoReelTimeBloc.getMyInfoInReelTime(context);
        if (isMyInfoInReelTimeReady && info != null) myPersonalInfo = info;
        return InkWell(
          onTap: () async {
            Navigator.maybePop(context);
            Future.delayed(Duration.zero, () async {
              Navigator.pushNamed(context, AppRoutes.editprofileRoute,arguments: userInfo);
              rebuildUserInfo.value = true;
              userInfo = myPersonalInfo;
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 35,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).course20,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: Text(
                FFLocalizations.of(context).getText(StringsManager.editProfile),
                style: FlutterFlowTheme.of(context).bodyText1.merge(TextStyle(color: Colors.white)),
              ),
            ),
          ),
        );
      }),
    );
  }

  List<Widget> widgetsAboveTapBarsForWeb(UserPersonalInfo userInfo) {
    return [
      const SizedBox(width: 20),
      editProfileButtonForWeb(),
      const SizedBox(width: 10),
      GestureDetector(
        child: const Icon(Icons.settings_rounded, color: ColorManager.black),
      ),
    ];
  }

  Widget editProfileButtonForWeb() {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
          color: ColorManager.transparent,
          border: Border.all(
            color: ColorManager.lowOpacityGrey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          FFLocalizations.of(context).getText(StringsManager.editProfile),
          style: getMediumStyle(color: ColorManager.black),
        ),
      ),
    );
  }

  Widget createNewLive() {
    return InkWell(
      onTap: () {},
      child: createSizedBox(FFLocalizations.of(context).getText(StringsManager.live),
          nameOfPath: IconsAssets.instagramHighlightStoryIcon),
    );
  }

  Widget createStory() {
    return InkWell(
        onTap: () async => createNewStory(true),
        child: createSizedBox(FFLocalizations.of(context).getText(StringsManager.story),
            nameOfPath: IconsAssets.addInstagramStoryIcon));
  }

  Widget createVideo() {
    return InkWell(
        onTap: () async => createNewStory(false),
        child: createSizedBox(FFLocalizations.of(context).getText(StringsManager.reel),
            nameOfPath: IconsAssets.videoIcon));
  }

  createNewStory(bool isThatStory) async {
    /*Navigator.maybePop(context);
    File? details = await CustomImagePickerPlus.pickImage(
      context,
      isThatStory: true,
    );
    if (!mounted || details == null) return;
    await pushToPage(context, page: CreateStoryPage(storiesDetails: details));
    rebuildUserInfo.value = true;*/
  }

  createNewPost() async {
    Navigator.maybePop(context);
    await CustomImagePickerPlus.pickBoth(context);
    rebuildUserInfo.value = true;
  }

  Widget createPost() {
    return InkWell(
        onTap: createNewPost, child: createSizedBox(FFLocalizations.of(context).getText(StringsManager.post)));
  }

  Widget createSizedBox(String text,
      {String nameOfPath = '', IconData icon = Icons.grid_on_rounded}) {
    return SizedBox(
      height: 40,
      child: ValueListenableBuilder(
        valueListenable: darkTheme,
        builder: (context, bool themeValue, child) {
          Color themeOfApp =
              themeValue ? ColorManager.white : ColorManager.black;
          return Row(children: [
            nameOfPath.isNotEmpty
                ? SvgPicture.asset(
                    nameOfPath,
                    color: Theme.of(context).dialogBackgroundColor,
                    height: 25,
                  )
                : Icon(icon, color: themeOfApp),
            const SizedBox(width: 15),
            Text(
              text,
              style: getNormalStyle(color: themeOfApp, fontSize: 15),
            )
          ]);
        },
      ),
    );
  }
}
