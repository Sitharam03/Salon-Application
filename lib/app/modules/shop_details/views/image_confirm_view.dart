import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon/app/modules/shop_details/controllers/shop_details_controller.dart';

class ImageConfirmView extends GetView<ShopDetailsController> {
  final XFile imageFile;
  final bool isProfile;

  const ImageConfirmView({
    Key? key,
    required this.imageFile,
    required this.isProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: kIsWeb 
                ? Image.network(
                    imageFile.path,
                    fit: BoxFit.contain,
                  )
                : Image.file(
                    File(imageFile.path),
                    fit: BoxFit.contain,
                  ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Retake / Delete Button
                  TextButton.icon(
                    onPressed: () {
                      Get.back(); // Close confirm view
                      if (isProfile) {
                        controller.takeProfilePhoto(); // Re-open camera for retake
                      } 
                      // For cover photo, 'Delete' just cancels the current capture (doesn't save), 
                      // so we just close the view.
                    },
                    icon: Icon(
                      isProfile ? Icons.refresh : Icons.delete, 
                      color: isProfile ? Colors.white : Colors.redAccent
                    ),
                    label: Text(
                      isProfile ? 'Retake' : 'Delete', 
                      style: TextStyle(color: isProfile ? Colors.white : Colors.redAccent)
                    ),
                  ),
                  // Save Button
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.confirmImage(imageFile, isProfile);
                      Get.back(); // Close confirm view
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
