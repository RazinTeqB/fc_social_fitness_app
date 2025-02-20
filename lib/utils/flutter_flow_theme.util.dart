import 'package:fc_social_fitness/constants/app_animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kThemeModeKey = '__theme_mode__';
SharedPreferences? _prefs;

abstract class FlutterFlowTheme {
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static ThemeMode get themeMode {
    final darkMode = _prefs?.getBool(kThemeModeKey);
    return darkMode == null
        ? ThemeMode.system
        : darkMode
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  static void saveThemeMode(ThemeMode mode) => mode == ThemeMode.system
      ? _prefs?.remove(kThemeModeKey)
      : _prefs?.setBool(kThemeModeKey, mode == ThemeMode.dark);

  static FlutterFlowTheme of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? DarkModeTheme()
          : LightModeTheme();

  late String loadingAnimation;
  late String logoColor;
  late Color primaryColor;
  late Color secondaryColor;
  late Color tertiaryColor;
  late Color alternate;
  late Color primaryBackground;
  late Color primaryBackgroundAlternate;
  late Color secondaryBackground;
  late Color secondaryBackgroundAlternate;
  late Color trainings;
  late Color trainingsBackground;
  late Color primaryText;
  late Color primaryTextAlternate;
  late Color secondaryText;
  late Color white;
  late Color grey;
  late Color primaryBtnText;
  late Color lineColor;
  late Color cursorColor;
  late Color disabled;
  late Color loading;
  late Color textFieldBorder;
  late Color transparent;
  late Color black;
  late Color dashboardHeader;
  late Color permanentHeader;
  late Color perla;
  late Color blu;
  //colori corsi
  late Color course1;
  late Color course2;
  late Color course3;
  late Color course4;
  late Color course5;
  late Color course6;
  late Color course7;
  late Color course8;
  late Color course9;
  late Color course10;
  late Color course11;
  late Color course12;
  late Color course13;
  late Color course14;
  late Color course15;
  late Color course16;
  late Color course17;
  late Color course18;
  late Color course19;
  late Color course20;
  late Color course21;

  late Color success;
  late Color machineStatusIdle;
  late Color error;
  late Color search;

  late Color oliStatusTableRunning;

  late Color oliStatusRunning;
  late Color oliStatusPaused;
  late Color oliStatusWaiting;
  late Color oliStatusCompleted;

  String get title1Family => typography.title1Family;
  TextStyle get title1 => typography.title1;
  String get title2Family => typography.title2Family;
  TextStyle get title2 => typography.title2;
  String get title3Family => typography.title3Family;
  TextStyle get title3 => typography.title3;
  String get subtitle1Family => typography.subtitle1Family;
  TextStyle get subtitle1 => typography.subtitle1;
  String get subtitle2Family => typography.subtitle2Family;
  TextStyle get subtitle2 => typography.subtitle2;
  String get bodyText1Family => typography.bodyText1Family;
  TextStyle get bodyText1 => typography.bodyText1;
  String get bodyText1FamilyTablet => typography.bodyText1FamilyTablet;
  TextStyle get bodyText1Tablet => typography.bodyText1Tablet;
  String get bodyText2Family => typography.bodyText2Family;
  TextStyle get bodyText2 => typography.bodyText2;
  TextStyle get bodyText3 => typography.bodyText3;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends FlutterFlowTheme {
  late String loadingAnimation = AppAnimations.loadingLight;
  late String logoColor = 'assets/images/rev3mod.png';
  late Color primaryColor = const Color(0xFF81ba27);
  late Color secondaryColor = const Color(0xFF39D2C0);
  late Color tertiaryColor = const Color(0xFFEE8B60);
  late Color alternate = const Color(0xFFFF5963);
  late Color primaryBackground = const Color(0xFFF1F4F8);
  late Color trainingsBackground = const Color(0xFFF1F4F8);
  late Color primaryBackgroundAlternate = const Color(0xFFFFFFFF);
  late Color secondaryBackground = const Color(0xFFFFFFFF);
  late Color secondaryBackgroundAlternate = const Color(0xFFF1F4F8);
  late Color trainings = const Color(0xFFFFFFFF);
  late Color dashboardHeader = const Color(0xFF1A1F24);
  late Color permanentHeader = const Color(0xFF1A1F24);
  late Color primaryText = const Color(0xFF101213);
  late Color primaryTextAlternate = const Color(0xFFFFFFFF);
  late Color secondaryText = const Color(0xFF57636C);
  late Color white = const Color(0xFFFFFFFF);
  late Color primaryBtnText = Color(0xFFFFFFFF);
  late Color lineColor = Color(0xFFE0E3E7);
  late Color navColor = Color(0x0000ffff);
  late Color cursorColor = Color(0xFF15616D);
  late Color loading = Color(0x80000000);
  late Color textFieldBorder = Color(0xFFB9BBC5);
  late Color transparent = Color(0x00000000);
  late Color black = Color(0x80000000);
  late Color blu = Color(0x063970);


  late Color success = Color(0xFF2dc937);
  late Color machineStatusIdle = Color(0xFFdb7b2b);
  late Color error = Color(0xFFcc3232);
  late Color grey = const Color(0xFF95A1AC);

  late Color oliStatusTableRunning = Color(0xffdbc200);
  late Color disabled = Color(0xffdbc200);

  late Color oliStatusRunning = Color(0xFFE1E1E5);
  late Color oliStatusCompleted = Color(0xFF2dc937);
  late Color oliStatusPaused = Color(0xFFdb7b2b);
  late Color oliStatusWaiting = Color(0xFFcc3232);
  late Color perla = Color(0xffC4C6CC);
  late Color search =  Color(0xffF0F1F5);

  //colori corsi
  late Color course1 = Color(0xFF30C0D9);
  late Color course2 = Color(0xFF15616D);
  late Color course3 = Color(0xAA4654a1);
  late Color course4 = Color(0xFF66BB6A);
  late Color course5 = Color(0xFFC0CA33);
  late Color course6 = Color(0xFFF9A825);
  late Color course7 = Color(0xFFF4511E);
  late Color course8 = Color(0xFF616161);
  late Color course9 = Color(0xFF546E7A);
  late Color course10 = Color(0xFF0288D1);
  late Color course11 = Color(0xFF7E57C2);
  late Color course12 = Color(0xFFB39DDB);
  late Color course13 = Color(0xFFCE93D8);
  late Color course14 = Color(0xFFEF5350);
  late Color course15 = Color(0xFF5C9BA4);
  late Color course16 = Color(0xFFFCB74F);
  late Color course17 = Color(0xFFe28743);
  late Color course18 = Color(0xFF439ee2);
  late Color course19 = Color(0xFF43e287);
  late Color course20 = Color(0xFF8743e2);
  late Color course21 = Color(0xFF5d9c71);
}

abstract class Typography {
  String get title1Family;
  TextStyle get title1;
  String get title2Family;
  TextStyle get title2;
  String get title3Family;
  TextStyle get title3;
  String get subtitle1Family;
  TextStyle get subtitle1;
  String get subtitle2Family;
  TextStyle get subtitle2;
  String get bodyText1Family;
  TextStyle get bodyText1;
  String get bodyText1FamilyTablet;
  TextStyle get bodyText1Tablet;
  String get bodyText2Family;
  TextStyle get bodyText2;
  String get bodyText3Family;
  TextStyle get bodyText3;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final FlutterFlowTheme theme;

  String get title1Family => 'Poppins';
  TextStyle get title1 => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 24,
      );
  String get title2Family => 'Poppins';
  TextStyle get title2 => GoogleFonts.getFont(
        'Poppins',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      );
  String get title3Family => 'Poppins';
  TextStyle get title3 => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 20,
      );
  String get subtitle1Family => 'Poppins';
  TextStyle get subtitle1 => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      );
  String get subtitle2Family => 'Poppins';
  TextStyle get subtitle2 => GoogleFonts.getFont(
        'Poppins',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      );
  String get bodyText1Family => 'Poppins';
  TextStyle get bodyText1 => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      );
  String get bodyText1FamilyTablet => 'Poppins';
  TextStyle get bodyText1Tablet => GoogleFonts.getFont(
    'Poppins',
    color: theme.primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 20,
  );
  String get bodyText2Family => 'Poppins';
  TextStyle get bodyText2 => GoogleFonts.getFont(
        'Poppins',
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      );
  String get bodyText3Family => 'Poppins';
  TextStyle get bodyText3 => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 30,
      );
}

class DarkModeTheme extends FlutterFlowTheme {
  late String loadingAnimation = AppAnimations.loadingDark;
  late String logoColor = 'assets/images/image.png';
  late Color primaryColor = const Color(0xFF81ba27);
  late Color secondaryColor = const Color(0xFF39D2C0);
  late Color tertiaryColor = const Color(0xFFEE8B60);
  late Color alternate = const Color(0xFFFF5963);
  late Color success = Color(0xFF2dc937);
  late Color secondaryBackground = const Color(0xFF101213);
  late Color trainingsBackground = const Color(0xFF101213);
  late Color trainings = const Color(0xFF1A1F24);
  late Color secondaryBackgroundAlternate = const Color(0xFF1A1F24);
  late Color primaryBackground = const Color(0xFF1A1F24);
  late Color primaryBackgroundAlternate = const Color(0xFF101213);
  late Color dashboardHeader = const Color(0xFFFFFFFF);
  late Color permanentHeader = const Color(0xFF1A1F24);
  late Color cursorColor = Color(0xFF15616D);
  late Color primaryText = const Color(0xFFFFFFFF);
  late Color primaryTextAlternate = const Color(0xFFFFFFFF);
  late Color secondaryText = const Color(0xFF95A1AC);
  late Color white = const Color(0xFFFFFFFF);
  late Color primaryBtnText = Color(0xFFFFFFFF);
  late Color lineColor = Color(0xFF22282F);
  late Color machineStatusRunning = Color(0xFF2dc937);
  late Color machineStatusIdle = Color(0xFFdb7b2b);
  late Color machineStatusDown = Color(0xFFcc3232);
  late Color oliStatusTableRunning = Color(0xffdbc200);
  late Color oliStatusRunning = Color(0xFF74f2ce);
  late Color oliStatusCompleted = Color(0xFF2dc937);
  late Color oliStatusPaused = Color(0xFFdb7b2b);
  late Color oliStatusWaiting = Color(0xFFcc3232);
  late Color grey = const Color(0xFF95A1AC);
  late Color textFieldBorder = Color(0xFFB9BBC5);
  late Color transparent = Color(0x00000000);
  late Color black = Color(0x80000000);
  late Color search =  Color(0xffF0F1F5);
  late Color error = Color(0xFFcc3232);


  //colori corsi
  late Color course1 = Color(0xFF30C0D9);
  late Color course2 = Color(0xFF15616D);
  late Color course3 = Color(0xAA4654a1);
  late Color course4 = Color(0xFF66BB6A);
  late Color course5 = Color(0xFFC0CA33);
  late Color course6 = Color(0xFFF9A825);
  late Color course7 = Color(0xFFF4511E);
  late Color course8 = Color(0xFF616161);
  late Color course9 = Color(0xFF546E7A);
  late Color course10 = Color(0xFF0288D1);
  late Color course11 = Color(0xFF7E57C2);
  late Color course12 = Color(0xFFB39DDB);
  late Color course13 = Color(0xFFCE93D8);
  late Color course14 = Color(0xFFEF5350);
  late Color course15 = Color(0xFF5C9BA4);
  late Color course16 = Color(0xFFFCB74F);
  late Color course17 = Color(0xFFe28743);
  late Color course18 = Color(0xFF439ee2);
  late Color course19 = Color(0xFF43e287);
  late Color course20 = Color(0xFF8743e2);
  late Color course21 = Color(0xFF5d9c71);
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily!,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              decoration: decoration,
              height: lineHeight,
            );
}
