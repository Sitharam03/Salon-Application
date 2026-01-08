import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/core/utils/validators.dart';
import 'package:salon/app/routes/app_routes.dart';

class AdminLoginController extends GetxController {
  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable states
  final _isPasswordVisible = false.obs;
  final _isLoading = false.obs;

  // Getters
  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  /// login
  void login() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (!GetUtils.isEmail(email)) {
      _showSnackBar('Please enter a valid email address');
      return;
    }

    if (password.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }

    _simulateLogin();
  }

  /// Simulate Login request
  void _simulateLogin() {
    _isLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      _isLoading.value = false;
      // Navigate to success or home
      Get.toNamed(AppRoutes.ADMIN_SUCCESS); 
    });
  }



  /// Show snackbar message
  void _showSnackBar(String message) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Navigate to customer signin
  void goToCustomerSignin() {
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  /// Go to vendor signup
  void goToVendorSignup() {
    Get.toNamed(AppRoutes.ADMIN_SIGNUP);
  }
}
