import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ConstManager {
  // app settings
  static String userLang = "English";
  static bool dark = true;

  static String userid = "";

  static String os = Platform.operatingSystem;
  static bool first_use = false;

  // IPOs settings
  static String market = "All";
  static DateTime fromDate = DateTime.now().subtract(const Duration(days: 30));
  static DateTime toDate = DateTime.now().add(const Duration(days: 60));

  // cookies
  static String fullCookie = "";
  static String fullUrl = "";
  static DateTime lastTimeGetCookies =
      DateTime.parse("1970-01-01 00:00:00.000");

  // IPOs data
  static List<dynamic> ipoList = [];
  static Map<int, List> banks = {};
  static void saveSettings() async {
    cashHelper.SavaData(key: "fullCookie", value: fullCookie);
    cashHelper.SavaData(key: "fullUrl", value: fullUrl);
    cashHelper.SavaData(
        key: "lastTimeGetCookies", value: lastTimeGetCookies.toString());
    cashHelper.SavaData(key: "lang", value: userLang);
    cashHelper.SavaData(key: "dark", value: dark);
  }

  static void getSettings() {
    try {
      userid = cashHelper.getData(key: "userid");
      userLang = cashHelper.getData(key: "lang");
      first_use = cashHelper.getData(key: "first_use");
      lastTimeGetCookies =
          DateTime.parse(cashHelper.getData(key: "lastTimeGetCookies"));
      fullCookie = cashHelper.getData(key: "fullCookie");
      fullUrl = cashHelper.getData(key: "fullUrl");
    } catch (e) {
      if (userid == "") {
        userid = const Uuid().v1();
        cashHelper.SavaData(key: "userid", value: userid);
        cashHelper.SavaData(key: "first_use", value: true);
      }
      print(e);
    }
  }
}

class cashHelper {
  static late SharedPreferences sharedPreferences;

  static Init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic getData({required String key}) {
    if (!sharedPreferences.containsKey(key)) return null;
    return sharedPreferences.get(key);
  }

  static Future<bool> SavaData(
      {required String key, required dynamic value}) async {
    if (value == null) return false;
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    return await sharedPreferences.setDouble(key, value);
  }

  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }
}
