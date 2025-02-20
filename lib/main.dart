import 'dart:io';
import 'package:fc_social_fitness/constants/app_routes.dart';
import 'package:fc_social_fitness/constants/app_strings.dart';
import 'package:fc_social_fitness/my_app.dart';
import 'package:fc_social_fitness/social/core/utility/injector.dart';
import 'package:fc_social_fitness/utils/app_database.dart';
import 'package:fc_social_fitness/utils/shared_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:wakelock/wakelock.dart';

const platform = MethodChannel('it.codeloops.fcsocialfitness/overlay');

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

Future<void> secureScreen() async {
  if (Platform.isAndroid) {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  } else if (Platform.isIOS) {
    //await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    //await platform.invokeMethod('showOverlay', {'message': 'Impossibile eseguire screenshot o registrazioni schermo'});
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.prepareDatabase();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  final sharePrefs = await init();

  Stripe.publishableKey = "pk_test_51PvIx6L2fNeLVLZyy76eALEOci7m7jW4qzkP95WTBD0kCE0mEVctfm2Yn1bzlkErzzZb4tQ96WAVJu9wkrI025JO00lnDa192r";

  HttpOverrides.global = MyHttpOverrides();

  int backendVersion = 110;
  int appVersion = 110;

  String startRoute = AppRoutes.onBoarding;

  await SharedManager.getPrefs();
  if (SharedManager.firstTimeOnApp()) {
    SharedManager.prefs!.setBool(AppStrings.firstTimeOnApp, false);
    startRoute = AppRoutes.onBoarding;
  } else {
    if (SharedManager.authenticated()) {
      startRoute = AppRoutes.homeRoute;
    } else {
      startRoute = AppRoutes.loginRoute;
    }
  }

  await secureScreen();
  Wakelock.enable();

  runApp(MyApp(
    startRoute: startRoute,
    sharePrefs: sharePrefs,
  ));
}

Future<SharedPreferences> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDependencies();

  await GetStorage.init();

  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  return await SharedPreferences.getInstance();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}