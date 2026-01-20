import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:salon/app/modules/User_Screens/dashboard/controllers/user_dashboard_controller.dart' as salon_dashboard;
import 'package:salon/app/services/mock_data_service.dart';

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

  // Selected Categories for Filtering
  final selectedCategories = <String>[].obs;

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  // Mock Data maintained in Global Service
  List<Map<String, dynamic>> get nearbySalons => Get.find<MockDataService>().salons;

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
    // Since nearbySalons getter returns the RxList from service, we can allow it to remain referenced.
    // However, to trigger reactivity on property changes inside the map in RxList, 
    // usually we need to call .refresh() on the RxList.
    
    // Calculate distances in place
    updateListDistances(nearbySalons);
    
    // Sort by distance
    nearbySalons.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));
    
    // Manually notify listeners if needed, though sort() on RxList usually triggers rebuilds.
    // Get.find<MockDataService>().salons.refresh();


    // Update Top Rated Salons
    final updatedTopRated = List<Map<String, dynamic>>.from(topRatedSalons);
    updateListDistances(updatedTopRated);
    topRatedSalons.value = updatedTopRated;
  }

  // Search State
  final isSearchActive = false.obs;
  final searchQuery = ''.obs;

  List<Map<String, dynamic>> get filteredSalons {
    // Both search query and selected categories are empty
    if (searchQuery.isEmpty && selectedCategories.isEmpty) {
      return nearbySalons;
    }
    
    return nearbySalons.where((salon) {
      bool nameMatches = true;
      bool locationMatches = true;

      // Filter by search query if it's not empty
      if (searchQuery.isNotEmpty) {
          nameMatches = salon['name'].toString().toLowerCase().contains(searchQuery.value.toLowerCase());
          locationMatches = salon['location'].toString().toLowerCase().contains(searchQuery.value.toLowerCase());
      } else {
        nameMatches = false; // Reset to false to rely on OR condition if query is present?
        // Wait, logic:
        // if query is empty, we match all names/locations (effectively).
        // if selectedCategories is empty, we match all categories.
        // We want (Query Matches) AND (Category Matches)
      }
      
      // Re-evaluating logic for clarity:
      final matchesQuery = searchQuery.isEmpty || 
                           salon['name'].toString().toLowerCase().contains(searchQuery.value.toLowerCase()) || 
                           salon['location'].toString().toLowerCase().contains(searchQuery.value.toLowerCase());

      bool categoryMatches = true;
      if (selectedCategories.isNotEmpty) {
        final salonCategories = List<String>.from(salon['categories'] ?? []);
        // Check if salon matches ANY of the selected categories
        categoryMatches = selectedCategories.any((cat) => salonCategories.contains(cat));
      }

      return matchesQuery && categoryMatches;
    }).toList();
  }

  void toggleSearch() {
    isSearchActive.value = !isSearchActive.value;
    if (!isSearchActive.value) {
      searchQuery.value = '';
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void changeLocation() {
    // Navigate back to Maps with destination HOME to update location
    Get.toNamed(
      AppRoutes.MAPS,
      arguments: {'destination': AppRoutes.HOME}
    );
  }

  void showTestNotification() {
    try {
      // Find global Dashboard controller to trigger notification
      final dashboardController = Get.find<salon_dashboard.UserDashboardController>();
      dashboardController.showTestNotification();
    } catch (e) {
      Get.snackbar('Error', 'Could not find Dashboard Controller');
    }
  }
}
