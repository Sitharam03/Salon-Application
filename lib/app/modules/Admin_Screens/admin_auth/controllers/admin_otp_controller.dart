import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';

class AdminOTPController extends GetxController {
  late String phoneNumber;

  final List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  final _secondsRemaining = 30.obs;
  final _isTimerActive = true.obs;

  int get secondsRemaining => _secondsRemaining.value;
  bool get isTimerActive => _isTimerActive.value;

  bool get isButtonEnabled {
    return otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  @override
  void onInit() {
    super.onInit();
    phoneNumber = Get.arguments['phoneNumber'] ?? '';
    _startTimer();

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

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isTimerActive.value && _secondsRemaining.value > 0) {
        _secondsRemaining.value--;
        _startTimer();
      }
    });
  }

  void onOTPFieldChange(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[index - 1]);
    }
  }

  void verifyOTP() {
    String otp = otpControllers.map((c) => c.text).join();
    
    if (otp.length < 4) {
      _showSnackBar('Please enter complete OTP');
      return;
    }

    Get.offAllNamed(AppRoutes.ADMIN_SUCCESS);
  }

  void resendOTP() {
    _secondsRemaining.value = 30;
    _startTimer();
    
    for (var controller in otpControllers) {
      controller.clear();
    }
    
    _showSnackBar('OTP resent to +91$phoneNumber');
  }

  String formatPhoneNumber(String phone) {
    if (phone.length >= 4) {
      return phone.replaceRange(1, phone.length - 3, 'X' * (phone.length - 3));
    }
    return phone;
  }

  void _showSnackBar(String message) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
