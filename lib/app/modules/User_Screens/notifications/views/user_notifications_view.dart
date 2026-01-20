import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_notifications_controller.dart';

class UserNotificationsView extends GetView<UserNotificationsController> {
  const UserNotificationsView({super.key});

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
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: controller.markAllAsRead,
            child: const Text(
              'Mark all as read',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No new notifications',
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return _buildNotificationCard(notification);
          },
        );
      }),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return GestureDetector(
      onTap: () => controller.onNotificationTap(notification),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getBackgroundColor(notification['type']),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _getBorderColor(notification['type']).withOpacity(0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(notification['type']),
                color: _getIconColor(notification['type']),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        notification['time'],
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['body'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(String type) {
    switch (type) {
      case 'confirmed':
        return const Color(0xFFF0FDF4); // Light Green
      case 'offer':
        return const Color(0xFFFFF7ED); // Light Orange
      case 'rejected':
        return const Color(0xFFFEF2F2); // Light Red
      case 'feedback':
        return const Color(0xFFEFF6FF); // Light Blue
      default:
        return Colors.grey[50]!;
    }
  }

  Color _getBorderColor(String type) {
    switch (type) {
      case 'confirmed':
        return Colors.green;
      case 'offer':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'feedback':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'confirmed':
        return Icons.check_circle;
      case 'offer':
        return Icons.local_offer;
      case 'rejected':
        return Icons.cancel;
      case 'feedback':
        return Icons.star;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'confirmed':
        return Colors.green;
      case 'offer':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'feedback':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
