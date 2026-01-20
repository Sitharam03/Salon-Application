import 'package:get/get.dart';
import '../controllers/user_notifications_controller.dart';

class UserNotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserNotificationsController>(
      () => UserNotificationsController(),
    );
  }
}
