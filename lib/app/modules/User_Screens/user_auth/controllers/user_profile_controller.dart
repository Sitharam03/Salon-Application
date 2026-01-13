import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon/app/routes/app_routes.dart';

class UserProfileController extends GetxController {
  final name = 'Vignesh Kumar'.obs;
  final email = 'vigneshkumar@gmail.com'.obs;
  final phone = '6123456789'.obs;
  final profileImage = ''.obs; // Use URL for network image
  final Rx<File?> pickedFile = Rx<File?>(null); // For local file

  final ImagePicker _picker = ImagePicker();

  void editProfile() async {
    final result = await Get.toNamed(
      AppRoutes.COMPLETE_PROFILE, 
      arguments: {
        'isEditMode': true,
        'name': name.value,
        'email': email.value,
        'phone': phone.value,
        // 'image': profileImage.value,
      },
    );

    if (result != null && result is Map) {
      name.value = result['name'] ?? name.value;
      email.value = result['email'] ?? email.value;
    } 
    // Check for boolean success flag from direct update flow
    else if (result == true) {
       Get.snackbar('Success', 'Profile updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green);
    }
  }

  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Profile Picture',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Get.back();
                    _pickImage(ImageSource.camera);
                  },
                ),
                _buildOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Get.back();
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: Icon(icon, size: 30, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        pickedFile.value = File(image.path);
        // Clear network URL if local file is picked, or manage precedence in View
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e', 
        snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signOut() {
    Get.offAllNamed('/login'); // Hardcoded path or AppRoutes.LOGIN
  }
}
