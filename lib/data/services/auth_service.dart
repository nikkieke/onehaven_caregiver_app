import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onehaven_caregiver_app/core/shared_prefs.dart';

final authServiceProvider = Provider(
  (ref) => AuthService(sharedPrefHandler: ref.watch(sharedPrefProvider)),
);

class AuthService {
  AuthService({this.sharedPrefHandler});

  final SharedPrefHandler? sharedPrefHandler;

  Future<bool> login({required String email, required String pass}) async {
    try {
      final emailCred = 'gretacharles@gmail.com';
      final passCred = 'OneHaven';
      //validate credentials
      if (emailCred == email && passCred == pass) {
        //save fake token to shared pref
        sharedPrefHandler?.setString('token', '1234567890');
        // simulate real api call
        await Future.delayed(Duration(seconds: 5));
        return true;
      } else {
        await Future.delayed(Duration(seconds: 5));
        return false;
      }
    } catch (e) {
      debugPrint('error $e');
      return false;
    }
  }
}
