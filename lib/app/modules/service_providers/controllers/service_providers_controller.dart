import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:salon/app/data/models/service_provider_model.dart';

class ServiceProvidersController extends GetxController {
  final RxList<ServiceProviderModel> providers = <ServiceProviderModel>[
    ServiceProviderModel(
      id: '1',
      name: 'Durga Prasad',
      contact: '6123654789',
      email: 'gdurgaprasad065@gmail.com',
      address: 'Miyapur, Hyderabad',
      imagePath: 'assets/profile_avatar.png', // Placeholder
    ),
    ServiceProviderModel(
      id: '2',
      name: 'Vignesh Kumar',
      contact: '6123654789',
      email: 'vigneshkumar@gmail.com',
      address: 'Miyapur, Hyderabad',
      imagePath: 'assets/profile_avatar.png', // Placeholder
    ),
    ServiceProviderModel(
      id: '3',
      name: 'Anita Roy',
      contact: '6123654789',
      email: 'anitaroy@gmail.com',
      address: 'Madhapur, Hyderabad',
      imagePath: 'assets/profile_avatar.png', // Placeholder
    ),
     ServiceProviderModel(
      id: '4',
      name: 'Raj Malhotra',
      contact: '9876543210',
      email: 'raj.malhotra@salon.com',
      address: 'Gachibowli, Hyderabad',
      imagePath: 'assets/profile_avatar.png', // Placeholder
    ),
  ].obs;

  final RxBool isEditing = false.obs;
  String? editingId;

  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final ImagePicker _picker = ImagePicker();

  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = image;
    }
  }

  void prepareEdit(ServiceProviderModel provider) {
    isEditing.value = true;
    editingId = provider.id;
    nameController.text = provider.name;
    contactController.text = provider.contact;
    emailController.text = provider.email;
    addressController.text = provider.address;
    if (provider.imagePath != null) {
      selectedImage.value = XFile(provider.imagePath!);
    } else {
      selectedImage.value = null;
    }
    Get.toNamed('/add-service-provider');
  }

  void prepareAdd() {
    _clearForm();
    Get.toNamed('/add-service-provider');
  }

  void saveProvider() {
    if (nameController.text.isEmpty || contactController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    if (isEditing.value && editingId != null) {
      // Update existing
      int index = providers.indexWhere((p) => p.id == editingId);
      if (index != -1) {
        providers[index] = ServiceProviderModel(
          id: editingId,
          name: nameController.text,
          contact: contactController.text,
          email: emailController.text,
          address: addressController.text,
          imagePath: selectedImage.value?.path,
        );
        providers.refresh(); // Force update UI
        Get.back(); // Go back to list
        Get.snackbar(
          'Success', 
          'Service Provider updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
        );
      }
    } else {
      // Add new
      final newProvider = ServiceProviderModel(
        id: DateTime.now().toString(),
        name: nameController.text,
        contact: contactController.text,
        email: emailController.text,
        address: addressController.text,
        imagePath: selectedImage.value?.path,
      );
      providers.add(newProvider);
      Get.back(); // Go back to list
      Get.snackbar(
        'Success', 
        'Service Provider added successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
      );
    }
    _clearForm();
  }

  void _clearForm() {
    isEditing.value = false;
    editingId = null;
    nameController.clear();
    contactController.clear();
    emailController.clear();
    addressController.clear();
    selectedImage.value = null;
  }
}
