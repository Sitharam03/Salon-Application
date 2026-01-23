import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/home/controllers/home_controller.dart';
import 'package:salon/app/modules/User_Screens/favorites/controllers/favorites_controller.dart';
import 'package:salon/app/widgets/salon_card.dart';
import 'package:salon/app/widgets/user_bottom_nav_bar.dart';
import 'package:salon/app/widgets/notification_badge_icon.dart';
import 'package:salon/app/widgets/salon_carousel.dart';
import 'package:salon/app/modules/User_Screens/home/views/top_rated_salons_view.dart';
import 'package:salon/app/routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  
  FavoritesController get favController => Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar / Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Obx(() => Row(
                children: [
                   if (controller.isSearchActive.value) ...[
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                             autofocus: true,
                             decoration: const InputDecoration(
                               hintText: 'Search salons...',
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.only(bottom: 8),
                             ),
                             onChanged: controller.onSearchChanged,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: controller.toggleSearch,
                        child: const Icon(Icons.close, size: 24, color: Colors.black),
                      ),
                   ] else ...[
                      const Icon(Icons.location_on, color: Color(0xFFE31E51), size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: controller.changeLocation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(
                                    controller.currentCity.isEmpty 
                                        ? 'Select Location' 
                                        : controller.currentCity.value,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              Obx(() => Text(
                                    controller.currentAddress.isEmpty 
                                        ? 'Tap to set' 
                                        : controller.currentAddress.value,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.toggleSearch,
                        child: const Icon(Icons.search, size: 24),
                      ),
                       const SizedBox(width: 16),
                       const NotificationBadgeIcon(),
                    ],
                 ],
              )),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     // Top Rated Salons Carousel
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Top Rated Salons',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                TextButton(onPressed: (){
                                  Get.to(() => TopRatedSalonsView());
                                }, child: const Text("View All", style: TextStyle(color: Color(0xFFE31E51))))
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          SalonCarousel(salons: controller.topRatedSalons),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Categories Title
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Categories List
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          final category = controller.categories[index];
                          IconData iconData;
                          // Mapping strings to Icons for demo
                          switch (category['name'].toString().toLowerCase()) {
                            case 'hair':
                            case 'haircut': // Backward compatibility
                              iconData = Icons.content_cut;
                              break;
                            case 'beard':
                              iconData = Icons.face;
                              break;
                            case 'facial & spa':
                            case 'facial':
                            case 'spa':
                              iconData = Icons.spa;
                              break;
                            case 'skin care':
                            case 'makeup': // Assume mapped roughly or separate
                              iconData = Icons.brush;
                              break;
                            case 'manicure':
                              iconData = Icons.fingerprint;
                              break;
                            case 'massage':
                              iconData = Icons.back_hand;
                              break;
                            default:
                              iconData = Icons.category;
                          }

                          return Obx(() {
                            final isSelected = controller.selectedCategories.contains(category['name']);
                            return GestureDetector(
                              onTap: () => controller.toggleCategory(category['name']),
                              child: Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: Column(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFFE31E51) : Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: isSelected 
                                                ? const Color(0xFFE31E51).withOpacity(0.3) 
                                                : Colors.black.withOpacity(0.05),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                        border: isSelected ? null : Border.all(color: Colors.transparent),
                                      ),
                                      child: Icon(
                                        iconData, 
                                        color: isSelected ? Colors.white : const Color(0xFFE31E51), 
                                        size: 28
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      category['name'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                        color: isSelected ? const Color(0xFFE31E51) : Colors.black87,
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

                    // Nearby Salons Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nearby Salons',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          // Hidden Dev Button for testing
                          GestureDetector(
                            onTap: controller.showTestNotification, 
                            child: const Text('Simulate Push', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // List of Salons
                    Obx(() {
                       if (controller.filteredSalons.isEmpty) {
                         return Center(child: Text(controller.isSearchActive.value ? "No matching salons found" : "No salons found nearby", style: TextStyle(color: Colors.grey[500])));
                       }
                       
                       return Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 24.0),
                         child: Column(
                            children: List.generate(controller.filteredSalons.length, (index) {
                              final salon = controller.filteredSalons[index];
                              return Obx(() {
                                final isFav = favController.isFavorite(salon['name']); // Use name or ID logic relative to controller
                                return SalonCard(
                                  imageUrl: salon['imageUrl'],
                                  name: salon['name'],
                                  location: salon['location'],
                                  rating: salon['rating'],
                                  distance: salon['distanceText'] ?? 'N/A',
                                  status: salon['status'],
                                  isFavorite: isFav,
                                  onFavoriteTap: () => favController.toggleFavorite(salon),
                                  onTap: () {
                                      if (salon['status']?.toString().toLowerCase() == 'closed') {
                                        Get.snackbar(
                                          'Shop Closed', 
                                          'This salon is currently closed and not accepting bookings.',
                                          snackPosition: SnackPosition.BOTTOM,
                                          margin: const EdgeInsets.all(20),
                                          backgroundColor: Colors.black87,
                                          colorText: Colors.white,
                                          duration: const Duration(seconds: 2),
                                        );
                                        return;
                                      }
                                      Get.toNamed(AppRoutes.SALON_DETAILS, arguments: salon);
                                  },
                                );
                              });
                            }),
                         ),
                       );
                    }),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
