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

  @override
  void onInit() {
    super.onInit();
    // Check for arguments passed from Maps
    if (Get.arguments != null) {
      _updateLocationFromArguments(Get.arguments);
    }
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
    // Navigate back to Maps, but we want to potentially get a result back if we are treating Maps as a picker
    // Since our flow is Success -> Maps -> ShopDetails
    // If we go back to Maps, we can just Get.toNamed(AppRoutes.MAPS) again or Get.back() if we came from there?
    // Actually, based on the flow: success -> MAPS -> ShopDetails.
    // If we click "Change", we should probably go back to MAPS.
    // But MAPS "confirmLocation" does Get.toNamed(ShopDetails).
    // So if we just Get.back(), we return to MAPS. MAPS is likely still in the stack?
    // Let's check stack: MAPS -> SHOP_DETAILS.
    // Yes, Get.back() should work to go back to maps to pick again.
    // However, when MAPS is confirmed again, it will push SHOP_DETAILS again. 
    // We might want to handle "result" or use Get.off.
    
    // Better approach: Go to Maps, and pass a flag that we are "editing" location? 
    // Or just strictly follow the requested flow: 
    // "when user click on the change it should go to maps screen and their user can update the loaction"
    
    // If we use Get.toNamed(AppRoutes.MAPS), we push a new Maps instance.
    // Let's use Get.toNamed for now to be explicit, but we need to watch out for stack depth.
    // Actually, if we came from Maps, Get.back() is the most natural "Change" action.
    Get.back(); 
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
      Get.snackbar('Success', 'Shop details saved successfully!');
      // Navigate to Admin Dashboard
      Get.offAllNamed(AppRoutes.ADMIN_DASHBOARD); 
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
