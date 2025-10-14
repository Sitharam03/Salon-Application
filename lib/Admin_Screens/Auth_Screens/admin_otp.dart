import 'package:flutter/material.dart';
import 'package:salon/Admin_Screens/success_screen.dart';
import 'package:salon/Screens/Auth_Screens/Widgets/app_header.dart';
import 'package:salon/Screens/Auth_Screens/Widgets/button.dart';
import 'package:salon/Screens/Auth_Screens/Widgets/otpinputfield.dart';

class AdminOtp extends StatefulWidget {
  const AdminOtp({super.key, required this.phoneNumber});
  final String phoneNumber;

  @override
  State<AdminOtp> createState() => _AdminOtpState();
}

class _AdminOtpState extends State<AdminOtp> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  int _secondsRemaining = 30;
  late bool _isTimerActive = true;

  bool get _isButtonEnabled =>
      _otpControllers.every((controller) => controller.text.isNotEmpty);

  @override
  void initState() {
    super.initState();
    _startTimer();
    for (var controller in _otpControllers) {
      controller.addListener(_updateButtonState);
    }
  }

  void _updateButtonState() {
    setState(() {}); // Triggers rebuild to update button state
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isTimerActive && _secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    _isTimerActive = false;
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOTPFieldChange(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  void _verifyOTP() {
    String otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 4) {
      _showSnackBar('Please enter complete OTP');
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SuccessScreen()),
    );
  }

  void _resendOTP() {
    setState(() => _secondsRemaining = 30);
    _startTimer();
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _showSnackBar('OTP resent to +91${widget.phoneNumber}');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatPhoneNumber(String phone) {
    if (phone.length >= 4) {
      return phone.replaceRange(1, phone.length - 3, 'X' * (phone.length - 3));
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const AppHeader(),
              const SizedBox(height: 60),
              Center(
                child: Text(
                  'Enter OTP sent to ${_formatPhoneNumber(widget.phoneNumber)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => OTPInputField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    nextFocusNode: index < 3 ? _focusNodes[index + 1] : null,
                    previousFocusNode: index > 0
                        ? _focusNodes[index - 1]
                        : null,
                    onChanged: (value) => _onOTPFieldChange(value, index),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OTP valid for only 2 minutes. ',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  GestureDetector(
                    onTap: _secondsRemaining == 0 ? _resendOTP : null,
                    child: Text(
                      _secondsRemaining > 0
                          ? 'Resend Code (${_secondsRemaining}s)'
                          : 'Resend Code',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: _secondsRemaining > 0
                            ? Colors.grey[600]
                            : Colors.blue[600],
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Submit',
                onPressed: _isButtonEnabled ? _verifyOTP : () {},
                backgroundColor: _isButtonEnabled
                    ? const Color.fromRGBO(226, 36, 36, 1.0)
                    : Colors.grey,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
