import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/admin_dashboard/controllers/admin_dashboard_controller.dart';
import 'package:salon/app/modules/Admin_Screens/services/views/services_view.dart';
import 'package:salon/app/modules/Admin_Screens/service_providers/views/service_providers_view.dart';
import 'package:salon/app/modules/Admin_Screens/orders/views/orders_view.dart';
import 'package:salon/app/modules/Admin_Screens/orders/controllers/orders_controller.dart';
import 'package:salon/app/modules/Admin_Screens/orders/widgets/order_card.dart';
import 'package:salon/app/modules/Admin_Screens/profile/views/profile_view.dart';
import 'package:salon/app/modules/Admin_Screens/shop_details/views/shop_details_view.dart';
import 'package:salon/app/widgets/admin_bottom_nav_bar.dart';
import 'package:salon/app/routes/app_routes.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light grey background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          return AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              controller.selectedIndex.value == 1 
              ? 'Services' 
              : controller.selectedIndex.value == 2
                ? 'Service Providers'
                : controller.selectedIndex.value == 3
                  ? 'Orders'
                  : controller.selectedIndex.value == 4
                    ? 'Shop Details' 
                    : 'Dashboard',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E232C),
              ),
            ),
            actions: [
              Center(
                child: _buildHeaderIcon(
                  Icons.notifications_none, 
                  hasBadge: true,
                  onTap: () => Get.toNamed(AppRoutes.NOTIFICATIONS),
                ),
              ),
              const SizedBox(width: 20),
            ],
          );
        }),
      ),
      body: Obx(() {
        switch (controller.selectedIndex.value) {
          case 0:
            return _buildDashboardHome(context);
          case 1:
            return const ServicesView();
          case 2:
            return const ServiceProvidersView();
          case 3:
            return const OrdersView();
          case 4:
            return const ProfileView();
          default:
            return _buildDashboardHome(context);
        }
      }),
      bottomNavigationBar: Obx(
        () => AdminBottomNavBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTabIndex,
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, {bool hasBadge = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Icon(icon, color: const Color(0xFF1E232C), size: 24),
          ),
          if (hasBadge)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFE22424),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDashboardHome(BuildContext context) {
    // Ensure OrdersController is available
    final ordersController = Get.put(OrdersController());

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              const Text(
                'Welcome back,',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              const Row(
                children: [
                  Text(
                    'Hi, Admin',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E232C),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '👋',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Today's Client's (Dynamic Stats)
              const Text(
                "Today's Client's",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E232C),
                ),
              ),
              const SizedBox(height: 16),
              
              // Stats Row
              Obx(() => Row(
                children: [
                   Expanded(
                    child: _StatsCard(
                      title: 'PENDING',
                      count: ordersController.pendingCount.toString(),
                      color: const Color(0xFFFFC107), // Amber/Yellow
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatsCard(
                    title: 'ACCEPTED',
                      count: ordersController.acceptedCount.toString(),
                      color: const Color(0xFF00C569), // Green
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatsCard(
                      title: 'REJECTED',
                      count: ordersController.rejectedCount.toString(),
                      color: const Color(0xFFF75555), // Red
                    ),
                  ),
                ],
              )),
              
              const SizedBox(height: 32),
              
              // All Requests Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const ShopDetailsView(), arguments: {'isEditing': true});
                    },
                    child: const Text(
                      'All Requests',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E232C),
                      ),
                    ),
                  ),
                  // Action Buttons (Filter)
                  Row(
                    mainAxisSize: MainAxisSize.min, 
                    children: [
                      const SizedBox(width: 8), 
                      // Filter Dropdown
                      PopupMenuButton<String>(
                        color: Colors.white,
                        onSelected: (value) => ordersController.changeFilter(value),
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'All', child: Text('All Requests')),
                          const PopupMenuItem(value: 'Pending', child: Text('Pending')),
                          const PopupMenuItem(value: 'Accepted', child: Text('Accepted')),
                          const PopupMenuItem(value: 'Rejected', child: Text('Rejected')),
                        ],
                        offset: const Offset(0, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Obx(() => Text(
                                ordersController.selectedFilter.value == 'All' ? 'Filters' : ordersController.selectedFilter.value,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              )),
                              const SizedBox(width: 4),
                              const Icon(Icons.filter_list, size: 16, color: Colors.black87),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Orders List
              Obx(() {
                if (ordersController.filteredOrders.isEmpty) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No requests found',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ordersController.filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = ordersController.filteredOrders[index];
                    return OrderCard(
                      order: order,
                      onAccept: () => ordersController.acceptOrder(order.id),
                      onReject: () => ordersController.rejectOrder(order.id),
                    );
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const _StatsCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
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
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
