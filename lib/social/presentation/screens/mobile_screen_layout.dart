import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/core/utility/injector.dart';
import 'package:fc_social_fitness/social/presentation/cubit/postInfoCubit/post_cubit.dart';
import 'package:fc_social_fitness/social/presentation/pages/profile/personal_profile_page.dart';
import 'package:fc_social_fitness/social/presentation/pages/time_line/all_user_time_line/all_users_time_line.dart';
import 'package:fc_social_fitness/social/presentation/pages/time_line/my_own_time_line/home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../views/widgets/salomon_bottom_bar.dart';
import '../pages/activity/activity_for_mobile.dart';
import '../pages/messages/messages_page_for_mobile.dart';
import '../pages/profile/create_post_page.dart';

class MobileScreenLayout extends StatefulWidget {
  final String userId;
  final int activeTab;
  const MobileScreenLayout(this.userId, {Key? key, this.activeTab = 0}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  ValueNotifier<bool> playHomeVideo = ValueNotifier(false);
  ValueNotifier<bool> playMainReelVideos = ValueNotifier(false);
  int activeTab = 0;

  CupertinoTabController controller = CupertinoTabController();
  @override
  void initState() {
    super.initState();
    activeTab = widget.activeTab;
  }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: playMainReelVideos,
      builder: (BuildContext context, bool value, __) {
        return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              body: Stack(
                children: [
                  IndexedStack(
                    index: activeTab,
                    children: [
                      activeTab==0?
                      BlocProvider<PostCubit>(
                        create: (context) => injector<PostCubit>(),
                        child: ValueListenableBuilder(
                          valueListenable: playHomeVideo,
                          builder: (context, bool playVideoValue, child) =>
                              HomePage(
                            userId: widget.userId,
                            playVideo: playVideoValue,
                          ),
                        ),
                      ):Container(),
                      activeTab==1?
                      AllUsersTimeLinePage():Container(),
                      activeTab==2?
                      BlocProvider<PostCubit>(
                        create: (context) => injector<PostCubit>(),
                        child: PersonalProfilePage(personalId: widget.userId),
                      ):Container(),
                      activeTab==3?
                      const CreatePostPage():Container(),
                      activeTab==4?
                      const ActivityPage():Container(),
                      activeTab==5?
                      const MessagesPageForMobile():Container(),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: getBottomMenu()),
                  )
                ],
              ),
              /*TabBarView(
                children: [
                  homePage(),
                  allUsersTimLinePage(),
                  personalProfilePage()
                ],
              ),*/
            ));
      },
    );
  }

  Widget getBottomMenu() {
    return Container(
      width: double.infinity,
      height: 60,
      child: ClipRRect(
        child: Container(
          padding: EdgeInsets.only(top: 15),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: SalomonBottomBar(
            itemPadding: EdgeInsets.all(10),
            currentIndex: activeTab,
            onTap: (i) {
              setState(() {
                activeTab = i;
              });
            },
            items: [
              SalomonBottomBarItem(
                icon: Icon(
                  FontAwesomeIcons.rss,
                  color: activeTab == 0
                      ? FlutterFlowTheme.of(context).course20
                      : FlutterFlowTheme.of(context).primaryText,
                  size: 20,
                ),
                selectedColor: FlutterFlowTheme.of(context).course20,
              ),
              SalomonBottomBarItem(
                icon: Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  color: activeTab == 1
                      ? FlutterFlowTheme.of(context).course20
                      : FlutterFlowTheme.of(context).primaryText,
                  size: 20,
                ),
                selectedColor: FlutterFlowTheme.of(context).course20,
              ),
              SalomonBottomBarItem(
                icon: Icon(
                  FontAwesomeIcons.userLarge,
                  color: activeTab == 2
                      ? FlutterFlowTheme.of(context).course20
                      : FlutterFlowTheme.of(context).primaryText,
                  size: 20,
                ),
                selectedColor: FlutterFlowTheme.of(context).course20,
              ),
              SalomonBottomBarItem(
                icon: Icon(
                  FontAwesomeIcons.plus,
                  color: activeTab == 3
                      ? FlutterFlowTheme.of(context).course20
                      : FlutterFlowTheme.of(context).primaryText,
                  size: 20,
                ),
                selectedColor: FlutterFlowTheme.of(context).course20,
              ),
              SalomonBottomBarItem(
                icon: Icon(
                  FontAwesomeIcons.solidBell,
                  color: activeTab == 4
                      ? FlutterFlowTheme.of(context).course20
                      : FlutterFlowTheme.of(context).primaryText,
                  size: 20,
                ),
                selectedColor: FlutterFlowTheme.of(context).course20,
              ),
              SalomonBottomBarItem(
                icon: Icon(
                  FontAwesomeIcons.solidMessage,
                  color: activeTab == 5
                      ? FlutterFlowTheme.of(context).course20
                      : FlutterFlowTheme.of(context).primaryText,
                  size: 20,
                ),
                selectedColor: FlutterFlowTheme.of(context).course20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
