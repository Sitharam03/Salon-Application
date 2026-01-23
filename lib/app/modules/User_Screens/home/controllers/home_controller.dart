import 'package:flutter/material.dart';
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
  // Categories Data
   List<Map<String, dynamic>> get categories {
     return Get.find<MockDataService>().categories.map((cat) => {
       'name': cat, 
       // You can add logic here to fetch icon path if moved to service
     }).toList();
   }

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
      'status': 'Open',
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
      'status': 'Closed',
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
      'status': 'Open',
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
      'status': 'Closed',
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
      'status': 'Open',
    },
  ].obs;

  // Track if location has been manually selected/confirmed
  var isLocationSelected = false;

  final isLoadingLocation = true.obs;
  final locationError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Defer state updates to avoid 'setState during build' if controller is initialized during view build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get arguments passed from Maps
      if (Get.arguments != null && Get.arguments['address'] != null) {
        _updateFromArgs(Get.arguments);
        isLoadingLocation.value = false;
      } else {
          // Auto-fetch on start
          checkAndFetchLocation();
      }
    });
  }

  void _updateFromArgs(dynamic arguments) {
       currentAddress.value = arguments['address'] ?? '';
       currentCity.value = arguments['city'] ?? '';
       userLat = arguments['latitude'];
       userLng = arguments['longitude'];
       isLocationSelected = true; // Mark as selected so we don't loop
       calculateDistances();
  }
  
  Future<void> checkAndFetchLocation({bool isUserInteraction = false}) async {
    // If already selected via Maps, don't auto-fetch/redirect again (unless forcing retry)
    if (isLocationSelected && !isUserInteraction) return;

    isLoadingLocation.value = true;
    locationError.value = '';
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (isUserInteraction) {
           // If user clicked 'Enable Location', open settings
           await Geolocator.openLocationSettings();
           // Wait a bit for user to potentially enable it, or just rely on next check?
           // Actually, openLocationSettings returns Future<bool> on some platforms or just Future<void>
           // Checking again immediately might fail. The user typically comes back to app.
           // Can we listen to stream? For simplicity, we open settings and suggest checking again.
           
           // Re-check after a small delay or let user click again? 
           // Better: Set error message telling them to enable it.
        }
        locationError.value = 'Location services are disabled. Please enable them.';
        isLoadingLocation.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationError.value = 'Location permission denied. We need location to show nearby salons.';
          isLoadingLocation.value = false;
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        if (isUserInteraction) {
           await Geolocator.openAppSettings();
        }
        locationError.value = 'Location permissions are permanently denied. Please enable in settings.';
        isLoadingLocation.value = false;
        return;
      }

      // Permission granted
      Position position = await Geolocator.getCurrentPosition();
      
      // REDIRECT TO MAPS
      Get.offNamed(
        AppRoutes.MAPS, 
        arguments: {
           'latitude': position.latitude,
           'longitude': position.longitude,
           'destination': AppRoutes.HOME
        }
      );
      
    } catch (e) {
      locationError.value = 'Failed to get location: $e';
      isLoadingLocation.value = false;
    }
  }
  
  void retryLocation() {
    checkAndFetchLocation(isUserInteraction: true);
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
    
    // Sort by Status (Open first) then Distance
    nearbySalons.sort((a, b) {
      final statusA = (a['status'] ?? '').toString().toLowerCase();
      final statusB = (b['status'] ?? '').toString().toLowerCase();

      // Prioritize 'open' status
      if (statusA == 'open' && statusB != 'open') return -1;
      if (statusA != 'open' && statusB == 'open') return 1;

      // If status priority is same, sort by distance
      return (a['distance'] as double).compareTo(b['distance'] as double);
    });
    
    // Manually notify listeners if needed, though sort() on RxList usually triggers rebuilds.
    // Get.find<MockDataService>().salons.refresh();


    // Update Top Rated Salons
    final updatedTopRated = List<Map<String, dynamic>>.from(topRatedSalons);
    updateListDistances(updatedTopRated);

    // Sort Top Rated Salons by Status then Distance
    updatedTopRated.sort((a, b) {
      final statusA = (a['status'] ?? '').toString().toLowerCase();
      final statusB = (b['status'] ?? '').toString().toLowerCase();

      // Prioritize 'open' status
      if (statusA == 'open' && statusB != 'open') return -1;
      if (statusA != 'open' && statusB == 'open') return 1;

      // If status priority is same, sort by distance
      return (a['distance'] as double).compareTo(b['distance'] as double);
    });

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
        
        // Semantic Keywork Matching
        categoryMatches = selectedCategories.any((selectedCat) {
           final keywords = _getSemanticKeywords(selectedCat);
           
           // Check if ANY salon category matches ANY keyword for this selected category
           return salonCategories.any((sCat) {
              final sCatLower = sCat.toString().toLowerCase();
              return keywords.any((keyword) => sCatLower.contains(keyword));
           });
        });
      }

      return matchesQuery && categoryMatches;
    }).toList();
  }
  
  // Helper to map UI Categories to broader semantic keywords
  List<String> _getSemanticKeywords(String category) {
    final catLower = category.toLowerCase();
    
    // Default keywords include the category itself
    final keywords = <String>{catLower};
    
    if (catLower.contains('hair')) {
      keywords.addAll(['hair', 'cut', 'style', 'color', 'blow', 'dry']);
    }
    if (catLower.contains('beard')) {
      keywords.addAll(['beard', 'shave', 'trim', 'groom']);
    }
    if (catLower.contains('facial') || catLower.contains('spa')) {
      keywords.addAll(['facial', 'spa', 'massage', 'manicure', 'pedicure', 'scrub', 'clean']);
    }
    if (catLower.contains('skin')) {
      keywords.addAll(['skin', 'makeup', 'facial', 'bleach', 'wax', 'clean']);
    }
    if (catLower.contains('massage')) {
      keywords.addAll(['massage', 'spa', 'reflexology', 'therapy']);
    }
    
    return keywords.toList();
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
