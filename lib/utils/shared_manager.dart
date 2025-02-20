import 'package:fc_social_fitness/constants/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedManager {
  //
  static SharedPreferences? prefs;

  static Future<SharedPreferences> getPrefs() async {
    prefs ??= await SharedPreferences.getInstance();
    return prefs!;
  }

  //
  static bool firstTimeOnApp() {
    return prefs!.getBool(AppStrings.firstTimeOnApp) ?? true;
  }
  //
  static bool authenticated() {
    return prefs!.getBool(AppStrings.authenticated) ?? false;
  }

  static bool profileInserted() {
    return prefs!.getBool(AppStrings.profileInserted) ?? false;
  }

  static bool getBool(String key) {
    return prefs!.getBool(key) ?? true;
  }
  static Future<bool> setBool(String key,bool value) async {
    prefs!.setBool(key,value);
    return getBool(key);
  }

  static String getString(String key,{String? defaultValue}) {
    return prefs!.getString(key) ?? defaultValue ?? "";
  }
  static Future<String> setString(String key,String value) async {
    prefs!.setString(key,value);
    return getString(key);
  }

  static int getInt(String key) {
    return prefs!.getInt(key) ?? 0;
  }
  static Future<int> setInt(String key,int value) async {
    prefs!.setInt(key,value);
    return getInt(key);
  }


}