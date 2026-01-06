import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';

class ShopDetailsController extends GetxController {
  
  // Text Controllers
  final shopNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final contactNumberController = TextEditingController();
  final fullAddressController = TextEditingController(); // This is for extra details like flat no
  
  // Observables
  final selectedAddress = ''.obs;
  final isLoading = false.obs;
  
  // LatLng specific
  double? latitude;
  double? longitude;

  bool isEditingProfile = false;

  @override
  void onInit() {
    super.onInit();
    
    // Check for arguments passed 
    if (Get.arguments != null) {
      if (Get.arguments is Map) {
         Map args = Get.arguments;
         if (args['isEditing'] == true) {
           isEditingProfile = true;
         }
         _updateLocationFromArguments(args.cast<String, dynamic>());
      }
    }

    // Mock Data init if empty (for testing/demo)
    if (shopNameController.text.isEmpty && !isEditingProfile) {
       // Only pre-fill if we assume this controller is singleton and persists.
       // Actually for ProfileView we need this data initialized.
       if (!isEditingProfile) {
          // This will run when controller is first created.
          // If created in Onboarding, empty is fine.
          // If created in Dashboard -> Profile, we want mock data.
          // We can check if we are coming from 'Profile' or duplicate the controller.
          // For simplicity, let's just fill it with dummy data if it's empty
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
      
      if (isEditingProfile) {
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
