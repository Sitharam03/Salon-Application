import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/settings/controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF1E232C),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E232C)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // ACCOUNT SETTINGS
              _buildSectionHeader('ACCOUNT SETTINGS'),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[100]!),
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      icon: Icons.person,
                      iconColor: const Color(0xFFE22424),
                      iconBgColor: const Color(0xFFFFEBEE),
                      title: 'Edit Profile',
                      onTap: controller.navigateToEditProfile,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.lock,
                      iconColor: const Color(0xFFE22424),
                      iconBgColor: const Color(0xFFFFEBEE),
                      title: 'Change Password',
                      onTap: controller.navigateToChangePassword,
                    ),
                    // _buildDivider(),
                    // _buildSettingsItem(
                    //   icon: Icons.store,
                    //   iconColor: const Color(0xFFE22424),
                    //   iconBgColor: const Color(0xFFFFEBEE),
                    //   title: 'Salon Details',
                    //   subtitle: 'Address, Photos, Hours',
                    //   onTap: controller.navigateToEditProfile, // Redirect to same edit profile/shop details
                    // ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // APP SETTINGS
              _buildSectionHeader('APP SETTINGS'),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[100]!),
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      icon: Icons.notifications,
                      iconColor: const Color(0xFF2979FF),
                      iconBgColor: const Color(0xFFE3F2FD),
                      title: 'Notifications',
                      isSwitch: true,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.language,
                      iconColor: const Color(0xFF6200EA),
                      iconBgColor: const Color(0xFFEDE7F6),
                      title: 'Language',
                      trailingText: 'English',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.privacy_tip,
                      iconColor: const Color(0xFF00BFA5),
                      iconBgColor: const Color(0xFFE0F2F1),
                      title: 'Privacy Policy',
                      onTap: controller.navigateToPrivacyPolicy,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // SUPPORT
              _buildSectionHeader('SUPPORT'),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[100]!),
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      icon: Icons.help_outline,
                      iconColor: const Color(0xFFFF6D00),
                      iconBgColor: const Color(0xFFFFF3E0),
                      title: 'Help & Support',
                      onTap: controller.navigateToHelpSupport,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.info_outline,
                      iconColor: const Color(0xFFAA00FF),
                      iconBgColor: const Color(0xFFF3E5F5),
                      title: 'About Us',
                      onTap: controller.navigateToAboutUs,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              
              // Logout Button
              GestureDetector(
                onTap: controller.logout,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Color(0xFFE22424)),
                      SizedBox(width: 8),
                      Text(
                        'Log Out',
                        style: TextStyle(
                          color: Color(0xFFE22424),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // App Version
              const Center(
                child: Text(
                  'Salon App v1.0.0',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Color(0xFF6C757D),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[100],
      indent: 60, // Align with text start
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool isSwitch = false,
    String? trailingText,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isSwitch ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: iconBgColor,
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E232C),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSwitch)
                Obx(() => Switch(
                  value: controller.isNotificationsEnabled.value,
                  onChanged: controller.toggleNotifications,
                  activeColor: const Color(0xFFE22424),
                ))
              else if (trailingText != null)
                Row(
                  children: [
                    Text(
                      trailingText,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                )
              else
                const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
