import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'dart:async';

class ForgotPasswordController extends GetxController {
  // Step 1: Email
  final emailController = TextEditingController();
  
  // Step 2: OTP
  final List<TextEditingController> otpControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  
  // Step 3: Password
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController(); // Added for safety, though design shows 1 new, 1 confirm commonly or just new + confirm. 
  // Design "Image 2" shows "New Password" and "Confirm New Password".
  
  // Observables
  final _isLoading = false.obs;
  final _secondsRemaining = 30.obs;
  final _isNewPassVisible = false.obs;
  final _isConfirmPassVisible = false.obs;
  
  Timer? _timer;

  // Getters
  bool get isLoading => _isLoading.value;
  int get secondsRemaining => _secondsRemaining.value;
  bool get isNewPassVisible => _isNewPassVisible.value;
  bool get isConfirmPassVisible => _isConfirmPassVisible.value;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // --- Step 1: Send Email ---
  void sendEmail() {
    final email = emailController.text.trim();
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Please enter a valid email address', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    _isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      _isLoading.value = false;
      // Simulate sending email
      Get.toNamed(AppRoutes.FORGOT_PASSWORD_VERIFY);
      startTimer();
    });
  }

  // --- Step 2: OTP ---
  void onOTPFieldChange(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void startTimer() {
    _secondsRemaining.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining.value > 0) {
        _secondsRemaining.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  void resendOTP() {
    startTimer();
    Get.snackbar('Sent', 'A new code has been sent to your email.', snackPosition: SnackPosition.BOTTOM);
  }

  void verifyOTP() {
    String otp = otpControllers.map((e) => e.text).join();
    if (otp.length != 4) {
       Get.snackbar('Error', 'Please enter the complete 4-digit code', snackPosition: SnackPosition.BOTTOM);
       return;
    }
    
    _isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      _isLoading.value = false;
      Get.toNamed(AppRoutes.RESET_PASSWORD);
    });
  }

  // --- Step 3: Reset Password ---
  void toggleNewPassVisibility() => _isNewPassVisible.value = !_isNewPassVisible.value;
  void toggleConfirmPassVisibility() => _isConfirmPassVisible.value = !_isConfirmPassVisible.value;

  void resetPassword() {
    final pass = newPassController.text;
    final confirm = confirmPassController.text;

    if (pass.length < 8) {
       Get.snackbar('Error', 'Password must be at least 8 characters', snackPosition: SnackPosition.BOTTOM);
       return;
    }
    if (pass != confirm) {
       Get.snackbar('Error', 'Passwords do not match', snackPosition: SnackPosition.BOTTOM);
       return;
    }

    _isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      _isLoading.value = false;
      Get.offAllNamed(AppRoutes.ADMIN_LOGIN);
      Get.snackbar('Success', 'Password reset successfully', snackPosition: SnackPosition.BOTTOM);
    });
  }
}
