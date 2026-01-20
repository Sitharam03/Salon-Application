import 'package:get/get.dart';
import '../../dashboard/controllers/user_dashboard_controller.dart';

class UserNotificationsController extends GetxController {
  // Access global dashboard controller for notifications data
  UserDashboardController get dashboardController {
    try {
      return Get.find<UserDashboardController>();
    } catch (e) {
      // Fallback if accessed without dashboard being ready (shouldn't happen in main flow)
      return Get.put(UserDashboardController());
    }
  }

  // Proxy getters and methods
  List<Map<String, dynamic>> get notifications => dashboardController.notifications;
  void markAllAsRead() => dashboardController.markAllAsRead();
  void onNotificationTap(Map<String, dynamic> n) => dashboardController.onNotificationTap(n);
}
