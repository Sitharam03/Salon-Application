import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/core/values/app_colors.dart';
import 'package:salon/app/modules/User_Screens/user_auth/controllers/otp_controller.dart';
import 'package:salon/app/widgets/app_header.dart';
import 'package:salon/app/widgets/otp_input_field.dart';
import 'package:salon/app/widgets/primary_button.dart';
import 'package:salon/app/widgets/salon_background_animation.dart';

class OTPView extends GetView<OTPController> {
  const OTPView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Enter OTP sent to ${controller.formatPhoneNumber(controller.phoneNumber)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: List.generate(
                                    4,
                                    (index) => OTPInputField(
                                      controller: controller.otpControllers[index],
                                      focusNode: controller.focusNodes[index],
                                      nextFocusNode: index < 3 ? controller.focusNodes[index + 1] : null,
                                      previousFocusNode: index > 0 ? controller.focusNodes[index - 1] : null,
                                      onChanged: (value) => controller.onOTPFieldChange(value, index),
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
                                    Obx(
                                      () => GestureDetector(
                                        onTap: controller.secondsRemaining == 0
                                            ? controller.resendOTP
                                            : null,
                                        child: Text(
                                          controller.secondsRemaining > 0
                                              ? 'Resend Code (${controller.secondsRemaining}s)'
                                              : 'Resend Code',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: controller.secondsRemaining > 0
                                                ? Colors.grey[600]
                                                : Colors.blue[600],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                GetBuilder<OTPController>(
                                  builder: (_) => PrimaryButton(
                                    text: 'Submit',
                                    onPressed: controller.isButtonEnabled
                                        ? controller.verifyOTP
                                        : () {},
                                    backgroundColor: controller.isButtonEnabled
                                        ? AppColors.primaryAlt
                                        : AppColors.disabled,
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(), // Spacer to push footer down
                            const SizedBox(height: 40), // Bottom padding
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
