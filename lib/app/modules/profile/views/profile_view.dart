import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/shop_details/controllers/shop_details_controller.dart';
import 'package:salon/app/modules/profile/widgets/info_row.dart';
import 'package:salon/app/modules/profile/widgets/profile_list_item.dart';
import 'package:salon/app/modules/profile/widgets/cover_photo_carousel.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:salon/app/modules/reviews/views/shop_reviews_view.dart';
import 'package:salon/app/modules/admin_dashboard/controllers/admin_dashboard_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is available
    final controller = Get.put(ShopDetailsController());
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light background
      // appBar: AppBar(
      //   title: const Text(
      //     'Shop Details',
      //     style: TextStyle(
      //       color: Color(0xFF1E232C),
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Color(0xFF1E232C)),
      //     onPressed: () {
      //       // Navigate back to Home Dashboard logic
      //        try {
      //          final dashboardController = Get.find<AdminDashboardController>();
      //          dashboardController.changeTabIndex(0);
      //        } catch (e) {
      //          Get.back();
      //        }
      //     },
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            // 1. Header with Cover & Profile
            SizedBox(
              height: 260, // Increased height for cover photo
              child: Stack(
                children: [
                   // Cover Photo Carousel
                   Obx(() => Stack(
                     children: [
                       CoverPhotoCarousel(
                         images: controller.coverImages.toList(),
                         onAddTap: controller.takeCoverPhoto,
                       ),
                       // Edit/Add Cover Photo Button
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
                         // Optional: Indicator dots could be added here if desired
                     ],
                   )),
                  
                  // Profile Image
                   Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: controller.pickProfileImage,
                            child: Container(
                              padding: const EdgeInsets.all(4), // White border effect
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Obx(() {
                                 final image = controller.profileImage.value;
                                 if (image != null) {
                                   return CircleAvatar(
                                     radius: 60,
                                     backgroundImage: kIsWeb 
                                         ? NetworkImage(image.path) 
                                         : FileImage(File(image.path)) as ImageProvider,
                                     backgroundColor: Colors.grey[200],
                                   );
                                 }
                                 return CircleAvatar(
                                   radius: 60,
                                   backgroundColor: Colors.grey[200],
                                   backgroundImage: const AssetImage('assets/profile_avatar.png'),
                                 );
                              }),
                            ),
                          ),
                           Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: controller.pickProfileImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE22424),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.edit, size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Name
            Text(
              controller.shopNameController.text.isNotEmpty 
                  ? controller.shopNameController.text 
                  : 'Naturals Parlour',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E232C),
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Location
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Obx(() => Text(
                  controller.selectedAddress.value.isNotEmpty
                      ? controller.selectedAddress.value
                      : 'Miyapur, Hyderabad', 
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                )),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Rating Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6), // Light Yellow
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                  SizedBox(width: 6),
                  Text(
                    '4.2 Rating',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD4A017),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // 2. Shop Information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('SHOP INFORMATION'),
                  const SizedBox(height: 16),
                  
                  InfoRow(
                    icon: Icons.person,
                    iconBgColor: const Color(0xFFE3F2FD), // Light Blue
                    title: 'Owner Name',
                    value: controller.ownerNameController.text.isNotEmpty 
                        ? controller.ownerNameController.text 
                        : 'Vignesh Kumar',
                  ),
                  
                  InfoRow(
                    icon: Icons.phone,
                    iconBgColor: const Color(0xFFE8F5E9), // Light Green
                    title: 'Phone',
                    value: controller.contactNumberController.text.isNotEmpty
                        ? controller.contactNumberController.text
                        : '6123456789',
                  ),
                  
                  InfoRow(
                    icon: Icons.home,
                    iconBgColor: const Color(0xFFFBE9E7), // Light Orange
                    title: 'Address',
                    value: controller.fullAddressController.text.isNotEmpty
                        ? controller.fullAddressController.text
                        : 'Plot No. 42, Hitech City Main Rd, near Ratnadeep Supermarket',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 3. Manage Shop
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('MANAGE SHOP'),
                  const SizedBox(height: 16),
                  
                  ProfileListItem(
                    icon: Icons.spa,
                    iconBgColor: const Color(0xFFF3E5F5), // Light Purple
                    iconColor: const Color(0xFF9C27B0),
                    title: 'Manage Services',
                    onTap: () {
                      final dashboardController = Get.find<AdminDashboardController>();
                      dashboardController.changeTabIndex(1); // Switch to Services Tab
                     },
                  ),
                  
                  ProfileListItem(
                    icon: Icons.people,
                    iconBgColor: const Color(0xFFE8EAF6), // Light Indigo
                    iconColor: const Color(0xFF3F51B5),
                    title: 'Manage Service Providers',
                    onTap: () {
                      final dashboardController = Get.find<AdminDashboardController>();
                      dashboardController.changeTabIndex(2); // Switch to Providers Tab
                    },
                  ),
                  
                  ProfileListItem(
                    icon: Icons.star_outline,
                    iconBgColor: const Color(0xFFFFEBEE), // Light Red
                    iconColor: const Color(0xFFE22424),
                    title: 'Shop Reviews',
                    onTap: () {
                       Get.toNamed(AppRoutes.REVIEWS);
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 4. General
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('GENERAL'),
                  const SizedBox(height: 16),
                  
                  ProfileListItem(
                    icon: Icons.settings,
                    iconBgColor: const Color(0xFFFFF3E0), // Light Orange
                    iconColor: const Color(0xFFFF9800),
                    title: 'Settings',
                    onTap: () {
                         Get.toNamed(AppRoutes.SETTINGS);
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        letterSpacing: 1.0,
      ),
    );
  }
}




