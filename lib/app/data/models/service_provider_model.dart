class ServiceProviderModel {
  String? id;
  String name;
  String contact;
  String email;
  String address;
  String? imagePath;

  ServiceProviderModel({
    this.id,
    required this.name,
    required this.contact,
    required this.email,
    required this.address,
    this.imagePath,
  });
}
