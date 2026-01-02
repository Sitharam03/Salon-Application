import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/admin/controllers/forgot_password_controller.dart';

class ResetPasswordView extends GetView<ForgotPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                'New Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E232C),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your new password must be different from previously used passwords.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // New Password
              const Text(
                'New Password',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              GetBuilder<ForgotPasswordController>(
                builder: (_) => Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: controller.newPassController,
                      obscureText: !controller.isNewPassVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                         suffixIcon: IconButton(
                          icon: Icon(
                            controller.isNewPassVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: controller.toggleNewPassVisibility,
                        ),
                        hintText: 'New Password',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Confirm Password
              const Text(
                'Confirm New Password',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              GetBuilder<ForgotPasswordController>(
                builder: (_) => Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: controller.confirmPassController,
                      obscureText: !controller.isConfirmPassVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.refresh, color: Colors.grey), // Assuming refresh or similar icon for re-enter
                         suffixIcon: IconButton(
                          icon: Icon(
                            controller.isConfirmPassVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: controller.toggleConfirmPassVisibility,
                        ),
                        hintText: 'Re-enter password',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Complexity Chips (Static for UI as per image, logic implemented in controller validation roughly)
              // Ideally these should change color based on input. For now implementing static UI or basic reactive.
              // const Text(
              //   'Password must contain:',
              //   style: TextStyle(color: Colors.grey, fontSize: 14),
              // ),
              // const SizedBox(height: 8),
              // const Row(
              //   children: [
              //     Chip(
              //       label: Text('8+ chars', style: TextStyle(fontSize: 12, color: Color(0xFF2E7D32))),
              //       backgroundColor: Color(0xFFE8F5E9),
              //       visualDensity: VisualDensity.compact,
              //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //       side: BorderSide.none,
              //       avatar: Icon(Icons.check, size: 14, color: Color(0xFF2E7D32)),
              //     ),
              //     SizedBox(width: 8),
              //      Chip(
              //       label: Text('1 Number', style: TextStyle(fontSize: 12, color: Colors.grey)),
              //       backgroundColor: Color(0xFFF5F5F5), // Grayish for incomplete
              //       visualDensity: VisualDensity.compact,
              //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //       side: BorderSide.none,
              //       avatar: Icon(Icons.circle, size: 6, color: Colors.grey),
              //     ),
              //      SizedBox(width: 8),
              //      Chip(
              //       label: Text('1 Upper', style: TextStyle(fontSize: 12, color: Colors.grey)),
              //       backgroundColor: Color(0xFFF5F5F5),
              //       visualDensity: VisualDensity.compact,
              //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //       side: BorderSide.none,
              //        avatar: Icon(Icons.circle, size: 6, color: Colors.grey),
              //     ),
              //   ],
              // ),
              
              
              const SizedBox(height: 32),
              
              GetBuilder<ForgotPasswordController>(
                builder: (_) => Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.isLoading ? null : controller.resetPassword,
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
                            'Reset Password',
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
              
             
            ],
          ),
        ),
      ),
    );
  }
}
