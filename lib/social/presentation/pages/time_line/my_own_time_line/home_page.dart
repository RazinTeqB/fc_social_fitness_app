import 'dart:async';
import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/core/functions/toast_show.dart';
import 'package:fc_social_fitness/social/core/functions/notifications_permissions.dart';
import 'package:fc_social_fitness/social/core/resources/color_manager.dart';
import 'package:fc_social_fitness/social/core/resources/strings_manager.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/data/models/child_classes/post/post.dart';
import 'package:fc_social_fitness/social/presentation/cubit/firestoreUserInfoCubit/users_info_reel_time/users_info_reel_time_bloc.dart';
import 'package:fc_social_fitness/social/presentation/cubit/follow/follow_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/specific_users_posts_cubit.dart';
import 'package:fc_social_fitness/social/presentation/customPackages/in_view_notifier/in_view_notifier_list.dart';
import 'package:fc_social_fitness/social/presentation/customPackages/in_view_notifier/in_view_notifier_widget.dart';
import 'package:fc_social_fitness/social/presentation/customPackages/snapping.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/time_line_w/all_catch_up_icon.dart';
import 'package:fc_social_fitness/social/presentation/widgets/belong_to/time_line_w/image_of_post_for_time_line.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_app_bar.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_circulars_progress.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_network_image_display.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/custom_widgets/custom_smart_refresh.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/popup_widgets/common/jump_arrow.dart';
import '../../../../../utils/internationalization.util.dart';
import '../../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import '../../../widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';

class HomePage extends StatefulWidget {
  final String userId;
  final bool playVideo;

  const HomePage({Key? key, required this.userId, this.playVideo = true})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  ValueNotifier<bool> isThatEndOfList = ValueNotifier(false);
  late UserPersonalInfo personalInfo;
  ValueNotifier<bool> reLoadData = ValueNotifier(false);
  Post? selectedPostInfo;
  bool rebuild = true;
  List postsIds = [];
  ValueNotifier<List<Post>> postsInfo = ValueNotifier([]);
  List<UserPersonalInfo>? storiesOwnersInfo;
  ScrollController scrollController = ScrollController();

  Future<void> getData(int index) async {
    storiesOwnersInfo = null;
    reLoadData.value = false;
    UserInfoCubit userCubit =
        BlocProvider.of<UserInfoCubit>(context, listen: false);
    await userCubit.getUserInfo(widget.userId);
    if (!mounted) return;
    personalInfo = userCubit.myPersonalInfo;
    List usersIds = personalInfo.followedPeople;
    SpecificUsersPostsCubit usersPostsCubit =
        BlocProvider.of<SpecificUsersPostsCubit>(context, listen: false);

    await usersPostsCubit.getSpecificUsersPostsInfo(usersIds: usersIds);

    List usersPostsIds = usersPostsCubit.usersPostsInfo;

    postsIds = personalInfo.posts + usersPostsIds;
    if (!mounted) return;
    PostCubit postCubit = PostCubit.get(context);
    await postCubit
        .getPostsInfo(
            postsIds: postsIds, isThatMyPosts: true, lengthOfCurrentList: index)
        .then((value) {
      reLoadData.value = true;
    });
  }

  @override
  void initState() {
    getData(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 80, bottom: 45),
            child: blocBuilder(bodyHeight),
          ),
        ),
      ),
    );
  }

  ValueListenableBuilder<bool> blocBuilder(double bodyHeight) {
    return ValueListenableBuilder(
      valueListenable: reLoadData,
      builder: (context, bool value, child) =>
          BlocBuilder<PostCubit, PostState>(
        buildWhen: (previous, current) {
          if (value && current is CubitMyPersonalPostsLoaded) {
            reLoadData.value = false;
            return true;
          }
          if (value) {
            reLoadData.value = false;
            return true;
          }

          if (previous != current && current is CubitMyPersonalPostsLoaded) {
            return true;
          }
          if (previous != current && current is CubitPostFailed) {
            return true;
          }
          return false;
        },
        builder: (BuildContext context, PostState state) {
          if (state is CubitMyPersonalPostsLoaded) {
            postsInfo.value = state.postsInfo;
            return postsInfo.value.isNotEmpty
                ? inViewNotifier(bodyHeight)
                : _WelcomeCards(onRefreshData: getData);
          } else if (state is CubitPostFailed) {
            ToastShow.toastStateError(state);
            return Center(
                child: Text(
              FFLocalizations.of(context)
                  .getText(StringsManager.somethingWrong),
              style: FlutterFlowTheme.of(context).bodyText1,
            ));
          } else {
            return const ThineCircularProgress();
          }
        },
      ),
    );
  }

  Widget inViewNotifier(double bodyHeight) {
    return ValueListenableBuilder(
      valueListenable: postsInfo,
      builder: (context, List<Post> postsInfoValue, child) =>
          InViewNotifierList(
        onRefreshData: getData,
        postsIds: postsIds,
        physics: const BouncingScrollPhysics(),
        isThatEndOfList: isThatEndOfList,
        initialInViewIds: const ['0'],
        isInViewPortCondition:
            (double deltaTop, double deltaBottom, double vpHeight) {
          return deltaTop < (0.5 * vpHeight) && deltaBottom > (0.5 * vpHeight);
        },
        itemCount: postsInfoValue.length,
        builder: (BuildContext context, int index) {
          return Center(
            child: Container(
              width: isThatMobile ? double.infinity : 450,
              margin: const EdgeInsetsDirectional.only(bottom: .5, top: .5),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return InViewNotifierWidget(
                    id: '$index',
                    builder: (_, bool isInView, __) {
                      bool checkForPlatform = isThatMobile
                          ? isInView && widget.playVideo
                          : isInView;
                      return columnOfWidgets(
                          bodyHeight, index, checkForPlatform, isInView);
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget columnOfWidgets(
      double bodyHeight, int index, bool playTheVideo, bool isInView) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        posts(index, bodyHeight, playTheVideo),
        if (isThatEndOfList.value && index == postsIds.length - 1) ...[
          if (isThatMobile) divider(),
          const AllCatchUpIcon(),
        ]
      ],
    );
  }

  Divider divider() {
    return const Divider(color: ColorManager.lightGrey, thickness: .15);
  }

  Container customDivider() => Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8, top: 5),
      color: ColorManager.grey,
      width: double.infinity,
      height: 3);

  Widget posts(int index, double bodyHeight, bool playTheVideo) {
    Widget buildPost = ValueListenableBuilder(
      valueListenable: postsInfo,
      builder: (context, List<Post> postsInfoValue, child) => PostOfTimeLine(
        postInfo: ValueNotifier(postsInfo.value[index]),
        postsInfo: postsInfo,
        playTheVideo: playTheVideo,
        indexOfPost: index,
        reLoadData: reloadTheData,
        removeThisPost: removeThisPost,
      ),
    );
    return isThatMobile
        ? buildPost
        : roundedContainer(
            child: buildPost, internalPadding: false, verticalPadding: true);
  }

  void removeThisPost(int index) {
    setState(() {
      postsIds.removeAt(index);
      postsInfo.value.removeAt(index);
      reLoadData.value = true;
    });
  }

  reloadTheData() => reLoadData.value = true;

  Padding roundedContainer({
    required Widget child,
    bool internalPadding = true,
    bool verticalPadding = false,
    bool isThatStory = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        padding: internalPadding || verticalPadding
            ? const EdgeInsets.symmetric(vertical: 15)
            : null,
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorManager.lowOpacityGrey, width: 1),
        ),
        child: child,
      ),
    );
  }
}

class _WelcomeCards extends StatefulWidget {
  final AsyncValueSetter<int> onRefreshData;

  const _WelcomeCards({Key? key, required this.onRefreshData})
      : super(key: key);

  @override
  State<_WelcomeCards> createState() => _WelcomeCardsState();
}

class _WelcomeCardsState extends State<_WelcomeCards> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);
  PageController pageController = PageController(viewportFraction: 0.7);
  int currentPage = 0;
  late ScrollController _scrollPageController;
  double initialPage = 0;

  @override
  void initState() {
    super.initState();
    initialPage = currentPage.toDouble();
    _scrollPageController = ScrollController();
  }

  @override
  void dispose() {
    _selectedIndex.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return welcomeCards();
  }

  Widget welcomeCards() {
    return SizedBox(
      height: double.maxFinite,
      child: isThatMobile
          ? CustomSmartRefresh(
              onRefreshData: widget.onRefreshData, child: suggestionsFriends())
          : suggestionsFriends(),
    );
  }

  Widget buildColumn(List<UserPersonalInfo> users) {
    double widthOfScreen = MediaQuery.of(context).size.width;
    double halfOfWidth = widthOfScreen / 2;
    double heightOfStory =
        (halfOfWidth < 515 ? widthOfScreen : halfOfWidth) + 100;
    double widthOfStory =
        (halfOfWidth < 515 ? halfOfWidth : halfOfWidth / 2) + 80;

    return ScrollSnapList(
      itemBuilder: (_, index) {
        bool active = currentPage == index;

        return SizedBox(
          width: widthOfStory,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: heightOfStory,
                  width: widthOfStory,
                  child: userCardInfo(active, users[index], index),
                ),
                if (currentPage == index) ...[
                  buildJumpArrow(),
                  buildJumpArrow(isThatBack: false),
                ],
              ],
            ),
          ),
        );
      },
      onItemFocus: (pos) {
        setState(() => currentPage = pos);
        if (kDebugMode) {
          print('Done! $pos');
        }
      },
      itemSize: widthOfStory,
      listController: _scrollPageController,
      initialIndex: initialPage,
      dynamicItemSize: true,
      scrollDirection: Axis.horizontal,
      onReachEnd: () {
        if (kDebugMode) {
          print('Done!');
        }
      },
      itemCount: users.length,
    );
  }

  Widget suggestionsFriends() {
    return Column(
      children: [
        ...welcomeTexts(),
        Flexible(
          child: BlocBuilder<UsersInfoReelTimeBloc, UsersInfoReelTimeState>(
            bloc: UsersInfoReelTimeBloc.get(context)
              ..add(LoadAllUsersInfoInfo()),
            buildWhen: (previous, current) =>
                previous != current && (current is AllUsersInfoLoaded),
            builder: (context, state) {
              if (state is AllUsersInfoLoaded) {
                List<UserPersonalInfo> users = state.allUsersInfoInReelTime;
                if (users.isEmpty) {
                  return emptyText();
                } else {
                  if (isThatMobile) {
                    return ValueListenableBuilder(
                      valueListenable: _selectedIndex,
                      builder: (context, int selectedIndexValue, child) =>
                          PageView.builder(
                        itemCount: users.length,
                        controller: pageController,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (index) {
                          _selectedIndex.value = index;
                        },
                        itemBuilder: (context, index) {
                          bool active = selectedIndexValue == index;
                          return userCardInfo(active, users[index], index);
                        },
                      ),
                    );
                  } else {
                    return buildColumn(users);
                  }
                }
              } else {
                return const Center(child: ThineCircularProgress());
              }
            },
          ),
        ),
      ],
    );
  }

  List<Widget> welcomeTexts() => [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            FFLocalizations.of(context)
                .getText(StringsManager.welcomeToInstagram),
            style: FlutterFlowTheme.of(context).bodyText1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            FFLocalizations.of(context)
                .getText(StringsManager.followPeopleToSee),
            style: FlutterFlowTheme.of(context).bodyText1,
          ),
        ),
        Center(
          child: Text(
            FFLocalizations.of(context).getText(StringsManager.videosTheyShare),
            style: FlutterFlowTheme.of(context).bodyText1,
          ),
        ),
      ];

  Widget userCardInfo(bool active, UserPersonalInfo userInfo, int index) {
    final double margin = active ? 0 : 25;
    double width =
        MediaQuery.of(context).size.width - (isThatMobile ? 120 : 200);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: isThatMobile ? 340 : 400,
          width: width,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutQuint,
            margin: EdgeInsets.only(top: margin, bottom: margin),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: FlutterFlowTheme.of(context).primaryBackground,
              /*boxShadow: [
                  BoxShadow(
                    color:FlutterFlowTheme.of(context).lineColor,
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: const Offset(0,0),
                  ),
                ]*/
            ),
            child: buildUserBrief(userInfo),
          ),
        ),
      ),
    );
  }

  Widget buildJumpArrow({bool isThatBack = true}) {
    return GestureDetector(
      onTap: () async {
        if (isThatBack) {
          _scrollPageController.animateTo(
            _scrollPageController.offset -
                MediaQuery.of(context).size.width / 4,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollPageController.animateTo(
            _scrollPageController.offset +
                MediaQuery.of(context).size.width / 4,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: SizedBox(child: ArrowJump(isThatBack: isThatBack)),
    );
  }

  Widget emptyText() {
    return Center(
      child: Text(
        FFLocalizations.of(context).getText(StringsManager.noUsers),
        style: FlutterFlowTheme.of(context).bodyText1,
      ),
    );
  }

  Widget buildUserBrief(UserPersonalInfo userInfo) {
    List lastThreePostUrls = userInfo.lastThreePostUrls.length >= 3
        ? userInfo.lastThreePostUrls.sublist(0, 3)
        : userInfo.lastThreePostUrls;
    bool isIFollowHim = userInfo.followerPeople.contains(myPersonalId);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatarOfProfileImage(
                userInfo: userInfo, bodyHeight: 900, showColorfulCircle: false),
            const SizedBox(height: 10),
            Text(
              userInfo.userName,
              style: FlutterFlowTheme.of(context).bodyText1,
            ),
            Text(
              userInfo.name,
              style: FlutterFlowTheme.of(context).bodyText1,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (lastThreePostUrls.isEmpty) ...[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        FFLocalizations.of(context)
                            .getText(StringsManager.noPosts),
                        style: FlutterFlowTheme.of(context).bodyText1,
                      ),
                    ),
                  ),
                ] else ...[
                  ...lastThreePostUrls.map(
                    (imageUrl) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(end: 1),
                        child: SizedBox(
                            height: isThatMobile ? 70 : 100,
                            width: isThatMobile ? 70 : 100,
                            child: NetworkDisplay(
                              url: imageUrl,
                            )),
                      );
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 37),
            GestureDetector(
              onTap: () async {
                FollowCubit followCubit = FollowCubit.get(context);
                if (isIFollowHim) {
                  await followCubit.unFollowThisUser(
                      followingUserId: userInfo.userId,
                      myPersonalId: myPersonalId);
                  userInfo.followerPeople.remove(myPersonalId);
                } else {
                  await followCubit.followThisUser(
                      followingUserId: userInfo.userId,
                      myPersonalId: myPersonalId);
                  userInfo.followerPeople.add(myPersonalId);
                }
              },
              child: followButton(isIFollowHim),
            ),
          ],
        ),
      ),
    );
  }

  Container followButton(bool isIFollowHim) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isIFollowHim ? FlutterFlowTheme.of(context).course20.withOpacity(0.5) : FlutterFlowTheme.of(context).course20,
      ),
      child: isIFollowHim
          ? Text(FFLocalizations.of(context).getText(StringsManager.following),
              style: FlutterFlowTheme.of(context).bodyText1.merge(TextStyle(color: Colors.white)))
          : Text(FFLocalizations.of(context).getText(StringsManager.follow),
              style: FlutterFlowTheme.of(context).bodyText1.merge(TextStyle(color: Colors.white))),
    );
  }
}
