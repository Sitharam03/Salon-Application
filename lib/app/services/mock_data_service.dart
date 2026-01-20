import 'package:get/get.dart';
import 'package:salon/app/data/models/order_model.dart';

class MockDataService extends GetxService {
  // Singleton pattern is handled by Get.put/find, but we can also use static for easier access if preferred.
  // We'll stick to Get.find<MockDataService>()

  // --- Salons Data ---
  final salons = <Map<String, dynamic>>[
     {
      'name': 'Naturals Parlour',
      'location': 'Miyapur, Hyderabad',
      'rating': 4.2,
      'imageUrl': 'https://plus.unsplash.com/premium_photo-1661281350976-59b9514e5364?q=80&w=2969&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'lat': 17.5169,
      'lng': 78.3462,
      'distance': 0.0, 
      'categories': ['Haircut', 'Massage', 'Manicure'],
    },
    {
      'name': 'Green Trends',
      'location': 'Kondapur, Hyderabad',
      'rating': 4.5,
      'imageUrl': 'https://images.unsplash.com/photo-1560066984-12186d30b7aa?q=80&w=2696&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'lat': 17.4622,
      'lng': 78.3568,
      'distance': 0.0,
      'categories': ['Haircut', 'Makeup'],
    },
    {
      'name': 'Lakme Salon',
      'location': 'Gachibowli, Hyderabad',
      'rating': 4.1,
      'imageUrl': 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'lat': 17.4401,
      'lng': 78.3489,
      'distance': 0.0,
      'categories': ['Makeup', 'Manicure'],
    },
     {
      'name': 'Toni & Guy',
      'location': 'Jubilee Hills, Hyderabad',
      'rating': 4.8,
      'imageUrl': 'https://images.unsplash.com/photo-1521590832169-d7fcbe2af40f?q=80&w=2669&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'lat': 17.4312,
      'lng': 78.4079,
      'distance': 0.0,
      'categories': ['Haircut', 'Massage', 'Manicure', 'Makeup'],
    },
  ].obs;

  void addSalon(Map<String, dynamic> salon) {
    salons.add(salon);
  }

  // --- Bookings Data ---
  // Using OrderModel to keep consistency with Admin side
  final bookings = <OrderModel>[
    OrderModel(
      id: '1',
      customerName: 'Durga Prasad',
      customerPhone: '6123654789',
      customerImage: 'assets/profile_avatar.png', 
      status: OrderStatus.pending,
      date: DateTime.now(),
      time: '10:00 PM',
      services: ['Beard Shaving', 'Hair Cut'],
    ),
    OrderModel(
      id: '2',
      customerName: 'Priya Sharma',
      customerPhone: '9876543210',
      customerImage: 'assets/profile_avatar.png', 
      status: OrderStatus.accepted,
      date: DateTime.now(),
      time: '11:30 AM',
      services: ['Facial', 'Manicure'],
    ),
    OrderModel(
      id: '3',
      customerName: 'Arun Kumar',
      customerPhone: '6123654789',
      customerImage: 'assets/profile_avatar.png', 
      status: OrderStatus.rejected,
      date: DateTime.now().subtract(const Duration(days: 1)),
      time: '10:00 PM',
      services: ['Hair Cut'],
    ),
  ].obs;

  void addBooking(OrderModel booking) {
    bookings.insert(0, booking); // Add to top
  }

  void updateBookingStatus(String id, OrderStatus status) {
    final index = bookings.indexWhere((element) => element.id == id);
    if (index != -1) {
      final old = bookings[index];
      bookings[index] = OrderModel(
        id: old.id,
        customerName: old.customerName,
        customerPhone: old.customerPhone,
        customerImage: old.customerImage,
        status: status,
        date: old.date,
        time: old.time,
        services: old.services,
      );
    }
  }
}
