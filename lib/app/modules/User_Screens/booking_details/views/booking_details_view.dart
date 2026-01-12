import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/booking_details/controllers/booking_details_controller.dart';
import 'package:salon/app/modules/User_Screens/booking_details/widgets/salon_info_card.dart';
import 'package:salon/app/modules/User_Screens/booking_details/widgets/booking_status_timeline.dart';
import 'package:salon/app/modules/User_Screens/booking_details/widgets/salon_contact_widget.dart';
import 'package:salon/app/modules/User_Screens/booking_details/widgets/service_list_widget.dart';

class BookingDetailsView extends GetView<BookingDetailsController> {
  const BookingDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Booking Details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Obx(() {
        final booking = controller.booking;
        if (booking.isEmpty) return const SizedBox.shrink();

        final status = booking['status'].toString().toLowerCase();
        final isAcceptedOrCompleted = ['accepted', 'completed'].contains(status);
        final showButtons = ['accepted'].contains(status);

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // 1. Header Card
                    SalonInfoCard(
                      imageUrl: booking['imageUrl'],
                      name: booking['salonName'],
                      location: booking['location'],
                      rating: booking['rating'] is double ? booking['rating'] : double.tryParse(booking['rating'].toString()) ?? 4.5,
                      status: booking['status'],
                      onDirections: controller.onGetDirections,
                    ),
                    const SizedBox(height: 24),

                    // 2. Salon Contact (Conditional)
                    if (isAcceptedOrCompleted) ...[
                      SalonContactWidget(
                        phone: booking['phone'] ?? 'N/A',
                        email: booking['email'] ?? 'N/A',
                      ),
                      const SizedBox(height: 24),
                    ],

                    // 3. Status Timeline
                    BookingStatusTimeline(
                      status: booking['status'],
                      date: booking['date'],
                      time: booking['time'],
                    ),
                    const SizedBox(height: 24),

                    // 4. Service List
                    if (booking['services'] != null)
                      ServiceListWidget(services: booking['services']),
                    
                    const SizedBox(height: 100), // Spacing for buttons
                  ],
                ),
              ),
            ),

            // 4. Action Buttons (Sticky Bottom)
            if (showButtons || status == 'completed' || status == 'rejected')
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (status == 'accepted') ...[
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: controller.onReschedule,
                            icon: const Icon(Icons.schedule, color: Colors.white, size: 20),
                            label: const Text('Reschedule Booking',style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1F2937),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(height: 12),
                        // SizedBox(
                        //   width: double.infinity,
                        //   height: 50,
                        //   child: OutlinedButton(
                        //     onPressed: controller.onCancel,
                        //     style: OutlinedButton.styleFrom(
                        //       side: const BorderSide(color: Color(0xFFEF4444)),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //       ),
                        //     ),
                        //     child: const Text(
                        //       'Cancel Booking',
                        //       style: TextStyle(
                        //         color: Color(0xFFEF4444),
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ] else if (status == 'completed') ...[
                         SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: controller.onFeedback,
                            icon: const Icon(Icons.star_outline, color: Colors.white, size: 20),
                            label: const Text('Give Feedback',style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE31E51),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ] else if (status == 'rejected') ...[
                         SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: controller.onRebook,
                            icon: const Icon(Icons.refresh, color: Colors.black, size: 20),
                            label: const Text('Re-book'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF3F4F6),
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
