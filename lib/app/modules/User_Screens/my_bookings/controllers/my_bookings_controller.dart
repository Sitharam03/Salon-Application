import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';

class MyBookingsController extends GetxController {
  // Mock Data mimicking the provided image
  final bookings = <Map<String, dynamic>>[
    {
      'id': '1',
      'salonName': 'Naturals Parlour',
      'location': 'Miyapur, Hyderabad',
      'rating': 4.2,
      'date': 'OCT 10',
      'time': '1:00 PM',
      'imageUrl': 'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=800&q=80',
      'status': 'Requested',
      'phone': '+91 98765 43210',
      'email': 'contact@naturalsparlour.com',
      'services': [
         {'name': 'Haircut', 'price': 15.0},
      ]
    },
    {
      'id': '2',
      'salonName': 'Naturals Parlour',
      'location': 'Miyapur, Hyderabad',
      'rating': 4.2,
      'date': 'OCT 10',
      'time': '1:00 PM',
      'imageUrl': 'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?auto=format&fit=crop&w=800&q=80',
      'status': 'Accepted',
      'phone': '+91 98765 43210',
      'email': 'contact@naturalsparlour.com',
      'services': [
         {'name': 'Haircut', 'price': 15.0},
         {'name': 'Beard Trim', 'price': 8.0},
      ]
    },
    {
      'id': '3',
      'salonName': 'Naturals Parlour',
      'location': 'Miyapur, Hyderabad',
      'rating': 4.2,
      'date': 'OCT 10',
      'time': '1:00 PM',
      'imageUrl': 'https://images.unsplash.com/photo-1562322140-8baeececf3df?auto=format&fit=crop&w=800&q=80',
      'status': 'Rejected',
      'phone': '+91 98765 43210',
      'email': 'contact@naturalsparlour.com',
      'services': [
         {'name': 'Haircut', 'price': 15.0},
      ]
    },
    {
      'id': '4',
      'salonName': 'Naturals Parlour',
      'location': 'Miyapur, Hyderabad',
      'rating': 4.5,
      'date': 'SEP 28',
      'time': '4:00 PM',
      'imageUrl': 'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=800&q=80',
      'status': 'Completed',
      'phone': '+91 98765 43210',
      'email': 'contact@naturalsparlour.com',
      'services': [
         {'name': 'Facial', 'price': 30.0},
         {'name': 'Hair Spa', 'price': 40.0},
      ]
    },
  ].obs;

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
}
