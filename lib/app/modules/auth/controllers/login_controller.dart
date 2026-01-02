import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/core/utils/validators.dart';
import 'package:salon/app/routes/app_routes.dart';

class LoginController extends GetxController {
  // Text controller for phone input
  final phoneController = TextEditingController();

  // Observable states
  final _agreeToTerms = false.obs;
  final _isLoading = false.obs;

  // Getters
  bool get agreeToTerms => _agreeToTerms.value;
  bool get isLoading => _isLoading.value;

  // Computed property for button enabled state
  bool get isButtonEnabled {
    return phoneController.text.isNotEmpty && _agreeToTerms.value;
  }

  @override
  void onInit() {
    super.onInit();
    // Listen to phone controller changes to update button state
    phoneController.addListener(() => update());
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  /// Toggle terms agreement
  void setAgreeToTerms(bool value) {
    _agreeToTerms.value = value;
  }

  /// Validate and request OTP
  void validateAndGetOTP() {
    final phoneValidation = Validators.validatePhoneNumber(phoneController.text);
    
    if (phoneValidation != null) {
      _showSnackBar(phoneValidation);
      return;
    }

    if (!_agreeToTerms.value) {
      _showSnackBar('Please agree to Terms and Conditions');
      return;
    }

    _getOTP();
  }

  /// Simulate OTP request
  void _getOTP() {
    _isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      _isLoading.value = false;
      
      // Navigate to OTP screen with phone number
      Get.toNamed(
        AppRoutes.OTP,
        arguments: {'phoneNumber': phoneController.text},
      );
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

  /// Navigate to vendor signup (admin login)
  void goToVendorSignup() {
    Get.toNamed(AppRoutes.ADMIN_LOGIN);
  }
}
