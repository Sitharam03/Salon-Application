import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/booking/controllers/booking_controller.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:salon/app/modules/User_Screens/favorites/controllers/favorites_controller.dart';

class SalonDetailsView extends GetView<BookingController> {
  const SalonDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Curved Header with PageView
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => Get.back(),
            ),
            title: Obx(() => Text(
              controller.salonData['name'] ?? 'Salon Details',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.black),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              Obx(() {
                 final favController = Get.find<FavoritesController>();
                 final isFav = favController.isFavorite(controller.salonData['name']); // Or ID
                 return IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? const Color(0xFFE31E51) : Colors.black,
                    ),
                  ),
                  onPressed: () => favController.toggleFavorite(controller.salonData),
                );
              }),
              const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              // Title is handled by SliverAppBar.title, which fades in/out automatically or stays based on settings.
              // If we want it ONLY when collapsed, the default SliverAppBar behavior does this closely enough, 
              // or requires a scroll listener. Default pinned behavior with title usually works well.
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    // Large item count for infinite scroll feel
                    itemCount: 1000000, 
                    itemBuilder: (context, index) {
                      // Modulo to cycle through images
                      final imageIndex = index % controller.salonImages.length;
                      return Obx(() => Image.network(
                        controller.salonImages[imageIndex],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300]),
                      ));
                    },
                  ),
                  // Page Indicator (Optional, but good UX)
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(controller.salonImages.length, (index) {
                        // Calculate active index from various potential large numbers
                        final currentRealIndex = controller.activePageIndex.value % controller.salonImages.length;
                        final isActive = currentRealIndex == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: isActive ? const Color(0xFFE31E51) : Colors.white.withOpacity(0.8),
                          ),
                        );
                      }),
                    )),
                  ),
                  // Curve Effect
                  Positioned(
                    bottom: -1, 
                    left: 0, 
                    right: 0,
                    child: Container(
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Salon Details & Categories
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Location (Still visible at top of body for initial view)
                   Obx(() => Text(
                    controller.salonData['name'] ?? 'Salon Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Obx(() => Text(
                          controller.salonData['location'] ?? 'Location',
                          style: const TextStyle(color: Colors.grey),
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Rating and Get Directions
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.amber),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.amber),
                            const SizedBox(width: 4),
                            Obx(() => Text(
                              "${controller.salonData['rating'] ?? 4.5}",
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '(128 reviews)',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => controller.launchMaps(), 
                        icon: const Icon(Icons.directions, size: 16, color: Color(0xFFE31E51)), 
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        label: const Text('Get Directions', style: TextStyle(color: Color(0xFFE31E51), fontSize: 12))
                      )
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Men/Women Toggle
                  Container(
                    height: 50,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6), // Light grey background
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Obx(() => Row(
                      children: [
                        // Men
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.selectCategory('Men'),
                            child: Container(
                              decoration: BoxDecoration(
                                color: controller.selectedCategory.value == 'Men' ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: controller.selectedCategory.value == 'Men' ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  )
                                ] : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Men',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: controller.selectedCategory.value == 'Men' ? Colors.black : Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Women
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.selectCategory('Women'),
                            child: Container(
                              decoration: BoxDecoration(
                                color: controller.selectedCategory.value == 'Women' ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: controller.selectedCategory.value == 'Women' ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  )
                                ] : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Women',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: controller.selectedCategory.value == 'Women' ? Colors.black : Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // "Our Services" Header
                  const Text(
                    'Our Services',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Services Lists
          Obx(() => SliverList( // Wrap SliverList in Obx to update when visibleServices changes
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = controller.visibleServices[index];
                final categoryName = category['category'] as String;
                final items = category['items'] as List<Map<String, dynamic>>;

                return Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text(
                      categoryName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    childrenPadding: EdgeInsets.zero,
                    initiallyExpanded: true,
                    children: items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 12, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Approx ${item['duration']}',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${item['price']}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Obx(() {
                                final isSelected = controller.isServiceSelected(item);
                                return TextButton(
                                  onPressed: () => controller.toggleService(item),
                                  style: TextButton.styleFrom(
                                    backgroundColor: isSelected ? const Color(0xFF10B981) : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE5E7EB)),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isSelected ? 'Added' : 'Add',
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (!isSelected) ...[
                                        const SizedBox(width: 4),
                                        const Icon(Icons.add, size: 16, color: Colors.black),
                                      ]
                                      else ...[
                                        const SizedBox(width: 4),
                                        const Icon(Icons.check, size: 16, color: Colors.white),
                                      ],
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
              childCount: controller.visibleServices.length,
            ),
          )),
          
          // Bottom Padding so content isn't hidden behind the sticky button
          const SliverPadding(padding: EdgeInsets.only(bottom: 20)), 
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                    '${controller.selectedServices.length} Service Selected',
                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                  )),
                  Obx(() => Text(
                    '\$${controller.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.selectedServices.isNotEmpty 
                    ? () => Get.toNamed(AppRoutes.BOOKING_SLOT) 
                    : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE31E51),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
