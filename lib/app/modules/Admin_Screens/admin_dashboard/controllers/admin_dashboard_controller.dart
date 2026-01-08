import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/orders/controllers/orders_controller.dart';

class AdminDashboardController extends GetxController {
  final selectedIndex = 0.obs;
  
  // Filter & Date State logic delegated to OrdersController

  // We will piggyback on OrdersController for filter state to ensure sync
  // or simply keep local state and sync it. 
  // Better: Use OrdersController directly in View, but to satisfy the 'controller.changeFilter' calls in View:
  
  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  void changeFilter(String filter) {
    // Ideally we find the OrdersController and update it
    if (Get.isRegistered<OrdersController>()) {
      Get.find<OrdersController>().changeFilter(filter);
    } else {
        // Fallback or init
        Get.put(OrdersController()).changeFilter(filter);
    }
  }

  void changeDate(DateTime date) {
    if (Get.isRegistered<OrdersController>()) {
      Get.find<OrdersController>().changeDate(date);
    } else {
        Get.put(OrdersController()).changeDate(date);
    }
  }
}
