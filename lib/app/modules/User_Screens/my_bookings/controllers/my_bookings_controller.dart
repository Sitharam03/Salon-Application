import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:salon/app/services/mock_data_service.dart';
import 'package:salon/app/data/models/order_model.dart';

class MyBookingsController extends GetxController {
  // Mock Data mimicking the provided image
  // Data Service
  MockDataService get dataService => Get.find<MockDataService>();

  // Mock Data mimicking the provided image (Proxied from Shared Data)
  List<Map<String, dynamic>> get bookings {
    return dataService.bookings.map((order) => {
      'id': order.id,
      'salonName': 'Naturals Parlour', // Mock Name as OrderModel doesn't have salon name yet
      'location': 'Miyapur, Hyderabad',
      'rating': 4.2,
      'date': order.date.toString().split(' ')[0], // Simple date
      'time': order.time,
      'imageUrl': 'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=800&q=80',
      'status': _mapStatus(order.status),
      'phone': order.customerPhone,
      'email': 'contact@naturalsparlour.com',
      'services': order.services.map((s) => {'name': s, 'price': 0.0}).toList(), // Mock price
    }).toList();
  }

  String _mapStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return 'Requested';
      case OrderStatus.accepted: return 'Accepted';
      case OrderStatus.rejected: return 'Rejected';
    }
  }

  Map<String, dynamic>? _getBookingById(String id) {
    return bookings.firstWhereOrNull((element) => element['id'] == id);
  }

  void onReschedule(String id) {
    final booking = _getBookingById(id);
    if (booking == null) return;
    
    DateTime? initialDate;
    try {
      final dateStr = booking['date'] as String; // "OCT 10"
      final parts = dateStr.split(' ');
      final months = {'JAN': 1, 'FEB': 2, 'MAR': 3, 'APR': 4, 'MAY': 5, 'JUN': 6, 'JUL': 7, 'AUG': 8, 'SEP': 9, 'OCT': 10, 'NOV': 11, 'DEC': 12};
      if (parts.length == 2 && months.containsKey(parts[0].toUpperCase())) {
         final month = months[parts[0].toUpperCase()]!;
         final day = int.parse(parts[1]);
         final now = DateTime.now();
         initialDate = DateTime(now.year, month, day);
      }
    } catch(e) {
      // fallback
    }

    Get.toNamed(AppRoutes.BOOKING_SLOT, arguments: {
      ...booking,
      'rescheduleDate': initialDate ?? DateTime.now(),
    });
  }

  void onRebook(String id) {
    final booking = _getBookingById(id);
    if (booking != null) {
      Get.toNamed(AppRoutes.SALON_DETAILS, arguments: booking);
    }
  }

  void onFeedback(String id) {
    final booking = _getBookingById(id);
    if (booking != null) {
      Get.toNamed(AppRoutes.FEEDBACK, arguments: booking);
    }
  }

  // Search State
  final isSearchActive = false.obs;
  final searchQuery = ''.obs;

  List<Map<String, dynamic>> get filteredBookings {
    if (searchQuery.isEmpty) {
      return bookings;
    }
    return bookings.where((booking) {
      final nameMatches = booking['salonName'].toString().toLowerCase().contains(searchQuery.value.toLowerCase());
      final serviceMatches = (booking['services'] as List).any((service) => 
          service['name'].toString().toLowerCase().contains(searchQuery.value.toLowerCase()));
      return nameMatches || serviceMatches;
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
}
