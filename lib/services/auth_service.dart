import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // حفظ كلمة السر في الذاكرة
  Future<void> setPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_password', password);
  }

  // التحقق من كلمة السر
  Future<bool> checkPassword(String inputPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPassword = prefs.getString('app_password');
    return savedPassword == inputPassword;
  }

  // التحقق إذا كانت كلمة السر مضبوطة
  Future<bool> isPasswordSet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('app_password');
  }

  // تغيير كلمة السر
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    final isValid = await checkPassword(oldPassword);
    if (isValid) {
      await setPassword(newPassword);
      return true;
    }
    return false;
  }
}
