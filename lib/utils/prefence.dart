
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static late SharedPreferences preferences;

  static bool getBool(String key) {
    return preferences.getBool(key) ?? false;
  }

  static String getString(String key) {
    return preferences.getString(key) ?? "";
  }

  static int getint(String key) {
    return preferences.getInt(key) ?? 0;
  }

  static Future<bool> setBool(String key, bool value) async {
    return await preferences.setBool(key, value);
  }

  static Future<bool> setString(String key, String value) async {
    return await preferences.setString(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    return await preferences.setInt(key, value);
  }
}

class PrefKeys {
  static const token = "token";
  static const userstatus = "userstatus";
  static const branchName = "branchName";
  static const branchLength = "branchLength";
  static const licenseNo = "licenseNo";
  static const locationId = "locationId";
  static const phoneNumber = "phoneNumber";
  static const email = "email";
  static const staffId = "staffId";
  static const userType = "userType";
  static const financialYear = "financialYear";
  static const coludIdMess = "coludId";
  static const coludIdHostel = "coludId";
  static const sessionId = "sessionId";
  static const sessionDate = "sessionDate";
}

logoutPrefData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(PrefKeys.token);
  await prefs.remove(PrefKeys.userstatus);
  await prefs.remove(PrefKeys.branchLength);
  await prefs.remove(PrefKeys.licenseNo);
  await prefs.remove(PrefKeys.locationId);
  await prefs.remove(PrefKeys.phoneNumber);
  await prefs.remove(PrefKeys.email);
  await prefs.remove(PrefKeys.branchName);
  await prefs.remove(PrefKeys.staffId);
  await prefs.remove(PrefKeys.userType);
  await prefs.remove(PrefKeys.financialYear);
  await prefs.remove(PrefKeys.coludIdHostel);
  await prefs.remove(PrefKeys.coludIdMess);
  await prefs.remove(PrefKeys.sessionId);
  await prefs.remove(PrefKeys.sessionDate);
}
