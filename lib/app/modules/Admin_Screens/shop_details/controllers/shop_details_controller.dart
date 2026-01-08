
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon/app/modules/Admin_Screens/shop_details/views/image_confirm_view.dart';

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

  Future<void> pickProfileImage() async {
    _showImageSourceDialog(isProfile: true);
  }

  Future<void> pickCoverImage() async {
    // Check limit
    if (coverImages.length >= 5) {
      Get.snackbar('Limit Reached', 'You can only upload up to 5 cover photos.');
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
      Get.snackbar('Limit Reached', 'You can only upload up to 5 cover photos.');
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
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
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

  Widget _buildSourceOption({required IconData icon, required String label, required VoidCallback onTap}) {
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
         _updateLocationFromArguments(args.cast<String, dynamic>());
      }
    }

    // Mock Data init if empty (for testing/demo)
    if (shopNameController.text.isEmpty && !isEditingProfile.value) {
       if (!isEditingProfile.value) {
          _fillMockData();
       }
    }
  }

  void _fillMockData() {
      shopNameController.text = "Naturals Parlour";
      ownerNameController.text = "Vignesh Kumar";
      contactNumberController.text = "6123654789";
      fullAddressController.text = "Plot No. 42, Hitech City Main Rd, near Ratnadeep Supermarket, Hyderabad";
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
}
