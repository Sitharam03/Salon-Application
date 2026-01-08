import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon/app/routes/app_routes.dart';

class ProfileController extends GetxController {
  late String phoneNumber;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final _isLoading = false.obs;
  final _selectedImage = Rx<File?>(null);

  bool get isLoading => _isLoading.value;
  File? get selectedImage => _selectedImage.value;

  @override
  void onInit() {
    super.onInit();
    phoneNumber = Get.arguments?['phoneNumber'] ?? '';
    phoneController.text = phoneNumber;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  /// Pick image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 75);
    
    if (picked != null) {
      _selectedImage.value = File(picked.path);
    }
  }

  /// Remove selected image
  void removeImage() {
    _selectedImage.value = null;
  }

  /// Show image picker options bottom sheet
  void showImageOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            const Text(
              "Profile Photo",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Pick from Gallery"),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            if (_selectedImage.value != null) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  "Remove Photo",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Get.back();
                  removeImage();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Validate name
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  /// Validate email
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Save profile
  void saveProfile() {
    if (formKey.currentState?.validate() ?? false) {
      _isLoading.value = true;

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        _isLoading.value = false;
        
        // Navigate to maps screen
        Get.offAllNamed(AppRoutes.MAPS);
      });
    }
  }
}
