import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:fc_social_fitness/viewmodels/home.viewmodel.dart';
import 'package:fc_social_fitness/views/dashboard.page.dart';
import 'package:fc_social_fitness/views/settings.page.dart';
import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:fc_social_fitness/views/widgets/salomon_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import '../social/core/utility/constant.dart';
import '../social/presentation/screens/mobile_screen_layout.dart';
import '../utils/internationalization.util.dart';
import 'training_categories.page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.activeTab = 0,this.activeTabSocial = 0})
      : super(
          key: key,
        );
  final int activeTab;
  final int activeTabSocial;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int activeTab = 0;
  String pageTitle = "Home";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    activeTab = widget.activeTab;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return vm.isBusy
              ? FitnessLoading()
              : Scaffold(
                  key: scaffoldKey,
                  backgroundColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  extendBody: true,
                  resizeToAvoidBottomInset: false,
                  body: Stack(
                    children: [
                      IndexedStack(
                        index: activeTab,
                        children: [
                          activeTab==0?
                          DashboardPage(scaffoldKey: scaffoldKey):Container(),
                          activeTab==1?
                          TrainingCategoriesPage():Container(),
                          activeTab==2?
                          MobileScreenLayout(myPersonalId,activeTab: widget.activeTabSocial,):Container(),
                          activeTab==3?
                          SettingsPage():Container(),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: getBottomMenu(vm),
                      )
                    ],
                  ),
                );
        });
  }

  Widget getBottomMenu(HomeViewModel vm) {
    return Container(
      width: double.infinity,
      height: 80,
      child: ClipRRect(
        child: Container(
          padding: const EdgeInsets.only(top: 15),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: SalomonBottomBar(
            currentIndex: activeTab,
            onTap: (i) {
              setState(() {
                activeTab = i;
              });
            },
            items: [
              SalomonBottomBarItem(
                icon: Icon(
                  FontAwesomeIcons.house,
                  color: activeTab == 0
                      ? FlutterFlowTheme.of(context).course20
                      : FlutterFlowTheme.of(context).primaryText,
                  size: 20,
                ),
                title: Text(
                  FFLocalizations.of(context).getText('home'),
                ),
                selectedColor: FlutterFlowTheme.of(context).course20,
              ),
              SalomonBottomBarItem(
                icon: Icon(
                  FontAwesomeIcons.dumbbell,
                  color: activeTab == 1
                      ? FlutterFlowTheme.of(context).course20
                      : FlutterFlowTheme.of(context).primaryText,
                  size: 20,
                ),
                title: Text(
                  FFLocalizations.of(context).getText('cors'),
                ),
                selectedColor: FlutterFlowTheme.of(context).course20,
              ),
              SalomonBottomBarItem(
                icon: Icon(
                  FontAwesomeIcons.peopleGroup,
                  color: activeTab == 2
                      ? FlutterFlowTheme.of(context).course20
                      : FlutterFlowTheme.of(context).primaryText,
                  size: 20,
                ),
                title: Text(
                  FFLocalizations.of(context).getText('social'),
                ),
                selectedColor: FlutterFlowTheme.of(context).course20,
              ),
              SalomonBottomBarItem(
                icon: Icon(
                  FontAwesomeIcons.gear,
                  color: activeTab == 3
                      ? FlutterFlowTheme.of(context).course20
                      : FlutterFlowTheme.of(context).primaryText,
                  size: 20,
                ),
                title: Text(
                  FFLocalizations.of(context).getText('Impostazioni'),
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
