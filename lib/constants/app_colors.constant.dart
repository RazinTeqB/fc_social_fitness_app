import 'package:flutter/material.dart';

class AppColor {
  static const accentColor = Color(0xff4654a1);
  static const primaryColor = Color(0xff4654a1);
  static const primaryColorDark = Color(0xAA4654a1);
  static const cursorColor = Color(0xFF15616D);
  static final vendorOpenColor = Colors.green[900];
  static final vendorCloseColor = Colors.red[900];
  static const navBarColor = Color(0x0000ffff);
  static const KTweeterColor = Color(0xff00acee);
  //onboarding colors
  static const onboarding1Color = Color(0xFFF9F9F9);
  static const onboarding2Color = Color(0xFFF6EFEE);
  static const onboarding3Color = Color(0xFFFFFBFC);
  static const onboarding4Color = Color(0xFFFFFBFC);

  static const onboardingIndicatorDotColor = Color(0xFF30C0D9);
  static const onboardingIndicatorActiveDotColor = Color(0xFF15616D);

  //Shimmer Colors
  static final shimmerBaseColor = Colors.grey[300];
  static final shimmerHighlightColor = Colors.grey[200];

  //inputs
  static final inputFillColor = Colors.grey[200];
  static final iconHintColor = Colors.grey[500];

  //operation status colors
  static final successfulColor = Colors.green[400];
  static final waringColor = Colors.yellow[700];
  static final failedColor = Colors.red[400];
  static final cancelledColor = Colors.grey[700];
  static final enrouteColor = Colors.teal[500];

  static const textBlack = Color(0xFF1F2022);
  static const white = Color(0xFFFFFFFF);
  static const grey = Color(0xFFB6BDC6);
  static const loadingBlack = Color(0x80000000);

  static const textFieldBorder = Color(0xFFB9BBC5);

  static const disabledColor = Color(0xFFE1E1E5);
  static const errorColor = Color(0xFFF25252);

  static const homeBackgroundColor = Color.fromRGBO(252, 252, 252, 1);
  static const textGrey = Color(0xFF8F98A3);

  static const cardioColor = Color(0xFFFCB74F);
  static const armsColor = Color(0xFF5C9BA4);

  //
  static Color appBackground(BuildContext context) {
    /* var platformBrightness = MediaQuery.of(context).platformBrightness;
    if (platformBrightness == Brightness.dark) {
      return Colors.grey[800];
    } else {
      return Colors.white;
    }*/
    return  Colors.white;
  }

  static Color? statusColor(String status) {
    if (status.toLowerCase().contains("success") || status.toLowerCase().contains("deliver")) {
      return successfulColor;
    } else if (status.toLowerCase().contains("pending")) {
      return waringColor;
    } else if (status.toLowerCase().contains("fail")) {
      return failedColor;
    } else if (status.toLowerCase().contains("cancel")) {
      return cancelledColor;
    } else if (status.toLowerCase().contains("enroute")) {
      return enrouteColor;
    } else {
      return waringColor;
    }
  }

  static Color textColor(BuildContext context, {bool inverse = false}) {
    // var platformBrightness = MediaQuery.of(context).platformBrightness;
    /* if (platformBrightness == Brightness.dark) {
      return inverse ? Colors.black : Colors.white;
    } else {
      return inverse ? Colors.white : Colors.black;
    }*/
    return inverse ? Colors.white : Colors.black;
  }

  static Color amountTextColor(BuildContext context) {
    // var platformBrightness = MediaQuery.of(context).platformBrightness;
    /*éif (platformBrightness == Brightness.dark) {
      return accentColor;
    } else {
      return primaryColor;
    }*/
    return primaryColor;

  }

  static Color bottomNavigationItemSelectedColor(
      BuildContext context,
      ) {
    return accentColor;
  }

  static Color? hintTextColor(BuildContext context) {
    /*var platformBrightness = MediaQuery.of(context).platformBrightness;
    if (platformBrightness == Brightness.dark) {
      return Colors.grey[400];
    } else {
      return Colors.grey[600];
    }*/
    return Colors.grey[600];
  }
  static Color? textFieldBackground(BuildContext context) {
    /* var platformBrightness = MediaQuery.of(context).platformBrightness;
    if (platformBrightness == Brightness.dark) {
      return Colors.grey[300];
    } else {
      return Colors.grey[200];
    }*/
    return Colors.grey[200];
  }
  static Color? listItemBackground(BuildContext context) {
    /*var platformBrightness = MediaQuery.of(context).platformBrightness;
  if (platformBrightness == Brightness.dark) {
      return Colors.grey[700];
    } else {
      return Colors.grey[100];
    }*/
    return Colors.grey[100];
  }
}