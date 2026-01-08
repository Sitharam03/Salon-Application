import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/orders_controller.dart';
import '../widgets/order_card.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<OrdersController>()) {
      Get.lazyPut(() => OrdersController());
    }

    return Column(
      children: [
        // Filter Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                // Date Section
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: controller.selectedDate.value,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      ).then((picked) {
                        if (picked != null) {
                          controller.changeDate(picked);
                        }
                      });
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Obx(() => Text(
                              "${controller.selectedDate.value.day}-${controller.selectedDate.value.month}-${controller.selectedDate.value.year}",
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            )),
                      ],
                    ),
                  ),
                ),
                
                // Divider
                Container(
                  height: 24,
                  width: 1,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),

                // Filter Section
                Expanded(
                  child: PopupMenuButton<String>(
                    color: Colors.white,
                    onSelected: (value) => controller.changeFilter(value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'All', child: Text('All Orders')),
                      const PopupMenuItem(value: 'Pending', child: Text('Pending')),
                      const PopupMenuItem(value: 'Accepted', child: Text('Accepted')),
                      const PopupMenuItem(value: 'Rejected', child: Text('Rejected')),
                    ],
                    offset: const Offset(0, 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Align filter text to the right usually looks better or center
                      children: [
                        const Icon(Icons.filter_list, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Obx(() => Text(
                              controller.selectedFilter.value == 'All'
                                  ? "Filters"
                                  : controller.selectedFilter.value,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            )),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

          // Stats Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => _buildStatCard(
                    'Accepted',
                    controller.acceptedCount.toString(),
                    const Color(0xFF00C569),
                  )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => _buildStatCard(
                    'Rejected',
                    controller.rejectedCount.toString(),
                    const Color(0xFFE22424),
                  )),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // List Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                 const Text(
                    'ALL ORDERS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1,
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),

          // Orders List
          Expanded(
            child: Obx(() {
               final orders = controller.filteredOrders;
               if (orders.isEmpty) {
                 return Center(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       const Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
                       const SizedBox(height: 8),
                       Text(
                         'No orders found for this date',
                         style: TextStyle(color: Colors.grey[600]),
                       ),
                     ],
                   ),
                 );
               }
               return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderCard(
                    order: order,
                    onAccept: () => controller.acceptOrder(order.id),
                    onReject: () => controller.rejectOrder(order.id),
                  );
                },
              );
            }),
          ),
        ],
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
