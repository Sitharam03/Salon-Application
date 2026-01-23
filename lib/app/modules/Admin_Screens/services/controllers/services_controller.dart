import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:salon/app/data/models/service_model.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:salon/app/services/mock_data_service.dart';

class ServicesController extends GetxController {
  // Observables for add service form
  final selectedGender = 'Men'.obs; // For Add Service
  final viewGender = 'Men'.obs; // For Service List View
  final selectedCategory = 'Hair'.obs;
  
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController hrsController = TextEditingController();
  final TextEditingController minsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final _allCategories = ['Hair', 'Beard', 'Facial & Spa', 'Skin Care', 'Massage'];

  // Categories for the Service List View (depends on viewGender)
  List<String> get categories {
    final allCats = Get.find<MockDataService>().categories;
    if (viewGender.value == 'Women') {
      return allCats.where((c) => c != 'Beard').toList();
    }
    return allCats;
  }

  // Categories for the Add Service Form (depends on selectedGender)
  List<String> get formCategories {
    final allCats = Get.find<MockDataService>().categories;
    if (selectedGender.value == 'Women') {
      return allCats.where((c) => c != 'Beard').toList();
    }
    return allCats;
  }

  // Dynamic Data
  List<ServiceModel> get services => Get.find<MockDataService>().services;
  final expandedCategories = <String, bool>{}.obs;

  // Edit Mode
  final isEditing = false.obs;
  String? editingServiceId;

  @override
  void onInit() {
    super.onInit();
    
    // Default expand 'Hair'
    expandedCategories['Hair'] = true;
  }

  @override
  void onClose() {
    serviceNameController.dispose();
    hrsController.dispose();
    minsController.dispose();
    priceController.dispose();
    super.onClose();
  }

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  void setViewGender(String gender) {
    viewGender.value = gender;
  }

  void toggleCategory(String category) {
    bool isCurrentlyExpanded = expandedCategories[category] ?? false;
    expandedCategories[category] = !isCurrentlyExpanded;
  }

  bool isCategoryExpanded(String category) {
    return expandedCategories[category] ?? false;
  }

  List<ServiceModel> getServicesByCategory(String category) {
    return services.where((s) => s.category == category && s.gender == viewGender.value).toList();
  }
  
  void clearForm() {
    serviceNameController.clear();
    hrsController.clear();
    minsController.clear();
    priceController.clear();
    // Default to first valid category for current gender
    selectedCategory.value = formCategories.first;
    // selectedGender.value = 'Men'; // Keep previous gender or reset? Keeping for better UX.
    isEditing.value = false;
    editingServiceId = null;
  }

  void prepareEdit(ServiceModel service) {
    isEditing.value = true;
    editingServiceId = service.id;
    
    // Populate form
    serviceNameController.text = service.name;
    selectedCategory.value = service.category;
    selectedGender.value = service.gender;
    priceController.text = service.price.toString();
    
    // Parse duration back to hrs/mins logic (simplified for now)
    // Assuming format "X Mins" or "X Hrs Y Mins"
    // Just clearing for demo complexity reduction or simple parsing:
    if (service.duration.contains('Mins')) {
       final mins = service.duration.split(' ')[0];
       minsController.text = mins;
    }
    
    Get.toNamed(AppRoutes.ADD_SERVICE);
  }
  
  void startAddService() {
    clearForm();
    selectedGender.value = viewGender.value; // Sync with current view
    Get.toNamed(AppRoutes.ADD_SERVICE);
  }

  void saveService() {
    if (serviceNameController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    String duration = "${minsController.text.isEmpty ? '00' : minsController.text} Mins";
    if (hrsController.text.isNotEmpty && hrsController.text != '00') {
      duration = "${hrsController.text} Hrs $duration";
    }

      // Update existing
    final newService = ServiceModel(
      id: isEditing.value && editingServiceId != null ? editingServiceId! : DateTime.now().millisecondsSinceEpoch.toString(),
      name: serviceNameController.text,
      category: selectedCategory.value,
      gender: selectedGender.value,
      duration: duration,
      price: double.tryParse(priceController.text) ?? 0.0,
      description: '', // Add field if needed
    );

    if (isEditing.value) {
      Get.find<MockDataService>().updateService(newService);
    } else {
      Get.find<MockDataService>().addService(newService);
    }
    
    // Manual refresh
    Get.find<MockDataService>().services.refresh();
    
    // Ensure the category added to is expanded so user sees it
    expandedCategories[selectedCategory.value] = true;
    
    Get.back(); // Go back after saving
    Get.snackbar('Success', isEditing.value ? 'Service updated' : 'Service added');
    clearForm();
  }
}
