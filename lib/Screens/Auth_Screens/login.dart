import 'package:flutter/material.dart';
import 'package:salon/Screens/Auth_Screens/Widgets/app_header.dart';
import 'package:salon/Screens/Auth_Screens/Widgets/button.dart';
import 'package:salon/Screens/Auth_Screens/Widgets/phonenumber.dart';
import 'package:salon/Screens/Auth_Screens/Widgets/termscheckbox.dart';
import 'package:salon/Screens/Auth_Screens/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {}); // Rebuild when phone number changes
  }

  bool get _isButtonEnabled {
    return _phoneController.text.isNotEmpty && _agreeToTerms;
  }

  void _validateAndGetOTP() {
    if (_phoneController.text.isEmpty) {
      _showSnackBar('Please enter phone number');
      return;
    }

    if (_phoneController.text.length < 10) {
      _showSnackBar('Please enter valid phone number');
      return;
    }

    if (!_agreeToTerms) {
      _showSnackBar('Please agree to Terms and Conditions');
      return;
    }

    _getOTP();
  }

  void _getOTP() {
    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(phoneNumber: _phoneController.text),
        ),
      );
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _goToVendorSignup() {
    _showSnackBar('Navigate to Vendor Signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const AppHeader(),
                const SizedBox(height: 60),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                PhoneInputField(controller: _phoneController),
                const SizedBox(height: 20),
                TermsCheckbox(
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() => _agreeToTerms = value ?? false);
                  },
                  onLearnMore: () {
                    _showSnackBar('Opening Terms and Conditions');
                  },
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'Get OTP',
                  onPressed: _isButtonEnabled ? _validateAndGetOTP : () {},
                  isLoading: _isLoading,
                  backgroundColor: _isButtonEnabled
                      ? const Color.fromRGBO(226, 36, 36, 1.0)
                      : Colors.grey, // Disabled color
                ),
                // const Spacer(),
                const SizedBox(height: 180),
                Center(
                  child: GestureDetector(
                    onTap: _goToVendorSignup,
                    child: Text(
                      'Become a Vendor?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[600],
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
