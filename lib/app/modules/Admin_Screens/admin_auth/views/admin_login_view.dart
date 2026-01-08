import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/core/values/app_colors.dart';
import 'package:salon/app/modules/Admin_Screens/admin_auth/controllers/admin_login_controller.dart';
import 'package:salon/app/widgets/app_header.dart';
import 'package:salon/app/widgets/phone_input_field.dart';
import 'package:salon/app/widgets/primary_button.dart';
import 'package:salon/app/widgets/terms_checkbox.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:salon/app/widgets/salon_background_animation.dart';

class AdminLoginView extends GetView<AdminLoginController> {
  const AdminLoginView({super.key});

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
                            const SizedBox(height: 20),
                            const AppHeader(),
                            const Spacer(), // Pushes content to center
                            const Text(
                              'Become a Vendor/Service Provider',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Email Field
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: controller.emailController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                                  hintText: 'Email Address',
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(16),
                                  hintStyle: TextStyle(color: Colors.grey[500]),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Password Field
                            GetBuilder<AdminLoginController>(
                              builder: (_) => Obx(
                                () => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    controller: controller.passwordController,
                                    obscureText: !controller.isPasswordVisible,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          controller.isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                        onPressed: controller.togglePasswordVisibility,
                                      ),
                                      hintText: 'Password',
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.all(16),
                                      hintStyle: TextStyle(color: Colors.grey[500]),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => Get.toNamed(AppRoutes.FORGOT_PASSWORD), 
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Color(0xFFE22424),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            GetBuilder<AdminLoginController>(
                              builder: (_) => Obx(
                                () => SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: controller.isLoading ? null : controller.login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE22424),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: controller.isLoading
                                        ? const CircularProgressIndicator(color: Colors.white)
                                        : const Text(
                                            'LOGIN',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(), // Pushes content to center
                            const SizedBox(height: 20),
                            Center(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: controller.goToVendorSignup,
                                    child: Text(
                                      'Sign up as Vendor?',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  GestureDetector(
                                    onTap: controller.goToCustomerSignin,
                                    child: Text(
                                      'Back to user login',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
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
        ],
      ),
    );
  }
}
