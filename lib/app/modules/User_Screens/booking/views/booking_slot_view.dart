import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/booking/controllers/booking_controller.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:intl/intl.dart';

class BookingSlotView extends GetView<BookingController> {
  const BookingSlotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Booking Details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        // actions: [
        //   IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Salon Details Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Salon Image (Thumbnail)
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(
                                controller.salonData['imageUrl'] ?? 
                                (controller.salonImages.isNotEmpty ? controller.salonImages.first : 'https://via.placeholder.com/150')
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(
                                controller.salonData['name'] ?? 'Salon Name',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Obx(() => Text(
                                      controller.salonData['location'] ?? 'Location',
                                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 14, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Obx(() => Text(
                                    "${controller.salonData['rating'] ?? 4.5}",
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. Selected Services List
                  const Text('Selected Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (controller.selectedServices.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: const Text("No services selected", style: TextStyle(color: Colors.grey)),
                      );
                    }
                    return Column(
                      children: [
                        ...controller.selectedServices.map((service) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.spa, color: Color(0xFFE31E51), size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      service['name'],
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                    ),
                                    Text(
                                      "${service['duration']}",
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "\$${service['price']}",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                                onPressed: () => controller.toggleService(service),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              )
                            ],
                          ),
                        )),
                        // Total Price Summary
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE31E51).withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE31E51).withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.w600)),
                              Text(
                                "\$${controller.totalPrice.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Color(0xFFE31E51),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                  
                  const SizedBox(height: 24),

                  // 3. Month & Date Selection (Existing logic)
                  Text(
                    DateFormat('MMMM yyyy').format(DateTime.now()),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Date Selector (Horizontal)
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 14, // Next 2 weeks
                      itemBuilder: (context, index) {
                         final date = DateTime.now().add(Duration(days: index));
                         return Obx(() {
                            final selected = controller.selectedDate.value != null && 
                                            controller.selectedDate.value!.day == date.day &&
                                            controller.selectedDate.value!.month == date.month;
                            return GestureDetector(
                              onTap: () => controller.selectedDate.value = date,
                              child: Container(
                                width: 60,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: selected ? const Color(0xFFE31E51) : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: selected ? const Color(0xFFE31E51) : Colors.grey[200]!),
                                  boxShadow: selected ? [
                                    BoxShadow(
                                      color: const Color(0xFFE31E51).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    )
                                  ] : [],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('E').format(date),
                                      style: TextStyle(
                                        color: selected ? Colors.white : Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      date.day.toString(),
                                      style: TextStyle(
                                        color: selected ? Colors.white : Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                         });
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text('Choose Your Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  // Time Grid
                  Obx(() => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: controller.timeSlots.map((time) {
                       final isAvailable = controller.isTimeSlotAvailable(time);
                       final isSelected = controller.selectedTime.value == time;
                       
                       return IgnorePointer(
                         ignoring: !isAvailable,
                         child: GestureDetector(
                           onTap: () {
                             if (isAvailable) {
                               controller.selectedTime.value = time;
                             }
                           },
                           child: Opacity(
                             opacity: isAvailable ? 1.0 : 0.4,
                             child: Container(
                               width: (Get.width - 32 - 24) / 3, // 3 columns approx
                               padding: const EdgeInsets.symmetric(vertical: 12),
                               decoration: BoxDecoration(
                                 color: isSelected ? const Color(0xFFE31E51) : Colors.white,
                                 borderRadius: BorderRadius.circular(12),
                                 border: Border.all(color: isSelected ? const Color(0xFFE31E51) : Colors.grey[200]!),
                               ),
                               alignment: Alignment.center,
                               child: Text(
                                 time,
                                 style: TextStyle(
                                   color: isSelected ? Colors.white : Colors.black,
                                   fontWeight: FontWeight.w600,
                                 ),
                               ),
                             ),
                           ),
                         ),
                       );
                    }).toList(),
                  )),

                  const SizedBox(height: 24),
                  const Text('Select Service Provider', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  // Provider List
                  Obx(() => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: controller.providers.map((provider) {
                       final isSelected = controller.selectedProvider.value == provider;
                       return GestureDetector(
                         onTap: () => controller.selectedProvider.value = provider,
                         child: Container(
                           width: (Get.width - 32 - 24) / 3, // 3 columns
                           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                           decoration: BoxDecoration(
                             color: isSelected ? const Color(0xFFE31E51) : Colors.white,
                             borderRadius: BorderRadius.circular(12),
                             border: Border.all(color: isSelected ? const Color(0xFFE31E51) : Colors.grey[200]!),
                           ),
                           alignment: Alignment.center,
                           child: Text(
                             provider,
                             textAlign: TextAlign.center,
                             style: TextStyle(
                               color: isSelected ? Colors.white : Colors.black,
                               fontWeight: FontWeight.w600,
                               fontSize: 13,
                             ),
                           ),
                         ),
                       );
                    }).toList(),
                  )),
                   const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
          
          // Bottom Button (Fixed)
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
                child: SizedBox(
                   width: double.infinity,
                   height: 50,
                   child: Obx(() {
                     final isValid = controller.selectedDate.value != null &&
                                     controller.selectedTime.isNotEmpty &&
                                     controller.selectedProvider.isNotEmpty;
                     
                     return ElevatedButton(
                        onPressed: isValid ? () => Get.toNamed(AppRoutes.BOOKING_SUCCESS) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE31E51),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: Colors.grey[300],
                        ),
                        child: const Text(
                          'Confirm Booking',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                   }),
                ),
              ),
          ),
        ],
      ),
    );
  }
}
