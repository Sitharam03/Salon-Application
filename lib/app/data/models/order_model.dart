enum OrderStatus { pending, accepted, rejected }

class OrderModel {
  String id;
  String customerName;
  String customerPhone;
  String? customerImage;
  OrderStatus status;
  DateTime date; // Appointment Date
  String time; // Appointment Time
  List<String> services;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    this.customerImage,
    required this.status,
    required this.date,
    required this.time,
    required this.services,
    this.serviceProviderName = "Any Stylist", // Default
    this.serviceProviderRole = "Stylist", // Default
    this.serviceProviderImage,
  });
  
  String serviceProviderName;
  String serviceProviderRole;
  String? serviceProviderImage;
}
