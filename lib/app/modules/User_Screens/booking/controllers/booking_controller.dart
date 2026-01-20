import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:salon/app/services/mock_data_service.dart';
import 'package:salon/app/data/models/order_model.dart';
import 'package:salon/app/routes/app_routes.dart';

class BookingController extends GetxController {
  // Salon Data
  final salonData = <String, dynamic>{}.obs;
  
  // Mock Images for Banner
  final salonImages = [
    'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1562322140-8baeececf3df?auto=format&fit=crop&w=800&q=80',
  ].obs;
  
  // Carousel Control
  late PageController pageController;
  late Timer _timer;
  final activePageIndex = 0.obs;

  // Selected Services: Id -> Map (using Set for unique or list for multiple)
  // For simplicity, using a list of maps
  final selectedServices = <Map<String, dynamic>>[].obs;
  
  // Slot Selection
  final selectedDate = Rxn<DateTime>();
  final selectedTime = ''.obs;
  final selectedProvider = ''.obs;

  // Tabs (Dynamic Categories from Backend)
  final categories = ['Men', 'Women'].obs;
  final selectedCategory = 'Men'.obs;
  
  // All Services Data
  final _allServices = [
    {
      'category': 'Hair',
      'target': ['Men', 'Women'],
      'items': [
        {'id': '1', 'name': 'Hair Cut', 'duration': '45 Mins', 'price': 15.00},
        {'id': '2', 'name': 'Hair Color', 'duration': '60 Mins', 'price': 50.00},
        {'id': '3', 'name': 'Hair Wash', 'duration': '30 Mins', 'price': 10.00},
      ]
    },
     {
      'category': 'Beard',
      'target': ['Men'],
      'items': [
        {'id': '4', 'name': 'Beard Shaving', 'duration': '30 Mins', 'price': 12.00},
        {'id': '5', 'name': 'Beard Trimming', 'duration': '20 Mins', 'price': 8.00},
      ]
    },
     {
      'category': 'Styling',
      'target': ['Women'],
      'items': [
        {'id': '6', 'name': 'Straightening', 'duration': '90 Mins', 'price': 80.00},
        {'id': '7', 'name': 'Curling', 'duration': '45 Mins', 'price': 60.00},
        {'id': '8', 'name': 'Blow Dry', 'duration': '30 Mins', 'price': 40.00},
      ]
    },
  ];

  // Filtered Services Getter
  List<Map<String, dynamic>> get visibleServices {
    return _allServices.where((cat) {
      final targets = cat['target'] as List<String>;
      return targets.contains(selectedCategory.value);
    }).toList();
  }

  final providers = ['Vignesh', 'Prasad', 'Ram', 'Pramod'];
  final timeSlots = [
    '06:00 AM', '07:00 AM', '08:00 AM', 
    '09:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '02:00 PM', '03:00 PM',
    '04:00 PM', '05:00 PM', '06:00 PM'
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments is Map<String, dynamic>) {
         salonData.value = Get.arguments;
         
         // Handle Reschedule Date
         if (Get.arguments['rescheduleDate'] != null) {
           try {
             // Assuming date format is "OCT 10" or similar, which is hard to parse directly without year.
             // For this demo, since mock data sends "OCT 10", we'll just try to match it or default to today if complex.
             // Ideally argument should be a DateTime object or ISO string.
             // Let's assume we pass a DateTime object for simplicity in this flow, 
             // or sticking to the string if that's what we have.
             
             // If we passed the mock string, we can't easily convert "OCT 10" to DateTime without year.
             // So I will update the logic to set 'selectedDate' to today + index if it matches? 
             // Or better: Logic in BookingDetailsController should pass a DateTime.
             
             if (Get.arguments['rescheduleDate'] is DateTime) {
                selectedDate.value = Get.arguments['rescheduleDate'];
             }
           } catch (e) {
             print("Error parsing date: $e");
           }
         }
      }
    }
    
    // Auto-scroll logic (Infinite)
    // Start at a large index to allow scrolling back manually if needed, 
    // but primarily to support continuous forward scrolling.
    const initialPage = 1000;
    pageController = PageController(initialPage: initialPage);
    activePageIndex.value = initialPage; // Initialize observable

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (pageController.hasClients) {
        final nextPage = (pageController.page ?? initialPage.toDouble()).round() + 1;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear, // Smoother continuous-like feel, or easeIn
        );
      }
    });
  }

  @override
  void onClose() {
    _timer.cancel();
    pageController.dispose();
    super.onClose();
  }
  
  void onPageChanged(int index) {
    activePageIndex.value = index;
  }

  void toggleService(Map<String, dynamic> service) {
    if (isServiceSelected(service)) {
      selectedServices.removeWhere((s) => s['id'] == service['id']);
    } else {
      selectedServices.add(service);
    }
  }

  bool isServiceSelected(Map<String, dynamic> service) {
    return selectedServices.any((s) => s['id'] == service['id']);
  }

  double get totalPrice {
    return selectedServices.fold(0.0, (sum, item) => sum + (item['price'] as double));
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    // Here you would typically fetch services for this category
    // fetchServices(category);
  }

  Future<void> launchMaps() async {
    final location = salonData['location'] ?? 'Miyapur, Hyderabad';
    final query = Uri.encodeComponent(location);
    final googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$query";
    
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
      Get.snackbar('Error', 'Could not launch maps');
    }
  }

  // Booking Confirmation
  void confirmBooking() {
    if (selectedDate.value == null || selectedTime.value.isEmpty) {
      Get.snackbar('Error', 'Please select date and time');
      return;
    }

    final newBooking = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: 'User', // Mock user
      customerPhone: '9876543210',
      customerImage: 'assets/profile_avatar.png',
      status: OrderStatus.pending,
      date: selectedDate.value!,
      time: selectedTime.value,
      services: selectedServices.map((s) => s['name'] as String).toList(),
    );

    Get.find<MockDataService>().addBooking(newBooking);

    // Send Notification to Admin (Simulated by User notification for demo, or separate channel)
    // In real app, this triggers FCM to Admin.
    
    Get.offAllNamed(AppRoutes.BOOKING_SUCCESS);
  }
}
