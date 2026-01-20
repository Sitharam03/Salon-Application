import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/dashboard/controllers/user_dashboard_controller.dart';
import 'package:salon/app/modules/User_Screens/home/controllers/home_controller.dart';
import 'package:salon/app/modules/User_Screens/my_bookings/controllers/my_bookings_controller.dart';
import 'package:salon/app/modules/User_Screens/favorites/controllers/favorites_controller.dart';
import 'package:salon/app/modules/User_Screens/profile/controllers/user_profile_controller.dart';

class UserDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserDashboardController>(() => UserDashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<MyBookingsController>(() => MyBookingsController());
    Get.lazyPut<FavoritesController>(() => FavoritesController());
    Get.lazyPut<UserProfileController>(() => UserProfileController());
  }
}
