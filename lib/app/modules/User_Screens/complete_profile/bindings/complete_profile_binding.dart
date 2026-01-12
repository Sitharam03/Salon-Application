import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/complete_profile/controllers/complete_profile_controller.dart';

class CompleteProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompleteProfileController>(
      () => CompleteProfileController(),
    );
  }
}
