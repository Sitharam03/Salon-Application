import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/favorites/controllers/favorites_controller.dart';
import 'package:salon/app/modules/User_Screens/favorites/widgets/favorite_salon_card.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:salon/app/widgets/user_bottom_nav_bar.dart';
import 'package:salon/app/widgets/notification_badge_icon.dart';
import 'package:salon/app/widgets/remove_favorite_dialog.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Match clean white background
      appBar: AppBar(
        title: Obx(() => controller.isSearchActive.value 
          ? TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search favorites...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: controller.onSearchChanged,
            )
          : const Text(
              'Favourites',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            )
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true, // Title on left as per image? Android default is left. Image shows it on left.
        actions: [
          Obx(() => IconButton(
            onPressed: controller.toggleSearch,
            icon: Icon(controller.isSearchActive.value ? Icons.close : Icons.search, color: const Color(0xFF1F2937)),
          )),
          const NotificationBadgeIcon(),
          
          //  IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.more_vert, color: Color(0xFF1F2937)),
          // ),
        ],
      ),
      body: Obx(() {
        if (controller.filteredFavorites.isEmpty) {
          return Center(
            child: Text(
              controller.isSearchActive.value ? "No matching favorites" : "No favorites yet",
              style: TextStyle(color: Colors.grey[500]),
            ),
          );
        }
        return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: controller.filteredFavorites.length,
            itemBuilder: (context, index) {
              final salon = controller.filteredFavorites[index];
              return FavoriteSalonCard(
                imageUrl: salon['imageUrl'] ?? 'https://via.placeholder.com/80',
                name: salon['name'],
                location: salon['location'],
                rating: salon['rating'].toDouble(),
                reviews: salon['reviews'],
                status: salon['status'],
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
                onFavoriteTap: () {
                  Get.dialog(
                    RemoveFavoriteDialog(
                      salonName: salon['name'],
                      onRemove: () {
                        controller.removeFavorite(salon['id']);
                        Get.back(); // Close dialog
                        Get.snackbar(
                          'Removed', 
                          '${salon['name']} removed from favorites',
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(20),
                          backgroundColor: Colors.black87,
                          colorText: Colors.white,
                        );
                      },
                      onCancel: () {
                        Get.back(); // Close dialog
                      },
                    ),
                  );
                },
              );
            },
          );
      }),

    );
  }
}
