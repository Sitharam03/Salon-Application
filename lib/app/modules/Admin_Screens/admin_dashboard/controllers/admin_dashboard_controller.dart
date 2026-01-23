import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/orders/controllers/orders_controller.dart';

class AdminDashboardController extends GetxController {
  final selectedIndex = 0.obs;
  final isShopOpen = false.obs; // Default to closed or fetch from API

  
  // Filter & Date State logic delegated to OrdersController

  // We will piggyback on OrdersController for filter state to ensure sync
  // or simply keep local state and sync it. 
  // Better: Use OrdersController directly in View, but to satisfy the 'controller.changeFilter' calls in View:
  
  final showGreetingCard = true.obs;
  final shopName = 'Luxe Salon'.obs; // TODO: Fetch from profile/storage

  @override
  void onInit() {
    super.onInit();
    // Auto-hide greeting card after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      showGreetingCard.value = false;
    });
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

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
