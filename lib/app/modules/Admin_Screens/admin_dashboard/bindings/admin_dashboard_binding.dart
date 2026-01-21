import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/admin_dashboard/controllers/admin_dashboard_controller.dart';
import 'package:salon/app/modules/Admin_Screens/services/controllers/services_controller.dart';
import 'package:salon/app/modules/Admin_Screens/notifications/controllers/notifications_controller.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminDashboardController>(
      () => AdminDashboardController(),
    );
    Get.lazyPut<ServicesController>(
      () => ServicesController(),
    );
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
    );
  }
}
