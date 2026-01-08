import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/admin_auth/controllers/forgot_password_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(),
    );
  }
}
