import 'package:get/get.dart';
import 'package:salon/app/modules/settings/controllers/settings_controller.dart';
import 'package:salon/app/modules/settings/controllers/change_password_controller.dart';

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
