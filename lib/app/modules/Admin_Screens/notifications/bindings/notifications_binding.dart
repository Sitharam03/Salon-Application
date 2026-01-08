import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/notifications/controllers/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
    );
  }
}
