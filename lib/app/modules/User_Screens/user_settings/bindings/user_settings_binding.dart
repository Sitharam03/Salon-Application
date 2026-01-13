import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/user_settings/controllers/user_settings_controller.dart';

class UserSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserSettingsController>(
      () => UserSettingsController(),
    );
  }
}
