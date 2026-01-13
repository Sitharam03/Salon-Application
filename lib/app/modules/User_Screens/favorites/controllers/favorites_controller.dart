import 'package:get/get.dart';

class FavoritesController extends GetxController {
  // Mock Data matching the image, now with web URLs to work with Image.network
  final RxList<Map<String, dynamic>> favoriteSalons = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'Naturals Parlour',
      'location': 'Miyapur, Hyderabad',
      'rating': 4.8,
      'reviews': 124,
      'status': 'Open',
      'imageUrl': 'https://plus.unsplash.com/premium_photo-1661281350976-59b9514e5364?q=80&w=2969&auto=format&fit=crop', 
    },
    {
      'id': '2',
      'name': 'Green Trends',
      'location': 'Kukatpally, Hyderabad',
      'rating': 4.5,
      'reviews': 89,
      'status': 'Open',
       'imageUrl': 'https://images.unsplash.com/photo-1560066984-12186d30b7aa?q=80&w=2696&auto=format&fit=crop', 
    },
    {
      'id': '3',
      'name': 'Lakme Salon',
      'location': 'Hitech City, Hyderabad',
      'rating': 4.9,
      'reviews': 210,
      'status': 'Open',
       'imageUrl': 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=2574&auto=format&fit=crop', 
    },
    {
      'id': '4',
      'name': 'Jawed Habib',
      'location': 'Gachibowli, Hyderabad',
      'rating': 4.2,
      'reviews': 56,
      'status': 'Closed',
       'imageUrl': 'https://images.unsplash.com/photo-1521590832169-d7fcbe2af40f?q=80&w=2669&auto=format&fit=crop', 
    },
    {
      'id': '5',
      'name': 'Tony & Guy',
      'location': 'Jubilee Hills, Hyderabad',
      'rating': 4.7,
      'reviews': 178,
      'status': 'Open',
       'imageUrl': 'https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=2669&auto=format&fit=crop', 
    },
     {
      'id': '6',
      'name': 'Style Lounge',
      'location': 'Madhapur, Hyderabad',
      'rating': 4.3,
      'reviews': 42,
      'status': 'Open',
       'imageUrl': 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=2672&auto=format&fit=crop', 
    },
  ].obs;
  bool isFavorite(String? id) {
    if (id == null) return false;
    return favoriteSalons.any((element) => element['id'] == id);
  }

  void toggleFavorite(Map<String, dynamic> salon) {
    final id = salon['id']?.toString() ?? salon['name']; // Fallback to name if id missing (mock data consistency)
    
    // Ensure salon map has an ID for future checks if it didn't before
    final salonWithId = Map<String, dynamic>.from(salon);
    salonWithId['id'] = id;

    if (isFavorite(id)) {
      favoriteSalons.removeWhere((element) => element['id'] == id);
      Get.snackbar('Removed from Favorites', '${salon['name']} has been removed from your favorites.');
    } else {
      // Add necessary fields if missing from the source (Home/TopRated) to match Favorites view expectations
      if (!salonWithId.containsKey('reviews')) salonWithId['reviews'] = 0;
      if (!salonWithId.containsKey('status')) salonWithId['status'] = 'Open'; // Default
      
      favoriteSalons.add(salonWithId);
      Get.snackbar('Added to Favorites', '${salon['name']} has been added to your favorites.');
    }
  }

  void removeFavorite(String id) {
    favoriteSalons.removeWhere((element) => element['id'] == id);
  }
}
