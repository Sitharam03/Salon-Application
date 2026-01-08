import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/user_auth/controllers/login_controller.dart';
import 'package:salon/app/modules/User_Screens/user_auth/controllers/otp_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<OTPController>(() => OTPController());
  }
}
