import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/widgets/notification_badge_icon.dart';
import 'package:salon/app/modules/User_Screens/profile/controllers/user_profile_controller.dart';
import 'package:salon/app/routes/app_routes.dart';

class UserProfileView extends GetView<UserProfileController> {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Slightly off-white/light grey background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        title: Obx(() => controller.isSearchActive.value 
          ? TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search options...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: controller.onSearchChanged,
            )
          : const Text(
              'Profile',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
        ),
        centerTitle: true,
        titleSpacing: 0,
        actions: [
          // Obx(() => IconButton(
          //   onPressed: controller.toggleSearch,
          //   icon: Icon(controller.isSearchActive.value ? Icons.close : Icons.search, color: const Color(0xFF1F2937)),
          // )),
          const NotificationBadgeIcon(),
        ]
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
              
              Obx(() {
                 if (controller.isSearchActive.value) {
                    if (controller.filteredMenuItems.isEmpty) {
                       return Center(child: Text("No matching options", style: TextStyle(color: Colors.grey[500])));
                    }
                    return Column(
                      children: controller.filteredMenuItems.map((item) => _buildMenuItemFromMap(item)).toList(),
                    );
                 } else {
                    final accountItems = controller.menuItems.where((i) => i['section'] == 'ACCOUNT').toList();
                    final generalItems = controller.menuItems.where((i) => i['section'] == 'GENERAL').toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         _buildSectionHeader('ACCOUNT'),
                         const SizedBox(height: 16),
                         ...accountItems.map((item) => Padding(
                           padding: const EdgeInsets.only(bottom: 16.0),
                           child: _buildMenuItemFromMap(item),
                         )),
                         
                         const SizedBox(height: 16),
                         _buildSectionHeader('GENERAL'),
                         const SizedBox(height: 16),
                         ...generalItems.map((item) => Padding(
                           padding: const EdgeInsets.only(bottom: 16.0),
                           child: _buildMenuItemFromMap(item),
                         )),
                      ],
                    );
                 }
              }),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildMenuItemFromMap(Map<String, dynamic> item) {
    return _buildListTile(
      icon: item['icon'],
      iconColor: item['iconColor'],
      iconBg: item['iconBg'],
      title: item['title'],
      onTap: () => _handleAction(item['action']),
    );
  }

  void _handleAction(String action) {
    switch (action) {
      case 'editProfile':
        controller.editProfile();
        break;
      case 'myBookings':
        Get.toNamed(AppRoutes.MY_BOOKINGS);
        break;
      case 'favorites':
        Get.toNamed(AppRoutes.FAVORITES);
        break;
      case 'settings':
        Get.toNamed(AppRoutes.USER_SETTINGS);
        break;
      case 'signOut':
        controller.signOut();
        break;
    }
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
