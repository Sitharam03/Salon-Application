import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/admin_dashboard/controllers/admin_dashboard_controller.dart';
import 'package:salon/app/modules/Admin_Screens/services/views/services_view.dart';
import 'package:salon/app/modules/Admin_Screens/service_providers/views/service_providers_view.dart';
import 'package:salon/app/modules/Admin_Screens/orders/views/orders_view.dart';
import 'package:salon/app/modules/Admin_Screens/orders/controllers/orders_controller.dart';
import 'package:salon/app/modules/Admin_Screens/orders/widgets/order_card.dart';
import 'package:salon/app/data/models/order_model.dart';
import 'package:salon/app/modules/Admin_Screens/profile/views/profile_view.dart';
import 'package:salon/app/modules/Admin_Screens/shop_details/views/shop_details_view.dart';
import 'package:salon/app/widgets/admin_bottom_nav_bar.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:salon/app/modules/Admin_Screens/notifications/controllers/notifications_controller.dart';

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
            backgroundColor: Colors.white,
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
                color: Colors.black,
              ),
            ),
            actions: [
              // Shop Status Toggle
              // Obx(() {
              //    bool isOpen = controller.isShopOpen.value;
              //    return Column(
              //      mainAxisAlignment: MainAxisAlignment.center,
              //      children: [
              //        SizedBox(
              //          height: 24,
              //          child: Switch(
              //            value: isOpen,
              //            activeColor: Colors.white,
              //            activeTrackColor: const Color(0xFFE53935), // Red when open/active? Or Green?
              //            // User said: "while open... on the toggle... while closes... off"
              //            // Image shows Red toggle for "SHOP CLOSED" maybe? 
              //            // Usually Green = Open, Red = Closed.
              //            // Let's assume standard: Active(On) = Open (Green?), Inactive(Off) = Closed.
              //            // BUT Image shows RED toggle and text "SHOP CLOSED" (hard to read).
              //            // Wait, user said "while closes it should off".
              //            // Let's make it: ON = OPEN (Green), OFF = CLOSED (Grey/Red).
              //            // However, if user wants "Red" color from image which looks like a specific design...
              //            // Let's stick to a custom design closer to the image if possible, or standard switch for functionality first.
              //            // Image shows a Red background switch.
              //            // Let's use Red for "Closed" state? Or is Red the primary brand color?
              //            // Let's use Green for Open, Grey for Closed for clarity, or Red for Open/Action.
              //            thumbColor: MaterialStateProperty.all(Colors.white),
              //            trackColor: MaterialStateProperty.resolveWith((states) => 
              //              isOpen ? const Color(0xFF43A047) : Colors.grey[300]
              //            ),
              //            onChanged: (val) {
              //              // Toggle logic
              //              controller.isShopOpen.value = val;
              //            },
              //          ),
              //        ),
              //        const SizedBox(height: 2),
              //        Text(
              //          isOpen ? 'SHOP OPEN' : 'SHOP CLOSED',
              //          style: TextStyle(
              //            fontSize: 8,
              //            fontWeight: FontWeight.bold,
              //            color: isOpen ? const Color(0xFF43A047) : const Color(0xFFE53935),
              //          ),
              //        )
              //      ],
              //    );
              // }),
              // const SizedBox(width: 12),

              Center(
                child: _buildHeaderIcon(
                  Icons.notifications_none, 
                  notificationCount: Get.find<NotificationsController>().unreadCount,
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

  Widget _buildHeaderIcon(IconData icon, {int notificationCount = 0, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: const Color(0xFF1E232C), size: 24),
          ),
          if (notificationCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFE22424),
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Center(
                  child: Text(
                    notificationCount > 9 ? '9+' : notificationCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // 1. Owner Access Card (Welcome)
            // 1. Dynamic Greeting Card (Animated)
            Obx(() => AnimatedSize(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutBack,
              child: controller.showGreetingCard.value
                  ? Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E232C), Color(0xFF2C3E50)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.greeting.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                controller.shopName.value,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                          // Animated Background Element
                          Positioned(
                            right: -20,
                            top: -20,
                            child: Opacity(
                              opacity: 0.1,
                              child: Icon(
                                Icons.storefront_rounded,
                                size: 120,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            )),

            // const SizedBox(height: 20),

            // 2. Performance Overview Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Card Header
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PERFORMANCE OVERVIEW',
                        style: TextStyle(
                          color: Color(0xFF90A4AE), // Blue-grey for professional look
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Icon(Icons.show_chart_rounded, color: Color(0xFFE53935), size: 20),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  // Stats Row with Dividers
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Scheduled (Pending)
                      Expanded(
                        child: _buildSimpleStatItem(
                          count: ordersController.pendingCount.toString(),
                          label: 'SCHEDULED',
                          countColor: const Color(0xFF1E232C), // Black
                        ),
                      ),
                      
                      // Divider
                      Container(width: 1, height: 40, color: Colors.grey[200]),
                      
                      // Completed (Accepted)
                      Expanded(
                        child: _buildSimpleStatItem(
                          count: ordersController.acceptedCount.toString(),
                          label: 'ACCEPTED',
                          countColor: const Color(0xFFE53935), // Red highlight as in image
                        ),
                      ),
                      
                      // Divider
                      Container(width: 1, height: 40, color: Colors.grey[200]),
                      
                      // Rejected
                      Expanded(
                        child: _buildSimpleStatItem(
                          count: ordersController.rejectedCount.toString(),
                          label: 'REJECTED',
                          countColor: const Color(0xFF1E232C), // Black
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 3. Requests List (With Filters)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Requests',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E232C),
                  ),
                ),
                 // Simple Filter Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: PopupMenuButton<String>(
                    elevation: 1,
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() => Text(
                          ordersController.selectedFilter.value == 'All' ? 'Filter' : ordersController.selectedFilter.value,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        )),
                        const SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Colors.grey[400]),
                      ],
                    ),
                    onSelected: (val) => ordersController.changeFilter(val),
                    itemBuilder: (_) => [
                        const PopupMenuItem(value: 'All', child: Text('All')),
                        const PopupMenuItem(value: 'Pending', child: Text('Pending')),
                        const PopupMenuItem(value: 'Accepted', child: Text('Accepted')),
                        const PopupMenuItem(value: 'Rejected', child: Text('Rejected')),
                    ]
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),

             Obx(() {
              if (ordersController.filteredOrders.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        Icon(Icons.inbox_outlined, size: 40, color: Colors.grey[300]),
                        const SizedBox(height: 12),
                        Text('No requests', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                      ],
                    ),
                  ),
                );
              }
              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: ordersController.filteredOrders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final order = ordersController.filteredOrders[index];
                  // Pass a cleaner look to OrderCard or wrap it
                  return OrderCard(
                    order: order,
                    onAccept: () => ordersController.showAcceptDialog(order),
                    onReject: () => ordersController.showRejectDialog(order),
                    onChangeProvider: () => ordersController.showChangeProviderDialog(order),
                  );
                },
              );
            }),
            
             const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleStatItem({required String count, required String label, required Color countColor}) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 30, // Large responsive number
            fontWeight: FontWeight.bold,
            color: countColor,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[400],
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch(status) {
      case OrderStatus.accepted: return const Color(0xFF43A047);
      case OrderStatus.rejected: return const Color(0xFFE53935);
      default: return const Color(0xFFFFB300);
    }
  }
}

