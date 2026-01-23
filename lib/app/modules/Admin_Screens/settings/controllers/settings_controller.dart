import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';

class SettingsController extends GetxController {
  final isNotificationsEnabled = true.obs;

  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
  }

  void navigateToEditProfile() {
    Get.toNamed(
      AppRoutes.SHOP_DETAILS,
      arguments: {'isEditing': true, 'showTimings': false},
    );
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

  void deleteAccount() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              // Navigate to success or perform deletion logic
              Get.offAllNamed(AppRoutes.DELETE_ACCOUNT_SUCCESS);
            },
            child: const Text('Delete', style: TextStyle(color: Color(0xFFE22424))),
          ),
        ],
      ),
    );
  }
}
