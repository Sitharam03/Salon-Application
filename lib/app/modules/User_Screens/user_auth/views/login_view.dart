import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/core/values/app_colors.dart';
import 'package:salon/app/modules/User_Screens/user_auth/controllers/login_controller.dart';
import 'package:salon/app/widgets/app_header.dart';
import 'package:salon/app/widgets/phone_input_field.dart';
import 'package:salon/app/widgets/primary_button.dart';
import 'package:salon/app/widgets/terms_checkbox.dart';
import 'package:salon/app/widgets/salon_background_animation.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Animation
          const Positioned.fill(
            child: SalonBackgroundAnimation(),
          ),

          // Foreground Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40),
                            const AppHeader(),
                            
                            const Spacer(), // Spacer to push content down
                            
                            // Centered Content Block
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                              ],
                            ),

                            const Spacer(), // Spacer to push footer down
                            const SizedBox(height: 20),
                            
                            Center(
                              child: GestureDetector(
                                onTap: controller.goToVendorSignup,
                                child: Text(
                                  'Become a Vendor?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
