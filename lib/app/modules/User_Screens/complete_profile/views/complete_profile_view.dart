import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/core/values/app_colors.dart';
import 'package:salon/app/modules/User_Screens/complete_profile/controllers/complete_profile_controller.dart';
import 'package:salon/app/widgets/primary_button.dart';

class CompleteProfileView extends GetView<CompleteProfileController> {
  const CompleteProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    //   appBar: AppBar(
    //     backgroundColor: Colors.white,
    //     elevation: 0,
    //     leading: const SizedBox(), // Hide back button
    //     actions: [
    //        Padding(
    //          padding: const EdgeInsets.only(right: 16.0),
    //          child: Row(
    //            children: const [
    //              Icon(Icons.signal_cellular_alt, color: Colors.black, size: 20),
    //              SizedBox(width: 4),
    //              Icon(Icons.wifi, color: Colors.black, size: 20),
    //              SizedBox(width: 4),
    //              Icon(Icons.battery_full, color: Colors.black, size: 20),
    //            ],
    //          ),
    //        )
    //     ],
    //   ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Obx(() => Text(
                  controller.isEditMode.value ? 'Edit Your Profile' : 'Complete your Profile',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937), // Dark grey
                  ),
                )),
              ),
              const SizedBox(height: 40),
              
              // Profile Picture
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF3E8DB), // Light beige background
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Obx(() {
                        if (controller.profileImage.value != null) {
                          return ClipOval(
                            child: Image.file(
                              controller.profileImage.value!,
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                            ),
                          );
                        } else {
                          // Placeholder icon matching the design idea
                          return const Center(
                            child: Icon(
                              Icons.person_outline_rounded, // Or a custom asset if available
                              size: 60,
                              color: Colors.white,
                            ),
                          );
                        }
                      }),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: controller.showImagePickerOptions,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE31E51), // Red color
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Name Field
              const Text(
                'Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your Name',
                  prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              const SizedBox(height: 24),

              // Phone Field
              const Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          '+91',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: controller.phoneInputController,
                      readOnly: true, // Always read only as per requirement
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFE5E7EB), // Greyed out to indicate disabled/read-only more clearly
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Email Field
              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              const SizedBox(height: 60),

              // Save Button
              Obx(() => PrimaryButton(
                    text: controller.isEditMode.value ? 'Update Profile' : 'Save Profile',
                    onPressed: controller.isLoading.value 
                        ? () {} 
                        : controller.saveProfile,
                    isLoading: controller.isLoading.value,
                    backgroundColor: const Color(0xFFE31E51), // Red color
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
