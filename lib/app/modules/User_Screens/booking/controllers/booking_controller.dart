import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:salon/app/services/mock_data_service.dart';
import 'package:salon/app/data/models/order_model.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:intl/intl.dart';

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
  final selectedProvider = 'Any Provider'.obs;

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

  final providers = ['Any Provider', 'Vignesh', 'Prasad', 'Ram', 'Pramod'];

  // Dynamic Time Slots
  final timeSlots = <String>[].obs;

  void generateTimeSlots() {
    timeSlots.clear();
    
    if (selectedDate.value == null) return;

    final date = selectedDate.value!;
    final dayCode = DateFormat('E').format(date); // Mon, Tue, etc.
    final timings = salonData['timings'] as Map<String, dynamic>?;

    if (timings == null || !timings.containsKey(dayCode)) {
      // Fallback or default timings if none provided
       _generateDefaultSlots();
       return;
    }

    final dayTiming = timings[dayCode];
    if (dayTiming == null || dayTiming['isClosed'] == true) {
      // Shop is closed today
      return; 
    }

    final startStr = dayTiming['start'] as String?;
    final endStr = dayTiming['end'] as String?;

    if (startStr != null && endStr != null) {
      try {
        final format = DateFormat("hh:mm a");
        final startTime = format.parse(startStr);
        final endTime = format.parse(endStr);
        
        // Generate hourly slots
        var currentSlot = DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute);
        // End time needs to be on the same day for comparison logic or handle overnight separately (assuming same day for now)
        var endSlot = DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute);
        
        // Logic to generate slots every hour
        while (currentSlot.isBefore(endSlot)) {
           timeSlots.add(DateFormat("hh:mm a").format(currentSlot));
           currentSlot = currentSlot.add(const Duration(hours: 1));
        }
      } catch (e) {
        print("Error parsing start/end time: $e");
        _generateDefaultSlots();
      }
    } else {
       _generateDefaultSlots();
    }
  }

  void _generateDefaultSlots() {
    timeSlots.addAll([
      '09:00 AM', '10:00 AM', '11:00 AM',
      '12:00 PM', '02:00 PM', '03:00 PM',
      '04:00 PM', '05:00 PM', '06:00 PM',
      '07:00 PM', '08:00 PM'
    ]);
  }

  @override
  void onInit() {
    super.onInit();
    
    // Default to Today
    selectedDate.value = DateTime.now();
    
    // Listen to date changes to reset time and regenerate slots
    ever(selectedDate, (_) {
       generateTimeSlots(); // New logic
       
       // If user changes date, let's try to keep selected time if valid, or select new default
       if (!isTimeSlotAvailable(selectedTime.value)) {
          selectedTime.value = ''; // Reset if invalid
          _selectDefaultTime();
       }
    });

    if (Get.arguments != null) {
      if (Get.arguments is Map<String, dynamic>) {
         salonData.value = Get.arguments;
         
         // Regenerate after data load just in case (though listener might fire if date was set)
         generateTimeSlots();

         if (Get.arguments['rescheduleDate'] != null) {
           try {
             if (Get.arguments['rescheduleDate'] is DateTime) {
                selectedDate.value = Get.arguments['rescheduleDate'];
             }
           } catch (e) {
             print("Error parsing date: $e");
           }
         }
      }
    }
    
    // Initial generation (if not covered by arguments/listener)
    if (timeSlots.isEmpty) {
      generateTimeSlots();
      _selectDefaultTime(); 
    }
    
    // Auto-scroll logic (Infinite)
    const initialPage = 1000;
    pageController = PageController(initialPage: initialPage);
    activePageIndex.value = initialPage; // Initialize observable

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (pageController.hasClients) {
        final nextPage = (pageController.page ?? initialPage.toDouble()).round() + 1;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear, 
        );
      }
    });
  }

  void _selectDefaultTime() {
    // Find first available slot
    for (var slot in timeSlots) {
      if (isTimeSlotAvailable(slot)) {
        selectedTime.value = slot;
        return; 
      }
    }
    // If no slots available today (late night), maybe clear selection
    if (selectedTime.isEmpty && timeSlots.isNotEmpty) {
       // Optional: could default to first one anyway if we want strict behavior, currently empty
    }
  }

  bool isTimeSlotAvailable(String timeSlot) {
    if (timeSlot.isEmpty) return false;
    if (selectedDate.value == null) return true;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(selectedDate.value!.year, selectedDate.value!.month, selectedDate.value!.day);

    // If selected date is in the future, all slots are available
    if (selected.isAfter(today)) return true;
    
    // If selected date is in the past (shouldn't happen with UI), unavailable
    if (selected.isBefore(today)) return false;

    // If selected date is Today, check time
    try {
      // Parse "06:00 AM" to Hour/Minute
      final format = DateFormat("hh:mm a"); 
      // Note: DateFormat parses to 1970-01-01. We need to combine with Today.
      final parsedTime = format.parse(timeSlot);
      
      final slotDateTime = DateTime(
        now.year, 
        now.month, 
        now.day, 
        parsedTime.hour, 
        parsedTime.minute
      );

      // Allow if slot is after now (or maybe give a buffer?)
      return slotDateTime.isAfter(now);
    } catch (e) {
      print("Error parsing time slot: $e");
      return true; // Fallback
    }
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
      serviceProviderName: selectedProvider.value,
      serviceProviderRole: selectedProvider.value == 'Any Provider' ? 'Salon Team' : 'Senior Stylist',
      serviceProviderImage: selectedProvider.value == 'Any Provider' 
          ? 'https://cdn-icons-png.flaticon.com/512/3237/3237472.png' // Generic Avatar 
          : 'https://i.pravatar.cc/150?u=${selectedProvider.value}', // Mock image based on name
    );

    Get.find<MockDataService>().addBooking(newBooking);

    // Send Notification to Admin (Simulated by User notification for demo, or separate channel)
    // In real app, this triggers FCM to Admin.
    
    Get.offAllNamed(AppRoutes.BOOKING_SUCCESS);
  }
}
