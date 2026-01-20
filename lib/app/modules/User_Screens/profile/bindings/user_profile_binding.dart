import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/profile/controllers/user_profile_controller.dart';

class UserProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProfileController>(
      () => UserProfileController(),
    );
  }
}
