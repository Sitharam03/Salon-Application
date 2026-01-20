import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salon/app/routes/app_routes.dart';

class AuthService extends GetxService {
  late SharedPreferences _prefs;
  final isLoggedIn = false.obs;
  final userType = ''.obs; // 'user' or 'admin'

  Future<AuthService> init() async {
    _prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = _prefs.getBool('isLoggedIn') ?? false;
    userType.value = _prefs.getString('userType') ?? '';
    return this;
  }

  Future<void> login(String type) async {
    await _prefs.setBool('isLoggedIn', true);
    await _prefs.setString('userType', type);
    isLoggedIn.value = true;
    userType.value = type;
  }

  Future<void> logout() async {
    await _prefs.setBool('isLoggedIn', false);
    await _prefs.setString('userType', '');
    isLoggedIn.value = false;
    userType.value = '';
    
    // Navigate to Login/Home based on app flow, usually Login
    // Since we have separate logins for User/Admin, we might default to User Login or a Landing logic.
    // For now, let's route to LOGIN (User Login) as default.
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
