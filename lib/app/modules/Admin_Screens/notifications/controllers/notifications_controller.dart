import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/notifications/models/notification_model.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:salon/app/modules/Admin_Screens/admin_dashboard/controllers/admin_dashboard_controller.dart';

class NotificationsController extends GetxController {
  
  // Mock Data
  final notifications = <NotificationModel>[
    // Today
    NotificationModel(
      id: '1',
      title: 'New booking received',
      body: 'Sarah J. booked a haircut for 3 PM today. Please confirm availability.',
      timeAgo: '2m ago',
      type: NotificationType.booking,
      isRead: false,
    ),
    // Yesterday
    NotificationModel(
      id: '2',
      title: 'New 5-star review',
      body: '"Absolutely loved the service! Best salon in town." - Emily R.',
      timeAgo: '1d ago',
      type: NotificationType.review,
      isRead: true,
    ),
    NotificationModel(
      id: '3',
      title: 'Appointment Cancelled',
      body: 'Order #4421 was cancelled by client due to emergency.',
      timeAgo: '1d ago',
      type: NotificationType.booking,
      isRead: true,
    ),
    // Previous
    NotificationModel(
      id: '4',
      title: 'Profile Verified',
      body: 'Your salon profile has been verified. You can now accept online payments.',
      timeAgo: '3d ago',
      type: NotificationType.profile,
      isRead: true,
    ),
  ].obs;

  // Grouped by section
  List<NotificationModel> get todayNotifications => 
      notifications.where((n) => n.timeAgo.contains('m ago') || n.timeAgo.contains('h ago')).toList();
  
  List<NotificationModel> get yesterdayNotifications => 
      notifications.where((n) => n.timeAgo.contains('1d ago')).toList();
  
  List<NotificationModel> get previousNotifications => 
      notifications.where((n) => !n.timeAgo.contains('m ago') && !n.timeAgo.contains('h ago') && !n.timeAgo.contains('1d ago')).toList();


  void handleNotificationTap(NotificationModel notification) {
    switch (notification.type) {
      case NotificationType.booking:
        // Navigate to Orders Tab in Dashboard
        // Assuming AdminDashboardController is alive
        try {
          final dashboardController = Get.find<AdminDashboardController>();
          dashboardController.changeTabIndex(2); // Index 2 is Orders (Verify this index)
          Get.until((route) => Get.currentRoute == AppRoutes.ADMIN_DASHBOARD);
        } catch (e) {
          // Fallback if controller not found (e.g. direct deep link)
           Get.offAllNamed(AppRoutes.ADMIN_DASHBOARD);
        }
        break;
        
      case NotificationType.review:
        // Navigate to Shop Reviews
        Get.toNamed(AppRoutes.REVIEWS);
        break;
        
      case NotificationType.profile:
        // Navigate to Profile Tab
        try {
          final dashboardController = Get.find<AdminDashboardController>();
           dashboardController.changeTabIndex(4); // Index 4 is Profile/Shop
           Get.until((route) => Get.currentRoute == AppRoutes.ADMIN_DASHBOARD);
        } catch (e) {
           Get.offAllNamed(AppRoutes.ADMIN_DASHBOARD);
        }
        break;
        
      case NotificationType.other:
      default:
        // Do nothing or open details
        break;
    }
  }
}
