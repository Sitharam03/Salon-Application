import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/my_bookings/controllers/my_bookings_controller.dart';
import 'package:salon/app/modules/User_Screens/my_bookings/widgets/booking_card.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:salon/app/widgets/user_bottom_nav_bar.dart';
import 'package:salon/app/widgets/notification_badge_icon.dart';

class MyBookingsView extends GetView<MyBookingsController> {
  const MyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Light background
      appBar: AppBar(
        title: Obx(() => controller.isSearchActive.value 
          ? TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search bookings...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: controller.onSearchChanged,
            )
          : const Text(
              'My Bookings',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        //   onPressed: () => Get.back(), 
        // ),
        actions: [
          Obx(() => IconButton(
            icon: Icon(controller.isSearchActive.value ? Icons.close : Icons.search, color: Colors.black),
            onPressed: controller.toggleSearch,
          )),
          const NotificationBadgeIcon(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.filteredBookings.isEmpty) {
             return Center(child: Text(controller.isSearchActive.value ? "No matching bookings" : "No bookings found", style: TextStyle(color: Colors.grey[500])));
          }
          return ListView.builder(
            itemCount: controller.filteredBookings.length,
            itemBuilder: (context, index) {
              final booking = controller.filteredBookings[index];
              return BookingCard(
                booking: booking,
                onReschedule: () => controller.onReschedule(booking['id']),
                onRebook: () => controller.onRebook(booking['id']),
                onFeedback: () => controller.onFeedback(booking['id']),
              );
            },
          );
        }),
      ),

    );
  }
}
