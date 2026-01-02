import 'package:get/get.dart';
import 'package:salon/app/modules/admin/controllers/admin_login_controller.dart';
import 'package:salon/app/modules/admin/controllers/admin_otp_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminLoginController>(() => AdminLoginController());
    Get.lazyPut<AdminOTPController>(() => AdminOTPController());
  }
}
