import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:salon/app/data/models/service_model.dart';
import 'package:salon/app/routes/app_routes.dart';

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
    if (viewGender.value == 'Women') {
      return _allCategories.where((c) => c != 'Beard').toList();
    }
    return _allCategories;
  }

  // Categories for the Add Service Form (depends on selectedGender)
  List<String> get formCategories {
    if (selectedGender.value == 'Women') {
      return _allCategories.where((c) => c != 'Beard').toList();
    }
    return _allCategories;
  }

  // Dynamic Data
  final services = <ServiceModel>[].obs;
  final expandedCategories = <String, bool>{}.obs;

  // Edit Mode
  final isEditing = false.obs;
  String? editingServiceId;

  @override
  void onInit() {
    super.onInit();
    // Populate with some dummy data for initial view
    services.addAll([
      ServiceModel(id: '1', name: 'Hair Cut', category: 'Hair', gender: 'Men', duration: '45 Mins', price: 25.0, description: 'Standard haircut'),
      ServiceModel(id: '2', name: 'Hair Coloring', category: 'Hair', gender: 'Men', duration: '90 Mins', price: 60.0),
      ServiceModel(id: '3', name: 'Beard Trim', category: 'Beard', gender: 'Men', duration: '30 Mins', price: 15.0),
    ]);
    
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

    if (isEditing.value && editingServiceId != null) {
      // Update existing
      int index = services.indexWhere((s) => s.id == editingServiceId);
      if (index != -1) {
        services[index] = ServiceModel(
          id: editingServiceId,
          name: serviceNameController.text,
          category: selectedCategory.value,
          gender: selectedGender.value,
          duration: duration,
          price: double.tryParse(priceController.text) ?? 0.0,
        );
        services.refresh(); // Trigger UI update for list
      }
    } else {
      // Add new
      services.add(ServiceModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: serviceNameController.text,
        category: selectedCategory.value,
        gender: selectedGender.value,
        duration: duration,
        price: double.tryParse(priceController.text) ?? 0.0,
      ));
    }
    
    // Ensure the category added to is expanded so user sees it
    expandedCategories[selectedCategory.value] = true;
    
    Get.back(); // Go back after saving
    Get.snackbar('Success', isEditing.value ? 'Service updated' : 'Service added');
    clearForm();
  }
}
