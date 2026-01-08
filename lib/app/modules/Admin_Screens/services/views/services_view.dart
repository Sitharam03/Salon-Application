import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:salon/app/widgets/gender_selection_tab.dart';
import 'package:salon/app/data/models/service_model.dart';
import '../controllers/services_controller.dart';
import 'add_service_view.dart';

class ServicesView extends GetView<ServicesController> {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Using a Column to position the button at the bottom of the view area
    // The parent Dashboard provides the Scaffold and SafeArea
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Removed the extra "Services" header text since it is now in the App Bar as requested
                   const SizedBox(height: 10),
                  // Gender Toggle
                  Obx(() => GenderSelectionTab(
                    selectedGender: controller.viewGender.value,
                    onGenderSelected: controller.setViewGender,
                  )),
                  const SizedBox(height: 20),

                  const Text(
                    'My Services',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E232C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your offerings and durations',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Dynamic Service Categories
                  Obx(() => Column(
                    children: controller.categories.map((category) {
                       return Padding(
                         padding: const EdgeInsets.only(bottom: 16.0),
                         child: _buildServiceCategoryCard(category),
                       );
                    }).toList(),
                  )),
                  
                  const SizedBox(height: 20), 
                ],
              ),
            ),
          ),
        ),
        // Bottom Button
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA), // Match background or white
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
              onPressed: () {
                 controller.startAddService();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE22424), // Red/Coral color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Add Services',
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
      ],
    );
  }

  Widget _buildServiceCategoryCard(String title) {
    IconData getIcon(String category) {
      switch(category) {
        case 'Hair': return Icons.cut;
        case 'Beard': return Icons.face;
        case 'Facial & Spa': return Icons.spa;
        case 'Skin Care': return Icons.cleaning_services;
        case 'Massage': return Icons.back_hand;
        default: return Icons.category;
      }
    }

    return Obx(() {
      bool expanded = controller.isCategoryExpanded(title);
      List<ServiceModel> categoryServices = controller.getServicesByCategory(title);

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => controller.toggleCategory(title),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: expanded ? Radius.zero : const Radius.circular(16),
                bottomRight: expanded ? Radius.zero : const Radius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: title == 'Hair' ? const Color(0xFFFFEBEB) : (title == 'Beard' ? const Color(0xFFFFF4E3) : const Color(0xFFE8F1FF)),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                         getIcon(title), 
                         color: title == 'Hair' ? const Color(0xFFE22424) : (title == 'Beard' ? Colors.orange : Colors.blue),
                         size: 20
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E232C),
                      ),
                    ),
                    const Spacer(),
                     Icon(
                      expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, // Fixed: up when expanded
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            if (expanded) ...[
               if (categoryServices.isEmpty)
                 const Padding(
                   padding: EdgeInsets.all(16.0),
                   child: Text("No services added yet.", style: TextStyle(color: Colors.grey)),
                 )
               else
                 Column(
                   children: categoryServices.asMap().entries.map((entry) {
                     int idx = entry.key;
                     ServiceModel service = entry.value;
                     return Column(
                       children: [
                         const Divider(height: 1),
                         _buildServiceItem(service),
                       ],
                     );
                   }).toList(),
                 ),
            ]
          ],
        ),
      );
    });
  }

  Widget _buildServiceItem(ServiceModel service) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E232C),
                      ),
                    ),
                     Text(
                      "\$${service.price.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E232C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      service.duration,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                if (service.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () {
              controller.prepareEdit(service);
            },
            child: const Padding(
              padding: EdgeInsets.only(top: 2.0, left: 8, bottom: 8),
              child: Icon(Icons.edit, size: 20, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
