import 'package:get/get.dart';
import 'package:salon/app/data/models/order_model.dart';
import 'package:salon/app/services/mock_data_service.dart';
import 'package:flutter/material.dart';
import 'package:salon/app/services/notification_service.dart';
import 'package:salon/app/modules/Admin_Screens/orders/widgets/order_dialogs.dart';

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


  // Dialog Methods
  void showAcceptDialog(OrderModel order) {
    Get.dialog(AcceptOrderDialog(
      order: order,
      onConfirm: () => acceptOrder(order.id),
    ));
  }

  void showRejectDialog(OrderModel order) {
    Get.dialog(RejectOrderDialog(
      order: order,
      onConfirm: (reason) {
         // Handle rejection reason if needed in backend
         rejectOrder(order.id);
      },
    ));
  }

  void showChangeProviderDialog(OrderModel order) {
    Get.dialog(ChangeProviderDialog(
      order: order,
      onConfirm: (name, role) {
        updateServiceProvider(order.id, name, role);
      },
    ));
  }

  // Actions
  void acceptOrder(String id) {
    dataService.updateBookingStatus(id, OrderStatus.accepted);
    Get.snackbar('Accepted', 'Order has been accepted', 
      backgroundColor: const Color(0xFFE8F5E9), colorText: const Color(0xFF43A047), margin: const EdgeInsets.all(16));
    
    NotificationService().showNotification(
       id: int.parse(id),
       title: 'Booking Accepted',
       body: 'Your booking has been confirmed by the salon!',
       payload: 'notifications'
    );
  }

  void rejectOrder(String id) {
    dataService.updateBookingStatus(id, OrderStatus.rejected);
    Get.snackbar('Rejected', 'Order has been rejected',
      backgroundColor: const Color(0xFFFFEBEE), colorText: const Color(0xFFE53935), margin: const EdgeInsets.all(16));

    NotificationService().showNotification(
       id: int.parse(id),
       title: 'Booking Rejected',
       body: 'Sorry, your booking request was rejected.',
       payload: 'notifications'
    );
  }

  void updateServiceProvider(String id, String name, String role) {
    // Ideally this goes to DataService
     final index = dataService.bookings.indexWhere((o) => o.id == id);
    if (index != -1) {
      dataService.bookings[index].serviceProviderName = name;
      dataService.bookings[index].serviceProviderRole = role;
      dataService.bookings.refresh(); // Trigger Obx updates
      Get.back(); // Close dialog if not already closed
      Get.snackbar('Updated', 'Service Provider updated to $name');
    }
  }
}
