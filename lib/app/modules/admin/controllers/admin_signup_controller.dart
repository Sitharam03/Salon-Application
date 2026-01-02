import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';

class AdminSignupController extends GetxController {
  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observables
  final _isPasswordVisible = false.obs;
  final _isLoading = false.obs;

  // Getters
  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get isLoading => _isLoading.value;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  void signup() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty) {
      Get.snackbar('Error', 'Please enter your full name',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Please enter a valid email address',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (password.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    _simulateSignup();
  }

  void _simulateSignup() {
    _isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      _isLoading.value = false;
      // Navigate to Login after successful signup
      Get.snackbar('Success', 'Account created successfully',
          snackPosition: SnackPosition.BOTTOM);
      Get.offNamed(AppRoutes.ADMIN_SUCCESS);
    });
  }

  void goToLogin() {
    Get.back(); // Or Get.toNamed(AppRoutes.ADMIN_LOGIN) if replacing
  }
}
