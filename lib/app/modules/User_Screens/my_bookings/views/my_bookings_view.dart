import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/my_bookings/controllers/my_bookings_controller.dart';
import 'package:salon/app/modules/User_Screens/my_bookings/widgets/booking_card.dart';
import 'package:salon/app/widgets/user_bottom_nav_bar.dart';

class MyBookingsView extends GetView<MyBookingsController> {
  const MyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Light background
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          onPressed: () => Get.back(), 
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => ListView.builder(
          itemCount: controller.bookings.length,
          itemBuilder: (context, index) {
            final booking = controller.bookings[index];
            return BookingCard(
              booking: booking,
              onReschedule: () => controller.onReschedule(booking['id']),
              onRebook: () => controller.onRebook(booking['id']),
              onFeedback: () => controller.onFeedback(booking['id']),
            );
          },
        )),
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 1),
    );
  }
}
