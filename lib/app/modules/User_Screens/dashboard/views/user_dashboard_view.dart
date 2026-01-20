import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/dashboard/controllers/user_dashboard_controller.dart';
import 'package:salon/app/modules/User_Screens/home/views/home_view.dart';
import 'package:salon/app/modules/User_Screens/my_bookings/views/my_bookings_view.dart';
import 'package:salon/app/modules/User_Screens/favorites/views/favorites_view.dart';
import 'package:salon/app/modules/User_Screens/profile/views/user_profile_view.dart';
import 'package:salon/app/widgets/user_bottom_nav_bar.dart';

class UserDashboardView extends GetView<UserDashboardController> {
  const UserDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.tabIndex.value,
        children: const [
          HomeView(),
          MyBookingsView(),
          FavoritesView(),
          UserProfileView(),
        ],
      )),
      bottomNavigationBar: const UserBottomNavBar(),
    );
  }
}
