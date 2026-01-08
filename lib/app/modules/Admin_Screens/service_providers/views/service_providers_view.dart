import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';
import '../controllers/service_providers_controller.dart';
import 'dart:io';

class ServiceProvidersView extends GetView<ServiceProvidersController> {
  const ServiceProvidersView({super.key});

  @override
  Widget build(BuildContext context) {
     // Ensure controller is initialized
    if (!Get.isRegistered<ServiceProvidersController>()) {
      Get.lazyPut(() => ServiceProvidersController());
    }
  
    return Column(
      children: [
        Expanded(
          child: Obx(
            () => ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: controller.providers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final provider = controller.providers[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Image
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: (provider.imagePath != null && provider.imagePath!.isNotEmpty)
                          ? (provider.imagePath!.startsWith('assets') 
                              ? AssetImage(provider.imagePath!) as ImageProvider
                              : FileImage(File(provider.imagePath!)))
                          : null,
                        child: (provider.imagePath == null || provider.imagePath!.isEmpty)
                            ? const Icon(Icons.person, color: Colors.grey, size: 30)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E232C),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.phone, provider.contact),
                            const SizedBox(height: 4),
                            _buildInfoRow(Icons.email, provider.email),
                             const SizedBox(height: 4),
                            _buildInfoRow(Icons.location_on, provider.address),
                          ],
                        ),
                      ),
                      // Edit Icon
                      InkWell(
                        onTap: () {
                          controller.prepareEdit(provider);
                        },
                        child: const Icon(Icons.edit, size: 20, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
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
                 controller.prepareAdd();
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
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Add Service Provider',
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
