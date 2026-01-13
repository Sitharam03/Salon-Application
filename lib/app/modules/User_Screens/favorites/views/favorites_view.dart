import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/favorites/controllers/favorites_controller.dart';
import 'package:salon/app/modules/User_Screens/favorites/widgets/favorite_salon_card.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:salon/app/widgets/user_bottom_nav_bar.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Match clean white background
      appBar: AppBar(
        title: const Text(
          'Favourites',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false, // Title on left as per image? Android default is left. Image shows it on left.
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Color(0xFF1F2937)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Color(0xFF1F2937)),
          ),
           IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Color(0xFF1F2937)),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.favoriteSalons.isEmpty) {
          return Center(
            child: Text(
              "No favorites yet",
              style: TextStyle(color: Colors.grey[500]),
            ),
          );
        }
        return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: controller.favoriteSalons.length,
            itemBuilder: (context, index) {
              final salon = controller.favoriteSalons[index];
              return FavoriteSalonCard(
                imageUrl: salon['imageUrl'] ?? 'https://via.placeholder.com/80',
                name: salon['name'],
                location: salon['location'],
                rating: salon['rating'].toDouble(),
                reviews: salon['reviews'],
                status: salon['status'],
                onTap: () {
                   Get.toNamed(AppRoutes.SALON_DETAILS, arguments: salon);
                },
                onFavoriteTap: () {
                  Get.defaultDialog(
                    title: "Remove from Favorites?",
                    middleText: "Are you sure you want to remove ${salon['name']} from your favorites?",
                    textConfirm: "Remove",
                    textCancel: "Cancel",
                    confirmTextColor: Colors.white,
                    buttonColor: const Color(0xFFE31E51),
                    cancelTextColor: Colors.black,
                    onConfirm: () {
                      controller.removeFavorite(salon['id']);
                      Get.back(); // Close dialog
                      Get.snackbar('Removed', '${salon['name']} removed from favorites');
                    },
                  );
                },
              );
            },
          );
      }),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 2),
    );
  }
}
