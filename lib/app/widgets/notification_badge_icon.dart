import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/dashboard/controllers/user_dashboard_controller.dart';
import 'package:salon/app/routes/app_routes.dart';

class NotificationBadgeIcon extends StatelessWidget {
  const NotificationBadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // Try to find the controller, return simple icon if not found (e.g. testing in isolation)
    UserDashboardController? controller;
    try {
      controller = Get.find<UserDashboardController>();
    } catch (_) {}

    if (controller == null) {
      return IconButton(
        onPressed: () => Get.toNamed(AppRoutes.USER_NOTIFICATIONS),
        icon: const Icon(Icons.notifications_none, size: 24),
      );
    }

    return Obx(() => Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () => Get.toNamed(AppRoutes.USER_NOTIFICATIONS),
          icon: const Icon(Icons.notifications_none, size: 24, color: Colors.black),
        ),
        if (controller!.unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFE31E51),
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '${controller.unreadCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    ));
  }
}
