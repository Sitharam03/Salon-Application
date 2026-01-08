import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/widgets/gender_selection_tab.dart';
import '../controllers/services_controller.dart';

class AddServiceView extends GetView<ServicesController> {
  const AddServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    // Find controller if not already in context, just in case of direct navigation without binding in route
    final ServicesController controller = Get.isRegistered<ServicesController>() 
        ? Get.find<ServicesController>() 
        : Get.put(ServicesController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add Services',
          style: TextStyle(
            color: Color(0xFF1E232C),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E232C)),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Color(0xFF1E232C)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search, color: Color(0xFF1E232C)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Color(0xFF1E232C)), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gender Selection
                Obx(() => GenderSelectionTab(
                  selectedGender: controller.selectedGender.value,
                  onGenderSelected: controller.setGender,
                )),
                const SizedBox(height: 24),

                // Category
                const Text(
                  'Service Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E232C),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Obx(() => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedCategory.value,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: controller.categories.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) controller.selectedCategory.value = newValue;
                      },
                    ),
                  )),
                ),
                
                const SizedBox(height: 24),

                // Service Name
                const Text(
                  'Service Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E232C),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.serviceNameController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Buzz Cut',
                    filled: true,
                    fillColor: const Color(0xFFF7F8F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),

                const SizedBox(height: 24),

                // Duration
                const Text(
                  'Duration',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E232C),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeInput(controller.hrsController, '00', 'Hrs'),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(':', style: TextStyle(fontSize: 20, color: Colors.grey)),
                    ),
                    Expanded(
                      child: _buildTimeInput(controller.minsController, '00', 'Mins'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Price
                const Text(
                  'Price',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E232C),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.attach_money, size: 20),
                    hintText: '0.00',
                    filled: true,
                    fillColor: const Color(0xFFF7F8F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                
                const SizedBox(height: 80),
              ],
            ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: controller.saveService,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE22424),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 4,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Icon(Icons.check_circle, color: Colors.white, size: 20),
                 SizedBox(width: 8),
                 Text(
                  'Save Service',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildTimeInput(TextEditingController controller, String hint, String suffix) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: const Color(0xFFF7F8F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(suffix, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
