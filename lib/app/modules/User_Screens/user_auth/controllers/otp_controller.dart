import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';

class OTPController extends GetxController {
  // Phone number from arguments
  late String phoneNumber;

  // OTP controllers
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  // Observable states
  final _secondsRemaining = 30.obs;
  final _isTimerActive = true.obs;

  // Getters
  int get secondsRemaining => _secondsRemaining.value;
  bool get isTimerActive => _isTimerActive.value;

  // Computed property for button enabled state
  bool get isButtonEnabled {
    return otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  @override
  void onInit() {
    super.onInit();
    
    // Get phone number from arguments
    phoneNumber = Get.arguments['phoneNumber'] ?? '';
    
    // Start timer
    _startTimer();

    // Add listeners to all controllers
    for (var controller in otpControllers) {
      controller.addListener(() => update());
    }
  }

  @override
  void onClose() {
    _isTimerActive.value = false;
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }

  /// Start countdown timer
  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isTimerActive.value && _secondsRemaining.value > 0) {
        _secondsRemaining.value--;
        _startTimer();
      }
    });
  }

  /// Handle OTP field change
  void onOTPFieldChange(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[index - 1]);
    }
  }

  /// Verify OTP
  void verifyOTP() {
    String otp = otpControllers.map((c) => c.text).join();
    
    if (otp.length < 4) {
      _showSnackBar('Please enter complete OTP');
      return;
    }

    // Show verified snackbar
    Get.snackbar('Success', 'OTP Verified',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green);

    // Navigate to profile completion screen
    Get.offAllNamed(
      AppRoutes.COMPLETE_PROFILE,
      arguments: {'phoneNumber': phoneNumber},
    );
  }

  /// Resend OTP
  void resendOTP() {
    _secondsRemaining.value = 30;
    _startTimer();
    
    // Clear all OTP fields
    for (var controller in otpControllers) {
      controller.clear();
    }
    
    _showSnackBar('OTP resent to +91$phoneNumber');
  }

  /// Format phone number for display
  String formatPhoneNumber(String phone) {
    if (phone.length >= 4) {
      return phone.replaceRange(1, phone.length - 3, 'X' * (phone.length - 3));
    }
    return phone;
  }

  /// Show snackbar message
  void _showSnackBar(String message) {
    Get.snackbar(
      'Notice',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.1),
      colorText: Colors.black,
      duration: const Duration(seconds: 2),
    );
  }
}
