import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../constants/app_routes.dart';
import '../../../../constants/app_strings.dart';
import '../../../../my_app.dart';
import '../../../../utils/app_database.dart';
import '../../../../utils/flutter_flow.util.dart';
import '../../../../utils/flutter_flow_theme.util.dart';
import '../../../../utils/shared_manager.dart';
import '../utils/internationalization.util.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).trainingsBackground,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 50),
          Container(
              height: 150,
              width: 150,
              child: Image.asset(FlutterFlowTheme.of(context).logoColor)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Made by ",
              style: FlutterFlowTheme.of(context).bodyText1,
            ),
            Text(
              "Codeloops",
              style: FlutterFlowTheme.of(context).bodyText1.merge(
                  TextStyle(color: FlutterFlowTheme.of(context).course20)),
            )
          ]),
          SizedBox(height: 50),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).trainings,
                  borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                child: Text(FFLocalizations.of(context).getText('Seleziona lingua'),
                    style: FlutterFlowTheme.of(context).bodyText1),
                onTap: () async {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                          height: 200,
                          color:
                          FlutterFlowTheme.of(context).secondaryBackground,
                          child: Column(children: [
                            SizedBox(height: 30),
                            GestureDetector(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    borderRadius: BorderRadius.circular(15)),
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Italiano",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1),
                                    MyApp.of(context)
                                        .getLocale()!
                                        .languageCode ==
                                        'it'
                                        ? Icon(FontAwesomeIcons.circleDot,
                                        size: 20,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText)
                                        : Icon(FontAwesomeIcons.circle,
                                        size: 20,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText)
                                  ],
                                ),
                              ),
                              onTap: () {
                                MyApp.of(context).setLocale(
                                    Locale.fromSubtags(languageCode: 'it'));
                                SharedManager.setString(
                                    AppStrings.appLocale, 'it');
                                Navigator.pop(context);
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    borderRadius: BorderRadius.circular(15)),
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("English",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1),
                                    MyApp.of(context)
                                        .getLocale()!
                                        .languageCode ==
                                        'en'
                                        ? Icon(FontAwesomeIcons.circleDot,
                                        size: 20,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText)
                                        : Icon(FontAwesomeIcons.circle,
                                        size: 20,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText)
                                  ],
                                ),
                              ),
                              onTap: () {
                                MyApp.of(context).setLocale(
                                    Locale.fromSubtags(languageCode: 'en'));
                                SharedManager.setString(
                                    AppStrings.appLocale, 'en');
                                Navigator.pop(context);
                              },
                            )
                          ]));
                    },
                  );
                },
              )),

          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).trainings,
                  borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              child: GestureDetector(
                child: Text(FFLocalizations.of(context).getText('abbonamenti'),
                    style: FlutterFlowTheme.of(context).bodyText1),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.mySubscriptionRoute);
                },
              )),

          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).trainings,
                  borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              child: GestureDetector(
                child: Text(FFLocalizations.of(context).getText('assistenza'),
                    style: FlutterFlowTheme.of(context).bodyText1),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.helpRoute);
                },
              )),

          Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).trainings,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(FFLocalizations.of(context).getText('Tema scuro'),
                    style: FlutterFlowTheme.of(context).bodyText1,
                  ),
                  Theme.of(context).brightness == Brightness.light
                      ? Switch.adaptive(
                      value: false,
                      onChanged: (newValue) {
                        setDarkModeSetting(context, ThemeMode.dark);
                      })
                      : Switch.adaptive(
                      value: true,
                      onChanged: (newValue) {
                        setDarkModeSetting(context, ThemeMode.light);
                      }),
                ],
              )),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).course20,
                  borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.all(15),
              child: GestureDetector(
                child: Text("Logout",
                    style: FlutterFlowTheme.of(context)
                        .bodyText1
                        .merge(TextStyle(color: Colors.white))),
                onTap: () async {
                  await AppDatabase.deleteCurrentUser();
                  await SharedManager.prefs
                      ?.setBool(AppStrings.authenticated, false);
                  Navigator.pushNamed(context, AppRoutes.loginRoute);
                },
              )),
        ],
      ),
    );
  }
}

