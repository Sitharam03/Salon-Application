import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/settings/controllers/settings_controller.dart';
import 'package:salon/app/modules/Admin_Screens/settings/controllers/change_password_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
  }
}

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>(
      () => ChangePasswordController(),
    );
  }
}
