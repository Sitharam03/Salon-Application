import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/admin_auth/controllers/admin_signup_controller.dart';

class AdminSignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminSignupController>(
      () => AdminSignupController(),
    );
  }
}
