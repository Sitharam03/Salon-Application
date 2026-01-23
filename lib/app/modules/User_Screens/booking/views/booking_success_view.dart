import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/booking/controllers/booking_controller.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:intl/intl.dart';

class BookingSuccessView extends GetView<BookingController> {
  const BookingSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Success Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2), // Light orange bg
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 40), // Or hour glass
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Booking Request Sent',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Your request has been sent to the salon.\nWe are awaiting confirmation from the owner.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Ticket Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                         Container(
                           width: 40, height: 40,
                           decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                           child: const Icon(Icons.store, color: Colors.grey),
                         ),
                         const SizedBox(width: 12),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const Text("SALON", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1)),
                               Obx(() => Text(
                                 controller.salonData['name'] ?? 'Salon Name',
                                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                               )),
                               Obx(() => Text(
                                 controller.salonData['location'] ?? 'Location',
                                 style: const TextStyle(fontSize: 12, color: Colors.grey),
                               )),
                             ],
                           ),
                         ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("DATE", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            const SizedBox(height: 4),
                             Obx(() => Text(
                               controller.selectedDate.value != null 
                                 ? DateFormat('MMM d, E').format(controller.selectedDate.value!)
                                 : 'N/A',
                               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                             )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("TIME", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1)),
                             const SizedBox(height: 4),
                             Obx(() => Text(
                               controller.selectedTime.value,
                               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                             )),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.grey, thickness: 0.5), // Separator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Status", style: TextStyle(color: Colors.grey)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text("Pending", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                        )
                      ],
                    )
                  ],
                ),
              ),

              const Spacer(),
              
              // Buttons
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                     Get.offAllNamed(AppRoutes.HOME, arguments: {'initialIndex': 1});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                       Text('View My Bookings', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                       SizedBox(width: 8),
                       Icon(Icons.arrow_forward, color: Colors.black),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.offAllNamed(AppRoutes.HOME),
                child: const Text("Back to Home", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
