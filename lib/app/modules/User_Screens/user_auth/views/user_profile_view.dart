import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/user_auth/controllers/user_profile_controller.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:salon/app/widgets/user_bottom_nav_bar.dart';

class UserProfileView extends GetView<UserProfileController> {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Slightly off-white/light grey background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(), // Or navigation logic if needed
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false, // Image shows left aligned "Profile" or Back + Title. Image shows "Profile" next to back arrow.
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Profile Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFF3E8DB), width: 2), // Beige border
                          ),
                           child: Container(
                             width: 100,
                             height: 100,
                             padding: const EdgeInsets.all(4),
                             decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE0C4A8) // Inner beige circle
                             ),
                             child: Obx(() {
                               // Check for local file first
                               if (controller.pickedFile.value != null) {
                                 return ClipOval(
                                   child: Image.file(
                                     controller.pickedFile.value!,
                                     fit: BoxFit.cover,
                                     width: 100,
                                     height: 100,
                                   ),
                                 );
                               }
                               // Then check for network URL
                               if (controller.profileImage.value.isNotEmpty) {
                                 return ClipOval(
                                    child: Image.network(
                                      controller.profileImage.value,
                                      fit: BoxFit.cover, // Ensure it fills the circle
                                      width: 100,
                                      height: 100,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.person, size: 50, color: Colors.white);
                                      },
                                    ),
                                 );
                               }
                               // Fallback
                               return const CircleAvatar(
                                 radius: 46,
                                 backgroundImage: AssetImage('assets/images/user_avatar.png'),
                                 backgroundColor: Colors.transparent,
                                 child: Icon(Icons.person, size: 50, color: Colors.white), 
                               );
                             }),
                           ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: controller.showImagePickerOptions, // Changed to show picker
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE31E51),
                                shape: BoxShape.circle,
                                border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
                              ),
                              child: const Icon(Icons.edit, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // const Text(
                    //   'YOUR NAME',
                    //   style: TextStyle(
                    //     fontSize: 12,
                    //     color: Color(0xFFE31E51),
                    //     fontWeight: FontWeight.bold,
                    //     letterSpacing: 1.0,
                    //   ),
                    // ),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                      controller.name.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    )),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone, size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Obx(() => Text(
                          controller.phone.value,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.email_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Obx(() => Text(
                          controller.email.value,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ACCOUNT',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              _buildListTile(
                icon: Icons.person_outline,
                iconColor: const Color(0xFF3B82F6), // Blue
                iconBg: const Color(0xFFEFF6FF), // Light Blue
                title: 'Edit Profile',
                onTap: controller.editProfile,
              ),
              const SizedBox(height: 16),
              _buildListTile(
                icon: Icons.calendar_today_outlined,
                iconColor: const Color(0xFF8B5CF6), // Purple
                iconBg: const Color(0xFFF3E8FF), // Light Purple
                title: 'My Bookings',
                onTap: () {
                    Get.toNamed(AppRoutes.MY_BOOKINGS);
                },
              ),
              const SizedBox(height: 16),
              _buildListTile(
                icon: Icons.favorite_border,
                iconColor: const Color(0xFFE31E51), // Red
                iconBg: const Color(0xFFFFF1F2), // Light Red
                title: 'Favourites',
                onTap: () {
                    Get.toNamed(AppRoutes.FAVORITES);
                },
              ),

              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'GENERAL',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildListTile(
                icon: Icons.settings_outlined,
                iconColor: const Color(0xFFF59E0B), // Orange
                iconBg: const Color(0xFFFFFBEB), // Light Orange
                title: 'Settings',
                onTap: () {
                    Get.toNamed(AppRoutes.USER_SETTINGS);
                },
              ),
              const SizedBox(height: 16),
              _buildListTile(
                icon: Icons.logout,
                iconColor: const Color(0xFF374151), // Dark Grey
                iconBg: const Color(0xFFF3F4F6), // Light Grey
                title: 'Sign Out',
                onTap: controller.signOut,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black.withOpacity(0.02),
        //       blurRadius: 10,
        //       offset: const Offset(0, 2),
        //     ),
        //   ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
