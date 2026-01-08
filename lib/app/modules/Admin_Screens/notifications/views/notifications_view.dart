import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/notifications/controllers/notifications_controller.dart';
import 'package:salon/app/modules/Admin_Screens/notifications/models/notification_model.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF1E232C),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E232C)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODAY
              Obx(() {
                 if (controller.todayNotifications.isEmpty) return const SizedBox();
                 return _buildSection('TODAY', controller.todayNotifications);
              }),

              // YESTERDAY
              Obx(() {
                 if (controller.yesterdayNotifications.isEmpty) return const SizedBox();
                 return _buildSection('YESTERDAY', controller.yesterdayNotifications);
              }),

              // PREVIOUS
              Obx(() {
                 if (controller.previousNotifications.isEmpty) return const SizedBox();
                 return _buildSection('PREVIOUS', controller.previousNotifications);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<NotificationModel> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF6C757D),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _buildNotificationCard(item)).toList(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildNotificationCard(NotificationModel item) {
    return GestureDetector(
      onTap: () => controller.handleNotificationTap(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getIconBgColor(item.type),
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
                            color: Color(0xFF1E232C),
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
                  color: Color(0xFF2979FF),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getIconBgColor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return const Color(0xFFE3F2FD); // Light Blue
      case NotificationType.review:
        return const Color(0xFFFFF3E0); // Light Orange
      case NotificationType.profile:
        return const Color(0xFFF3E5F5); // Light Purple
      case NotificationType.other:
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getIconColor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return const Color(0xFF2979FF); // Blue
      case NotificationType.review:
        return const Color(0xFFFF6D00); // Orange
      case NotificationType.profile:
        return const Color(0xFFAA00FF); // Purple
      case NotificationType.other:
      default:
        return Colors.grey.shade600;
    }
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Icons.calendar_today;
      case NotificationType.review:
        return Icons.star;
      case NotificationType.profile:
        return Icons.verified;
      case NotificationType.other:
      default:
        return Icons.notifications;
    }
  }
}
