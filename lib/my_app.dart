import 'package:fc_social_fitness/constants/app_routes.dart';
import 'package:fc_social_fitness/constants/app_strings.dart';
import 'package:fc_social_fitness/social/core/utility/constant.dart';
import 'package:fc_social_fitness/social/presentation/widgets/global/others/multi_bloc_provider.dart';

import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:fc_social_fitness/utils/internationalization.util.dart';
import 'package:fc_social_fitness/utils/router.dart' as router;
import 'package:fc_social_fitness/utils/shared_manager.dart';
import 'package:fc_social_fitness/views/entry.page.dart';
import 'package:fc_social_fitness/views/home.page.dart';
import 'package:fc_social_fitness/views/login.page.dart';
import 'package:fc_social_fitness/views/onboarding_page.dart';
import 'package:fc_social_fitness/views/subscription.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.startRoute,required this.sharePrefs}) : super(key: key);
  final String startRoute;
  final SharedPreferences sharePrefs;
  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;
  static Locale? _locale;
  String? myId;
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    _locale = Locale(SharedManager.getString(AppStrings.appLocale, defaultValue: 'it'));
    myId = widget.sharePrefs.getString("myPersonalId");
    if (myId != null) myPersonalId = myId!;
    super.initState();
  }

  void setLocale(Locale value) => setState(() => _locale = value);

  Locale? getLocale() {
    return _locale;
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
    isThatMobile =
        platform == TargetPlatform.iOS || platform == TargetPlatform.android;
    isThatAndroid = platform == TargetPlatform.android;
    return MultiBlocs(materialApp(context));
  }
  Widget materialApp(BuildContext context) {
          return MaterialApp(
            locale: _locale,
            onGenerateRoute: router.generateRoute,
            localizationsDelegates: const [
              FFLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale("en",''),Locale("it",'')],
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Fc Social Fitness',
            theme: ThemeData(brightness: Brightness.light),
            darkTheme: ThemeData(brightness: Brightness.dark),
            themeMode: _themeMode,
            home: EntryPage(startPage: getStartRoute(),)
          );
  }

  Widget getStartRoute() {
    Widget returnValue;
    switch (widget.startRoute) {
      case AppRoutes.onBoarding:
        returnValue = OnboardingPage();
        break;
      case AppRoutes.homeRoute:
        returnValue = HomePage();
        break;
      case AppRoutes.loginRoute:
        returnValue = SignInPage();
        break;
      case AppRoutes.subscriptionRoute:
        returnValue = SubscriptionPage();
        break;
      default:
        returnValue = OnboardingPage();
        break;
    }
    return returnValue;
  }


}
