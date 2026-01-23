import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon/app/modules/Admin_Screens/shop_details/views/image_confirm_view.dart';
import 'package:salon/app/services/mock_data_service.dart';

class ShopDetailsController extends GetxController {
  // Text Controllers
  final shopNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final contactNumberController = TextEditingController();
  final fullAddressController = TextEditingController();

  // Observables
  final selectedAddress = ''.obs;
  final isLoading = false.obs;

  // Images (XFile for Web compatibility)
  final profileImage = Rx<XFile?>(null);
  // Using RxList for multiple cover photos
  final coverImages = <XFile>[].obs;

  final ImagePicker _picker = ImagePicker();

  // LatLng specific
  double? latitude;
  double? longitude;

  final isEditingProfile = false.obs;
  final showTimingsSection = true.obs; // Default true for new registration

  Future<void> pickProfileImage() async {
    _showImageSourceDialog(isProfile: true);
  }

  Future<void> pickCoverImage() async {
    // Check limit
    if (coverImages.length >= 5) {
      Get.snackbar(
        'Limit Reached',
        'You can only upload up to 5 cover photos.',
      );
      return;
    }
    _showImageSourceDialog(isProfile: false);
  }

  Future<void> takeProfilePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Get.to(() => ImageConfirmView(imageFile: image, isProfile: true));
    }
  }

  Future<void> takeCoverPhoto() async {
    // Check limit
    if (coverImages.length >= 5) {
      Get.snackbar(
        'Limit Reached',
        'You can only upload up to 5 cover photos.',
      );
      return;
    }
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Get.to(() => ImageConfirmView(imageFile: image, isProfile: false));
    }
  }

  void confirmImage(XFile file, bool isProfile) {
    if (isProfile) {
      profileImage.value = file;
    } else {
      if (coverImages.length < 5) {
        coverImages.add(file);
      }
    }
  }

  void _showImageSourceDialog({required bool isProfile}) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Image Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Get.back();
                    if (isProfile) {
                      takeProfilePhoto();
                    } else {
                      takeCoverPhoto();
                    }
                  },
                ),
                _buildSourceOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () async {
                    Get.back();
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      confirmImage(image, isProfile);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[100],
            child: Icon(icon, size: 30, color: const Color(0xFFE22424)),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();

    // Check for arguments passed
    if (Get.arguments != null) {
      if (Get.arguments is Map) {
        Map args = Get.arguments;
        if (args['isEditing'] == true) {
          isEditingProfile.value = true;
        }
        // Explicitly check for showTimings argument
        if (args.containsKey('showTimings')) {
          showTimingsSection.value = args['showTimings'];
        } else {
          // If editing profile but showTimings not specified, assume hidden for regular profile edit
          // However, for new registration (isEditing=false), it stays true
           if (isEditingProfile.value) {
             showTimingsSection.value = false;
           }
        }
        
        _updateLocationFromArguments(args.cast<String, dynamic>());
      }
    }

    // Mock Data init if empty (for testing/demo)
    if (shopNameController.text.isEmpty && !isEditingProfile.value) {
      if (!isEditingProfile.value) {
        _fillMockData();
      }
    }
    _initShopTimings();
  }

  void _fillMockData() {
    shopNameController.text = "Naturals Parlour";
    ownerNameController.text = "Vignesh Kumar";
    contactNumberController.text = "6123654789";
    fullAddressController.text =
        "Plot No. 42, Hitech City Main Rd, near Ratnadeep Supermarket, Hyderabad";
    selectedAddress.value = "Miyapur, Hyderabad";
  }

  void _updateLocationFromArguments(Map<String, dynamic> args) {
    if (args['address'] != null) {
      selectedAddress.value = args['address'];
    }
    if (args['latitude'] != null) {
      latitude = args['latitude'];
    }
    if (args['longitude'] != null) {
      longitude = args['longitude'];
    }
  }

  void changeLocation() async {
    Get.toNamed(AppRoutes.MAPS);
  }

  void saveDetails() {
    // Validations
    if (shopNameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter shop name');
      return;
    }

    isLoading.value = true;

    // Mock API call
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;

      // Save to Global Mock Data
      final newSalon = {
        'name': shopNameController.text,
        'location': selectedAddress.value,
        'rating': 0.0, // New shop
        'imageUrl':
            'https://images.unsplash.com/photo-1521590832169-d7fcbe2af40f?auto=format&fit=crop&w=800&q=80', // Default or from picked image
        'lat': latitude ?? 17.4401, // Default if not selected
        'lng': longitude ?? 78.3489,
        'distance': 0.0,
        'categories': ['Haircut'], // Default categories for flow
      };

      try {
        Get.find<MockDataService>().addSalon(newSalon);
      } catch (e) {
        print("Error saving to mock service: $e");
      }

      if (isEditingProfile.value) {
        Get.back(); // Return to Profile View
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
        );
      } else {
        Get.snackbar('Success', 'Shop details saved successfully!');
        // Navigate to Admin Dashboard
        Get.offAllNamed(AppRoutes.ADMIN_DASHBOARD);
      }
    });
  }

  @override
  void onClose() {
    shopNameController.dispose();
    ownerNameController.dispose();
    contactNumberController.dispose();
    fullAddressController.dispose();
    super.onClose();
  }

  // Shop Timings Logic
  final shopTimings = <ShopTiming>[].obs;

  void _initShopTimings() {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    shopTimings.value = days.map((day) => ShopTiming(day: day)).toList();
  }

  void toggleShopOpen(int index, bool isOpen) {
    shopTimings[index].isOpen = isOpen;
    shopTimings.refresh();
  }

  void applyToAllDays() {
    if (shopTimings.isEmpty) return;

    final firstDayTiming = shopTimings[0];

    for (int i = 1; i < shopTimings.length; i++) {
      shopTimings[i].isOpen = firstDayTiming.isOpen;
      shopTimings[i].openingTime = firstDayTiming.openingTime;
      shopTimings[i].closingTime = firstDayTiming.closingTime;
    }

    shopTimings.refresh();
    Get.snackbar(
      'Applied',
      'Timings applied to all days',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }


  Future<void> selectTime(
    BuildContext context,
    int index,
    bool isOpening,
  ) async {
    final initialTime = isOpening
        ? _parseTime(shopTimings[index].openingTime)
        : _parseTime(shopTimings[index].closingTime);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE22424),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE22424),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedTime = _formatTime(picked);
      if (isOpening) {
        shopTimings[index].openingTime = formattedTime;
      } else {
        shopTimings[index].closingTime = formattedTime;
      }
      shopTimings.refresh();
    }
  }

  TimeOfDay _parseTime(String timeStr) {
    // Expected format "HH:MM AM/PM"
    try {
      final parts = timeStr.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      final period = parts[1];

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    // Simple manual formatting or use intl if available
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return "${hour.toString().padLeft(2, '0')}:$minute $period";
  }

  void logout() {
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  // Navigate to Shop Timings Screen
  void navigateToShopTimings() {
    Get.toNamed(AppRoutes.SHOP_TIMINGS);
  }
}

class ShopTiming {
  String day;
  bool isOpen;
  String openingTime;
  String closingTime;

  ShopTiming({
    required this.day,
    this.isOpen = true,
    this.openingTime = "09:00 AM",
    this.closingTime = "09:00 PM",
  });
}
