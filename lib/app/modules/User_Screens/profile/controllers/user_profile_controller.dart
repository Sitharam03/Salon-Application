import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:salon/app/services/auth_service.dart';

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
    Get.find<AuthService>().logout();
  }

  // Search State
  final isSearchActive = false.obs;
  final searchQuery = ''.obs;

  // Define Menu Items
  final menuItems = <Map<String, dynamic>>[
    {
      'title': 'Edit Profile',
      'icon': Icons.person_outline,
      'iconColor': const Color(0xFF3B82F6),
      'iconBg': const Color(0xFFEFF6FF),
      'action': 'editProfile',
      'section': 'ACCOUNT'
    },
    {
      'title': 'My Bookings',
      'icon': Icons.calendar_today_outlined,
      'iconColor': const Color(0xFF8B5CF6),
      'iconBg': const Color(0xFFF3E8FF),
      'action': 'myBookings',
      'section': 'ACCOUNT'
    },
    {
      'title': 'Favourites',
      'icon': Icons.favorite_border,
      'iconColor': const Color(0xFFE31E51),
      'iconBg': const Color(0xFFFFF1F2),
      'action': 'favorites',
      'section': 'ACCOUNT'
    },
    {
      'title': 'Settings',
      'icon': Icons.settings_outlined,
      'iconColor': const Color(0xFFF59E0B),
      'iconBg': const Color(0xFFFFFBEB),
      'action': 'settings',
      'section': 'GENERAL'
    },
    {
      'title': 'Sign Out',
      'icon': Icons.logout,
      'iconColor': const Color(0xFF374151),
      'iconBg': const Color(0xFFF3F4F6),
      'action': 'signOut',
      'section': 'GENERAL'
    },
  ];

  List<Map<String, dynamic>> get filteredMenuItems {
    if (searchQuery.isEmpty) {
      return menuItems;
    }
    return menuItems.where((item) {
      return item['title'].toString().toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  void toggleSearch() {
    isSearchActive.value = !isSearchActive.value;
    if (!isSearchActive.value) {
      searchQuery.value = '';
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }
}
