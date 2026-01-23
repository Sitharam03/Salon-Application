import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/notifications/controllers/notifications_controller.dart';
import 'package:salon/app/modules/Admin_Screens/notifications/models/notification_model.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

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

  Widget _buildNotificationCard(NotificationModel item) {
    return GestureDetector(
      onTap: () => controller.handleNotificationTap(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getBackgroundColor(item.type),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _getBorderColor(item.type).withOpacity(0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(item.type),
                color: _getIconColor(item.type),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        item.timeAgo,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.body,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            
            // Unread Indicator
            if (!item.isRead)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 4),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFE31E51), // Pink matching app theme
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return const Color(0xFFEFF6FF); // Light Blue (Feedback style)
      case NotificationType.review:
        return const Color(0xFFFFF7ED); // Light Orange (Offer style)
      case NotificationType.profile:
        return const Color(0xFFF3E5F5); // Light Purple
      default:
        return Colors.grey.shade50;
    }
  }

  Color _getBorderColor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Colors.blue; 
      case NotificationType.review:
        return Colors.orange;
      case NotificationType.profile:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getIconColor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Colors.blue;
      case NotificationType.review:
        return Colors.orange;
      case NotificationType.profile:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Icons.calendar_today;
      case NotificationType.review:
        return Icons.star;
      case NotificationType.profile:
        return Icons.person;
      default:
        return Icons.notifications;
    }
  }
}
