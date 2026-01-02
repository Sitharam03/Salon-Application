import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  final selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
    // Handle navigation to other tabs if they become separate pages
    // For now, we assume the dashboard only implements Home (index 0)
    // and just visually updates the tab or shows a placeholder.
    // If other tabs are implemented as separate routes, we would use Get.toNamed/offNamed here.
  }
}
