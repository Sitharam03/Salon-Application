import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/admin_auth/controllers/forgot_password_controller.dart';
import 'package:salon/app/routes/app_routes.dart';
// Note: Assuming reusable OTPInputField exists or rebuilding similar logic using Container+TextField for exact design match
// Design shows square inputs with rounded corners, very similar to standard OTP fields.

class ForgotPasswordVerificationView extends GetView<ForgotPasswordController> {
  const ForgotPasswordVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                         // Header
                        const Text(
                          'INDIA\'S 1ST',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Salon',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE22424),
                          ),
                        ),
                        const Text(
                          'Application',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E232C),
                          ),
                        ),
                        
                        const SizedBox(height: 50),
                        
                        const Text(
                          'Verification Code',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E232C),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Please enter the 4-digit code sent to',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          controller.emailController.text, // Display entered email
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // OTP Fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(4, (index) {
                            return Container(
                              width: 64, // Wider boxes as per design
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: controller.otpControllers[index].text.isNotEmpty 
                                     ? const Color(0xFFE22424) // Active/Filled
                                     : Colors.grey[300]!,
                                  width: 1.5,
                                ),
                              ),
                              child: TextField(
                                controller: controller.otpControllers[index],
                                focusNode: controller.focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) => controller.onOTPFieldChange(value, index),
                              ),
                            );
                          }),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Resend Timer
                        Center(
                          child: Obx(
                            () => Column(
                              children: [
                                 Text(
                                  'Resend code in ${controller.secondsRemaining.toString().padLeft(2, '0')}:00', // Format mm:ss or just ss as design says 00:30
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                if (controller.secondsRemaining == 0)
                                  TextButton(
                                    onPressed: controller.resendOTP, 
                                    child: const Text('Resend Code', style: TextStyle(color: Color(0xFFE22424))),
                                  ),
                                if (controller.secondsRemaining > 0)
                                  TextButton(
                                    onPressed: null,
                                    child: Text('Resend Code', style: TextStyle(color: Colors.grey[400])),
                                  )
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                        
                        GetBuilder<ForgotPasswordController>(
                          builder: (_) => Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: controller.isLoading ? null : controller.verifyOTP,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE22424),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  elevation: 0,
                                ),
                                child: controller.isLoading 
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Verify Account',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        const Spacer(),
                        const SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap: () => Get.offAllNamed(AppRoutes.ADMIN_LOGIN),
                            child: const Text(
                              '< Back to Login',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
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
          }
        ),
      ),
    );
  }
}
