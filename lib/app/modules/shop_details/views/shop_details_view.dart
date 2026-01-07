import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/shop_details/controllers/shop_details_controller.dart';
import 'package:salon/app/modules/profile/widgets/cover_photo_carousel.dart';

class ShopDetailsView extends GetView<ShopDetailsController> {
  const ShopDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
          controller.isEditingProfile.value ? 'Edit Your Shop Details' : 'Shop Details',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        )),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cover Photo & Profile Photo Area
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              // Cover Photo Carousel
                               Obx(() => Stack(
                                 children: [
                                   CoverPhotoCarousel(
                                     images: controller.coverImages.toList(),
                                     onAddTap: controller.pickCoverImage, // Using pickCoverImage (with limit check)
                                   ),
                                   
                                   // Camera Icon Button Overlay (always visible to add more)
                                   Positioned(
                                     top: 16,
                                     right: 16,
                                     child: GestureDetector(
                                       onTap: controller.takeCoverPhoto,
                                       child: Container(
                                         padding: const EdgeInsets.all(8),
                                         decoration: BoxDecoration(
                                           color: Colors.black.withOpacity(0.5),
                                           shape: BoxShape.circle,
                                         ),
                                         child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                                       ),
                                     ),
                                   ),
                                 ],
                               )),
                              // Profile Photo
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: controller.pickProfileImage,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1B4B43), // Dark green from design
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 4),
                                          ),
                                          child: Obx(() {
                                              final image = controller.profileImage.value;
                                              if (image != null) {
                                                if (kIsWeb) {
                                                   return ClipOval(
                                                    child: Image.network(
                                                      image.path,
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  );
                                                } else {
                                                  return ClipOval(
                                                    child: Image.file(
                                                      File(image.path),
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  );
                                                }
                                              }
                                                return ClipOval(
                                                  child: Image.asset(
                                                    'assets/profile_avatar.png',
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                          }),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFE22424),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.edit, color: Colors.white, size: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Shop Name
                        _buildLabel('SHOP NAME'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: controller.shopNameController,
                          hint: 'e.g. Luxe Salon & Spa',
                          icon: Icons.store_outlined,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Location (Read only with Change button)
                        _buildLabel('LOCATION'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(4), // Inner padding for border
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: const Icon(Icons.location_on, color: Color(0xFFE22424)),
                              ),
                              Expanded(
                                child: Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.selectedAddress.value.isEmpty 
                                          ? 'No location selected' 
                                          : controller.selectedAddress.value,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14, 
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                              TextButton(
                                onPressed: controller.changeLocation,
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFEBEE), // Light red bg
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text(
                                  'Change',
                                  style: TextStyle(
                                    color: Color(0xFFE22424),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Owner Name
                        _buildLabel('OWNER NAME'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: controller.ownerNameController,
                          hint: 'Enter owner name',
                          icon: Icons.person_outline,
                        ),

                        const SizedBox(height: 24),

                        // Contact Number
                        _buildLabel('CONTACT NUMBER'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: controller.contactNumberController,
                          hint: '+91 98765 43210',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: 24),
                        
                        // Full Address
                        _buildLabel('FULL ADDRESS'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: controller.fullAddressController,
                          hint: 'Flat No, Street, Landmark...',
                          icon: Icons.map_outlined,
                          maxLines: 3,
                          alignIconTop: true,
                        ),

                        const SizedBox(height: 32),
                        
                        // Save Button
                        GetBuilder<ShopDetailsController>(
                          builder: (_) => Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value ? null : controller.saveDetails,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE22424),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: controller.isLoading.value
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Save',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                    ],
                                  ),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey[600],
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool alignIconTop = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: alignIconTop 
              ? Column(mainAxisAlignment: MainAxisAlignment.start, children: [Padding(padding: const EdgeInsets.only(top: 12), child: Icon(icon, color: Colors.grey))])
              : Icon(icon, color: Colors.grey),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }
}
