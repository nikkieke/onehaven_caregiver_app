import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefProvider = Provider((ref) => SharedPrefHandler());

class SharedPrefHandler {
  SharedPrefHandler._();

  factory SharedPrefHandler() => instance;

  static final instance = SharedPrefHandler._();

  SharedPreferences? sharedPreferences;

  Future<SharedPreferences> init() async {
    return sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) async {
    await sharedPreferences?.setString(key, value);
    return true;
  }

  Future<String?> getString(String key) async {
    final result = sharedPreferences?.getString(key);
    return result;
  }
}
