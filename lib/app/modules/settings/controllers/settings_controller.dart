import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';

class SettingsController extends GetxController {
  final isNotificationsEnabled = true.obs;

  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
  }

  void navigateToEditProfile() {
    Get.toNamed(AppRoutes.SHOP_DETAILS, arguments: {'isEditing': true});
  }

  void navigateToChangePassword() {
    Get.toNamed(AppRoutes.CHANGE_PASSWORD);
  }
  
  void navigateToPrivacyPolicy() {
    Get.snackbar('Coming Soon', 'Privacy Policy not implemented yet');
  }
  
  void navigateToHelpSupport() {
    Get.snackbar('Coming Soon', 'Help & Support not implemented yet');
  }
  
  void navigateToAboutUs() {
    Get.snackbar('Coming Soon', 'About Us not implemented yet');
  }

  void logout() {
    // Implement logout logic here
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
