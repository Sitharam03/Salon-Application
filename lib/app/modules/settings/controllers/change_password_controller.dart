import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';

class ChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isCurrentPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  final isLoading = false.obs;

  void toggleCurrentPasswordVisibility() => isCurrentPasswordVisible.toggle();
  void toggleNewPasswordVisibility() => isNewPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  void updatePassword() {
    String current = currentPasswordController.text;
    String newPass = newPasswordController.text;
    String confirmPass = confirmPasswordController.text;

    if (current.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields', 
          backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.red);
      return;
    }

    if (newPass.length < 8) {
       Get.snackbar('Error', 'Password must be at least 8 characters long',
           backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.red);
       return;
    }

    if (newPass != confirmPass) {
      Get.snackbar('Error', 'Passwords do not match',
          backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.red);
      return;
    }

    isLoading.value = true;
    
    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      // Navigate to Success Screen
      Get.offNamed(AppRoutes.PASSWORD_UPDATED);
    });
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
