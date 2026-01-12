import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:geolocator/geolocator.dart';

class HomeController extends GetxController {
  final currentAddress = ''.obs;
  final currentCity = ''.obs;
  
  // Coordinates of current user
  double? userLat;
  double? userLng;

  // Categories Data
   final categories = <Map<String, dynamic>>[
    {'name': 'Haircut', 'icon': 'assets/icons/haircut.png'}, 
    {'name': 'Makeup', 'icon': 'assets/icons/makeup.png'},
    {'name': 'Manicure', 'icon': 'assets/icons/manicure.png'},
    {'name': 'Massage', 'icon': 'assets/icons/massage.png'},
  ].obs;

  // Mock Data for Nearby Salons with Coordinates
  final nearbySalons = <Map<String, dynamic>>[
     {
      'name': 'Naturals Parlour',
      'location': 'Miyapur, Hyderabad',
      'rating': 4.2,
      'imageUrl': 'https://plus.unsplash.com/premium_photo-1661281350976-59b9514e5364?q=80&w=2969&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'lat': 17.5169,
      'lng': 78.3462,
      'distance': 0.0, // Calculated dynamically
    },
    {
      'name': 'Green Trends',
      'location': 'Kondapur, Hyderabad',
      'rating': 4.5,
      'imageUrl': 'https://images.unsplash.com/photo-1560066984-12186d30b7aa?q=80&w=2696&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'lat': 17.4622,
      'lng': 78.3568,
      'distance': 0.0,
    },
    {
      'name': 'Lakme Salon',
      'location': 'Gachibowli, Hyderabad',
      'rating': 4.1,
      'imageUrl': 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'lat': 17.4401,
      'lng': 78.3489,
      'distance': 0.0,
    },
     {
      'name': 'Toni & Guy',
      'location': 'Jubilee Hills, Hyderabad',
      'rating': 4.8,
      'imageUrl': 'https://images.unsplash.com/photo-1521590832169-d7fcbe2af40f?q=80&w=2669&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'lat': 17.4312,
      'lng': 78.4079,
      'distance': 0.0,
    },
  ].obs;

  // Top Rated Salons for Carousel
  final topRatedSalons = <Map<String, dynamic>>[
     {
      'name': 'Toni & Guy',
      'location': 'Jubilee Hills',
      'rating': 4.9,
      'imageUrl': 'https://images.unsplash.com/photo-1521590832169-d7fcbe2af40f?q=80&w=2669&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'discount': '20% OFF',
      'lat': 17.4312,
      'lng': 78.4079,
      'distance': 0.0,
      'distanceText': '0 km',
    },
    {
      'name': 'Mirrors Luxury',
      'location': 'Gachibowli',
      'rating': 4.8,
      'imageUrl': 'https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=2669&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'discount': 'Free Hair Spa',
      'lat': 17.4401,
      'lng': 78.3489,
      'distance': 0.0,
      'distanceText': '0 km',
    },
     {
      'name': 'Bounce Salon',
      'location': 'Banjara Hills',
      'rating': 4.7,
      'imageUrl': 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=2672&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'discount': '15% OFF',
      'lat': 17.4134,
      'lng': 78.4483,
      'distance': 0.0,
      'distanceText': '0 km',
    },
    {
      'name': 'Juice Salon',
      'location': 'Hitech City',
      'rating': 4.6,
      'imageUrl': 'https://images.unsplash.com/photo-1492106087820-71f1a45d2b88?q=80&w=2587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'discount': 'Combo Deal',
      'lat': 17.4504,
      'lng': 78.3808,
      'distance': 0.0,
      'distanceText': '0 km',
    },
     {
      'name': 'Vurve Salon',
      'location': 'Madhapur',
      'rating': 4.8,
      'imageUrl': 'https://images.unsplash.com/photo-1595476108010-b4d1f102b1b1?q=80&w=2576&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'discount': 'New Arrival',
      'lat': 17.4483,
      'lng': 78.3915,
      'distance': 0.0,
      'distanceText': '0 km',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Get arguments passed from Maps
    if (Get.arguments != null) {
      currentAddress.value = Get.arguments['address'] ?? '';
      currentCity.value = Get.arguments['city'] ?? '';
      userLat = Get.arguments['latitude'];
      userLng = Get.arguments['longitude'];
      
      calculateDistances();
    }
  }
  
  void calculateDistances() {
    if (userLat == null || userLng == null) return;
    
    // Helper function to update distance
    void updateListDistances(List<Map<String, dynamic>> list) {
        for (var salon in list) {
          if (salon['lat'] != null && salon['lng'] != null) {
             double distanceInMeters = Geolocator.distanceBetween(
              userLat!,
              userLng!,
              salon['lat'],
              salon['lng'],
            );
            salon['distance'] = distanceInMeters / 1000;
            salon['distanceText'] = '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
          }
        }
    }

    // Update Nearby Salons
    final updatedNearby = List<Map<String, dynamic>>.from(nearbySalons);
    updateListDistances(updatedNearby);
    // Sort by distance
    updatedNearby.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));
    nearbySalons.value = updatedNearby;


    // Update Top Rated Salons
    final updatedTopRated = List<Map<String, dynamic>>.from(topRatedSalons);
    updateListDistances(updatedTopRated);
    topRatedSalons.value = updatedTopRated;
  }

  void changeLocation() {
    // Navigate back to Maps with destination HOME to update location
    Get.toNamed(
      AppRoutes.MAPS,
      arguments: {'destination': AppRoutes.HOME}
    );
  }
}
