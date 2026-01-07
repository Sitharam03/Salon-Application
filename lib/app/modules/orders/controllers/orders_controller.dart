import 'package:get/get.dart';
import 'package:salon/app/data/models/order_model.dart';

class OrdersController extends GetxController {
  // Selected Date for filtering
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // Selected Filter Category
  final RxString selectedFilter = 'All'.obs; // All, Pending, Accepted, Rejected

  // Mock Data
  final RxList<OrderModel> allOrders = <OrderModel>[
    OrderModel(
      id: '1',
      customerName: 'Durga Prasad',
      customerPhone: '6123654789',
      customerImage: 'assets/profile_avatar.png', // Placeholder
      status: OrderStatus.pending,
      date: DateTime.now(),
      time: '10:00 PM',
      services: ['Beard Shaving', 'Hair Cut'],
    ),
    OrderModel(
      id: '2',
      customerName: 'Priya Sharma',
      customerPhone: '9876543210',
      customerImage: 'assets/profile_avatar.png', // Placeholder
      status: OrderStatus.accepted,
      date: DateTime.now(),
      time: '11:30 AM',
      services: ['Facial', 'Manicure'],
    ),
    OrderModel(
      id: '3',
      customerName: 'Arun Kumar',
      customerPhone: '6123654789',
      customerImage: 'assets/profile_avatar.png', // Placeholder
      status: OrderStatus.rejected,
      date: DateTime.now().subtract(const Duration(days: 1)),
      time: '10:00 PM',
      services: ['Hair Cut'],
    ),
     OrderModel(
      id: '4',
      customerName: 'Sneha Reddy',
      customerPhone: '5556667777',
      customerImage: null,
      status: OrderStatus.pending,
      date: DateTime.now(),
      time: '04:00 PM',
      services: ['Hair Spa', 'Pedicure'],
    ),
  ].obs;

  // Filtered Orders
  List<OrderModel> get filteredOrders {
    return allOrders.where((order) {
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

  int get pendingCount => allOrders.where((o) => o.status == OrderStatus.pending
      && o.date.year == selectedDate.value.year 
      && o.date.month == selectedDate.value.month 
      && o.date.day == selectedDate.value.day).length;

  int get acceptedCount => allOrders.where((o) => o.status == OrderStatus.accepted 
      && o.date.year == selectedDate.value.year 
      && o.date.month == selectedDate.value.month 
      && o.date.day == selectedDate.value.day).length;

  int get rejectedCount => allOrders.where((o) => o.status == OrderStatus.rejected
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
    int index = allOrders.indexWhere((o) => o.id == id);
    if (index != -1) {
      var order = allOrders[index];
      allOrders[index] = OrderModel(
        id: order.id,
        customerName: order.customerName,
        customerPhone: order.customerPhone,
        customerImage: order.customerImage,
        status: OrderStatus.accepted,
        date: order.date,
        time: order.time,
        services: order.services,
      );
      allOrders.refresh();
      Get.snackbar('Accepted', 'Order has been accepted');
    }
  }

  void rejectOrder(String id) {
     int index = allOrders.indexWhere((o) => o.id == id);
    if (index != -1) {
      var order = allOrders[index];
      allOrders[index] = OrderModel(
        id: order.id,
        customerName: order.customerName,
        customerPhone: order.customerPhone,
        customerImage: order.customerImage,
        status: OrderStatus.rejected,
        date: order.date,
        time: order.time,
        services: order.services,
      );
      allOrders.refresh();
      Get.snackbar('Rejected', 'Order has been rejected');
    }
  }
}
