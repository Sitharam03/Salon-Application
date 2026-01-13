import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/home/controllers/home_controller.dart';
import 'package:salon/app/modules/User_Screens/favorites/controllers/favorites_controller.dart';
import 'package:salon/app/widgets/salon_card.dart';
import 'package:salon/app/routes/app_routes.dart';

class TopRatedSalonsView extends GetView<HomeController> {
  const TopRatedSalonsView({super.key});
  
  FavoritesController get favController => Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Top Rated Salons',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.topRatedSalons.isEmpty) {
          return const Center(child: Text("No top rated salons found."));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(24.0),
          itemCount: controller.topRatedSalons.length,
          itemBuilder: (context, index) {
            final salon = controller.topRatedSalons[index];
            return Obx(() {
               final isFav = favController.isFavorite(salon['name']);
               return SalonCard(
                imageUrl: salon['imageUrl'],
                name: salon['name'],
                location: salon['location'],
                rating: salon['rating'],
                distance: salon['distanceText'] ?? 'N/A',
                isFavorite: isFav,
                onFavoriteTap: () => favController.toggleFavorite(salon),
                onTap: () {
                  Get.toNamed(AppRoutes.SALON_DETAILS, arguments: salon);
                },
              );
            });
          },
        );
      }),
    );
  }
}
