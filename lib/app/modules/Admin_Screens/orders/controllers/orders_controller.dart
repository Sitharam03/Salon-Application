import 'package:get/get.dart';
import 'package:salon/app/data/models/order_model.dart';
import 'package:salon/app/services/mock_data_service.dart';
import 'package:salon/app/services/notification_service.dart';

class OrdersController extends GetxController {
  // Selected Date for filtering
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // Selected Filter Category
  final RxString selectedFilter = 'All'.obs; // All, Pending, Accepted, Rejected

  // Data Service
  MockDataService get dataService => Get.find<MockDataService>();

  // Filtered Orders
  List<OrderModel> get filteredOrders {
    return dataService.bookings.where((order) {
      // 1. Check Date (Compare Year, Month, Day)
      bool isSameDate = order.date.year == selectedDate.value.year &&
          order.date.month == selectedDate.value.month &&
          order.date.day == selectedDate.value.day;
      
      if (!isSameDate) return false;

      // 2. Check Status Filter
      if (selectedFilter.value == 'All') return true;
      if (selectedFilter.value == 'Pending' && order.status == OrderStatus.pending) return true;
      if (selectedFilter.value == 'Accepted' && order.status == OrderStatus.accepted) return true;
      if (selectedFilter.value == 'Rejected' && order.status == OrderStatus.rejected) return true;

      return false;
    }).toList();
  }

  int get pendingCount => dataService.bookings.where((o) => o.status == OrderStatus.pending
      && o.date.year == selectedDate.value.year 
      && o.date.month == selectedDate.value.month 
      && o.date.day == selectedDate.value.day).length;

  int get acceptedCount => dataService.bookings.where((o) => o.status == OrderStatus.accepted 
      && o.date.year == selectedDate.value.year 
      && o.date.month == selectedDate.value.month 
      && o.date.day == selectedDate.value.day).length;

  int get rejectedCount => dataService.bookings.where((o) => o.status == OrderStatus.rejected
      && o.date.year == selectedDate.value.year 
      && o.date.month == selectedDate.value.month 
      && o.date.day == selectedDate.value.day).length;

  void changeDate(DateTime date) {
    selectedDate.value = date;
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void acceptOrder(String id) {
    dataService.updateBookingStatus(id, OrderStatus.accepted);
    Get.snackbar('Accepted', 'Order has been accepted');
    
    // Trigger User Notification
    NotificationService().showNotification(
       id: int.parse(id), // Assuming ID is parseable, fallback needed in real app
       title: 'Booking Accepted',
       body: 'Your booking has been confirmed by the salon!',
       payload: 'notifications'
    );
  }

  void rejectOrder(String id) {
    dataService.updateBookingStatus(id, OrderStatus.rejected);
    Get.snackbar('Rejected', 'Order has been rejected');

    // Trigger User Notification
    NotificationService().showNotification(
       id: int.parse(id),
       title: 'Booking Rejected',
       body: 'Sorry, your booking request was rejected.',
       payload: 'notifications'
    );
  }
}
