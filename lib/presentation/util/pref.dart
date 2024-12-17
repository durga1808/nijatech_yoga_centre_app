import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _prefs;

  static Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }
 static Future<void> clearUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("Name");
    await prefs.remove("Gender");
    
  }

  // Setters


  
  static Future<bool> setLanguage(String key, String value) async =>
    await _prefs.setString(key, value);
  
 
  static Future<bool> setUserName(String key, String value) async =>
      await _prefs.setString(key, value);

  static Future<bool> setName(String key, String value) async =>
      await _prefs.setString(key, value);

  static Future<bool> setID(String key, int value) async =>
      await _prefs.setInt(key, value);

  static Future<bool> setCenterID(String key, int value) async =>
      await _prefs.setInt(key, value);

  static Future<bool> setCenterName(String key, String value) async =>
      await _prefs.setString(key, value);

  static Future<bool> setLoggedIn(String key, bool value) async =>
      await _prefs.setBool(key, value);

  static Future<bool> setMobileNo(String key, String value) async =>
      await _prefs.setString(key, value);

  static Future<bool> setGender(String key, String value) async =>
      await _prefs.setString(key, value);

  static Future<bool> setSuperUser(String key, int value) async =>
      await _prefs.setInt(key, value);

  // Getters
  static bool? getLoggedIn(String key) => _prefs.getBool(key);

  static String? getUserName(String key) => _prefs.getString(key);

  static String? getName(String key) => _prefs.getString(key);

  static int? getID(String key) => _prefs.getInt(key);

  static int? getCenterID(String key) => _prefs.getInt(key);

  static String? getCenterName(String key) => _prefs.getString(key);

  static String? getMobileNo(String key) => _prefs.getString(key);

  static String? getGender(String key) => _prefs.getString(key);

  static int? getSupeUser(String key) => _prefs.getInt(key);
   
  static String? getLanguage(String key) => _prefs.getString(key); 
  // Deletes
  static Future<bool> remove(String key) async => await _prefs.remove(key);

  static Future<bool> clear() async => await _prefs.clear();
}
