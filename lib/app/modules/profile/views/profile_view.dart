import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/shop_details/controllers/shop_details_controller.dart';
import 'package:salon/app/modules/shop_details/views/shop_details_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is available
    final controller = Get.put(ShopDetailsController());
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Overlapping Images Section
          SizedBox(
            height: 280, // Height for combined cover + profile
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // 1. Cover Carousel
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      // Image
                      Image.asset(
                        'assets/images/salon_cover.jpg', // Placeholder
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(child: Icon(Icons.store, size: 50, color: Colors.grey)),
                          );
                        },
                      ),
                      // Navigation Arrows (Mock)
                      Positioned(
                        left: 10,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: CircleAvatar(
                            backgroundColor: Colors.black.withOpacity(0.3),
                            radius: 16,
                            child: const Icon(Icons.chevron_left, color: Colors.white),
                          ),
                        ),
                      ),
                       Positioned(
                        right: 10,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: CircleAvatar(
                            backgroundColor: Colors.black.withOpacity(0.3),
                            radius: 16,
                            child: const Icon(Icons.chevron_right, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Profile Picture (Overlapping)
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4), // White border
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: const Color(0xFFFFCCBC), // Light peach bg
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/owner.png', // Placeholder
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Image.asset('assets/images/human_1.png', width: 120, height: 120, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.person, size: 60, color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Edit Icon on Profile Pic REMOVED as requested
              ],
            ),
          ),
          
          const SizedBox(height: 20),

          // Shop Info
          // Removed Obx as these controllers are NOT observables.
          // If we want reactivity, we would need to wrap in GetBuilder or use Rx variables.
          // For now, removing Obx fixes the error.
          Column(
            children: [
              Text(
                controller.shopNameController.text.isNotEmpty ? controller.shopNameController.text : 'Shop Name',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E232C),
                ),
              ),
              const SizedBox(height: 8),
              
              // selectedAddress IS observable, so we use Obx here
              Obx(() => Text(
                controller.selectedAddress.value.isNotEmpty ? controller.selectedAddress.value : 'Location',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              )),
              
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(4, (index) => const Icon(Icons.star, color: Colors.amber, size: 20)),
                   const Icon(Icons.star, color: Colors.grey, size: 20),
                   const SizedBox(width: 8),
                   const Text(
                     '4.2',
                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                   ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 30),

          // Details Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                _buildDetailCard(
                  icon: Icons.person,
                  label: 'OWNER NAME',
                  value: controller.ownerNameController.text,
                ),
                const SizedBox(height: 16),
                _buildDetailCard(
                  icon: Icons.phone,
                  label: 'CONTACT',
                  value: controller.contactNumberController.text,
                ),
                const SizedBox(height: 16),
                _buildDetailCard(
                  icon: Icons.location_on,
                  label: 'FULL ADDRESS',
                  value: controller.fullAddressController.text,
                  isMultiLine: true,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon, 
    required String label, 
    required String value,
    bool isMultiLine = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[100],
            child: Icon(icon, color: Colors.grey[600]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E232C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

  Widget _buildDetailCard({
    required IconData icon, 
    required String label, 
    required String value,
    bool isMultiLine = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[100],
            child: Icon(icon, color: Colors.grey[600]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E232C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

