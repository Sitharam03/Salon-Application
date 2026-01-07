import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/settings/controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: Color(0xFF1E232C),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E232C)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Current Password'),
              const SizedBox(height: 8),
              Obx(() => _buildPasswordField(
                controller: controller.currentPasswordController,
                hint: 'Enter current password',
                isVisible: controller.isCurrentPasswordVisible.value,
                onToggle: controller.toggleCurrentPasswordVisibility,
              )),
              
              const SizedBox(height: 24),
              
              _buildLabel('New Password'),
              const SizedBox(height: 8),
              Obx(() => _buildPasswordField(
                controller: controller.newPasswordController,
                hint: 'Enter new password',
                isVisible: controller.isNewPasswordVisible.value,
                onToggle: controller.toggleNewPasswordVisibility,
              )),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.info, color: Color(0xFFE22424), size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Must be at least 8 characters long.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              _buildLabel('Confirm New Password'),
              const SizedBox(height: 8),
              Obx(() => _buildPasswordField(
                controller: controller.confirmPasswordController,
                hint: 'Re-enter new password',
                isVisible: controller.isConfirmPasswordVisible.value,
                onToggle: controller.toggleConfirmPasswordVisibility,
              )),
              
              const SizedBox(height: 48),
              
              Obx(() => SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE22424),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Update Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E232C),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}
