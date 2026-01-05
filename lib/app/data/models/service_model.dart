class ServiceModel {
  String? id;
  String name;
  String category;
  String gender; // 'Men' or 'Women'
  String duration; // e.g. "45 Mins"
  double price;
  String description;

  ServiceModel({
    this.id,
    required this.name,
    required this.category,
    required this.gender,
    required this.duration,
    required this.price,
    this.description = '',
  });
}
