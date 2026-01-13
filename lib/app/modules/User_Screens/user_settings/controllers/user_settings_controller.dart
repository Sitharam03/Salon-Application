import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';

class UserSettingsController extends GetxController {
  final pushNotifications = true.obs;
  final emailAlerts = false.obs;

  void togglePushNotifications(bool value) {
    pushNotifications.value = value;
  }

  void toggleEmailAlerts(bool value) {
    emailAlerts.value = value;
  }

  void deleteAccount() {
    // Navigate to success screen
    // In real app, API call would happen here
    Get.offAllNamed(AppRoutes.DELETE_ACCOUNT_SUCCESS);
  }
}
