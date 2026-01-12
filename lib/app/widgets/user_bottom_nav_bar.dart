import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';

class UserBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const UserBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        if (Get.currentRoute != AppRoutes.HOME) {
            // Check if Home is already in stack or just go there
            Get.offAllNamed(AppRoutes.HOME);
        }
        break;
      case 1:
        if (Get.currentRoute != AppRoutes.MY_BOOKINGS) {
            Get.offAllNamed(AppRoutes.MY_BOOKINGS);
        }
        break;
      case 2:
        // Navigate to Favorites (Placeholder)
        // Get.toNamed(AppRoutes.FAVORITES);
        break;
      case 3:
        // Navigate to Profile (Placeholder or reuse ProfileView)
        // Get.toNamed(AppRoutes.PROFILE_SETTINGS);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFE31E51), // Red
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'My Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
