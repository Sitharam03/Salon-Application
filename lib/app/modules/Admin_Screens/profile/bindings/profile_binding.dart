import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/profile/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
