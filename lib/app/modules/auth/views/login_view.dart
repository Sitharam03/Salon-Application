import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/core/values/app_colors.dart';
import 'package:salon/app/modules/auth/controllers/login_controller.dart';
import 'package:salon/app/widgets/app_header.dart';
import 'package:salon/app/widgets/phone_input_field.dart';
import 'package:salon/app/widgets/primary_button.dart';
import 'package:salon/app/widgets/terms_checkbox.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
                PhoneInputField(controller: controller.phoneController),
                const SizedBox(height: 20),
                GetBuilder<LoginController>(
                  builder: (_) => Obx(
                    () => TermsCheckbox(
                      value: controller.agreeToTerms,
                      onChanged: (value) => controller.setAgreeToTerms(value ?? false),
                      onLearnMore: () {
                        Get.showSnackbar(
                          const GetSnackBar(
                            message: 'Opening Terms and Conditions',
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GetBuilder<LoginController>(
                  builder: (_) => Obx(
                    () => PrimaryButton(
                      text: 'Get OTP',
                      onPressed: controller.isButtonEnabled
                          ? controller.validateAndGetOTP
                          : () {},
                      isLoading: controller.isLoading,
                      backgroundColor: controller.isButtonEnabled
                          ? AppColors.primaryAlt
                          : AppColors.disabled,
                    ),
                  ),
                ),
                const SizedBox(height: 180),
                Center(
                  child: GestureDetector(
                    onTap: controller.goToVendorSignup,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
