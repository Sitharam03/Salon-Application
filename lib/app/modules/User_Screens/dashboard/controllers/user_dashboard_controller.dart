import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:salon/app/services/notification_service.dart';

class UserDashboardController extends GetxController {
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  // Notifications Logic (Moved here for global access)
  @override
  void onInit() {
    super.onInit();
    // Auto-trigger test notification after 5 seconds for demonstration
    Future.delayed(const Duration(seconds: 5), () {
      showTestNotification();
    });
  }

  final notifications = <Map<String, dynamic>>[
    {
      'id': '1',
      'title': 'Booking Confirmed',
      'body': 'Your booking with Naturals Parlour is confirmed!',
      'time': '2 mins ago',
      'type': 'confirmed',
      'date': 'Oct 15',
    },
    {
      'id': '2',
      'title': 'Special Offer',
      'body': 'Get 20% off on your next haircut! Valid until Sunday.',
      'time': '1 hour ago',
      'type': 'offer',
    },
    {
      'id': '3',
      'title': 'Booking Rejected',
      'body': 'Sorry, your request at Naturals Parlour was rejected due to unavailability.',
      'time': '4 hours ago',
      'type': 'rejected',
    },
    {
      'id': '4',
      'title': 'Feedback Requested',
      'body': 'How was your service at Naturals Parlour? Share your experience with us.',
      'time': 'Yesterday',
      'type': 'feedback',
    },
    {
      'id': '5',
      'title': 'Booking Confirmed',
      'body': 'Your booking with Naturals Parlour is confirmed for Oct 15.',
      'time': 'Oct 12',
      'type': 'confirmed',
    },
  ].obs;

  int get unreadCount => notifications.length;

  void markAllAsRead() {
    notifications.clear();
    Get.snackbar(
      'Success',
      'All notifications marked as read',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );
  }

  void onNotificationTap(Map<String, dynamic> notification) {
    // Navigate based on type
    final type = notification['type'];
    
    // Remove from list (mark as read/delete)
    notifications.remove(notification);

    int newTabIndex = 0; // Default to Home

    switch (type) {
      case 'confirmed':
        newTabIndex = 1; // My Bookings
        break;
      case 'offer':
        newTabIndex = 0; // Home
        break;
      case 'rejected':
        newTabIndex = 1; // My Bookings
        break;
      case 'feedback':
        newTabIndex = 1; // My Bookings
        break;
      default:
        newTabIndex = 0;
        break;
    }

    // Switch tab
    changeTabIndex(newTabIndex);
    
    // If we are currently in the notifications screen, go back
    if (Get.currentRoute == AppRoutes.USER_NOTIFICATIONS) {
       Get.back();
    }
  }

  // Method to test local push notification
  void showTestNotification() {
    // Add a new random notification to the list
    final newNotification = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': 'Test Booking Update!',
      'body': 'Your booking status has changed. Tap to view.',
      'time': 'Just now',
      'type': 'confirmed',
    };
    notifications.insert(0, newNotification);

    // Show local push notification
    NotificationService().showNotification(
      id: 0,
      title: newNotification['title'] as String,
      body: newNotification['body'] as String,
      payload: 'notifications',
    );
  }
}
