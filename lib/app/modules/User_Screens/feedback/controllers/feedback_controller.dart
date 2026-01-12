import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon/app/routes/app_routes.dart';

class FeedbackController extends GetxController {
  final rating = 0.obs;
  final reviewController = TextEditingController();
  final imagePath = "".obs;
  final ImagePicker _picker = ImagePicker();
  
  // Salon Data from Booking
  final salonName = "".obs;
  final salonLocation = "".obs;
  final salonImage = "".obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      final booking = Get.arguments as Map<String, dynamic>;
      salonName.value = booking['salonName'] ?? "Salon";
      salonLocation.value = booking['location'] ?? "";
      salonImage.value = booking['imageUrl'] ?? "";
    }
  }

  void setRating(int value) {
    rating.value = value;
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        imagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  void removeImage() {
    imagePath.value = "";
  }

  void submitFeedback() {
    if (rating.value == 0) {
      Get.snackbar('Error', 'Please select a star rating');
      return;
    }
    
    // Simulate API call
    Get.defaultDialog(
      title: "Submitting",
      content: const CircularProgressIndicator(),
      barrierDismissible: false,
    );
    
    Future.delayed(const Duration(seconds: 1), () {
      Get.back(); // Close dialog
      Get.offNamed(AppRoutes.FEEDBACK_SUCCESS);
    });
  }
  
  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }
}
