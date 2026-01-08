import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/service_providers_controller.dart';
import 'dart:io';

class AddServiceProviderView extends GetView<ServiceProvidersController> {
  const AddServiceProviderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light grey background
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isEditing.value ? 'Edit Service Provider' : 'Add Service Providers',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E232C),
          ),
        )),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
         actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
           IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Upload
                  Center(
                    child: Stack(
                      children: [
                        Obx(() {
                          final image = controller.selectedImage.value;
                          return Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                              image: image != null
                                  ? DecorationImage(
                                      image: image.path.contains('assets')
                                        ? AssetImage(image.path) as ImageProvider
                                        : FileImage(File(image.path)),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: image == null
                                ? const Icon(Icons.person, size: 60, color: Colors.grey)
                                : null,
                          );
                        }),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: controller.pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE22424),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, size: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                   const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Upload Photo',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Name Field
                  const Text(
                    'Service Provider Name',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF1E232C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6), // Slightly darker grey
                      hintText: 'Enter Your Name',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Contact Field
                  const Text(
                    'Contact',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF1E232C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.contactController,
                     keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      hintText: 'Enter Your Contact',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.phone_outlined, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                   const SizedBox(height: 20),

                  // Email Field
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF1E232C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.emailController,
                     keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      hintText: 'Enter Your Email Address',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                   const SizedBox(height: 20),

                  // Address Field
                  const Text(
                    'Full Address',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF1E232C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.addressController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      hintText: 'Enter Full Address',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 48), // Align icon to top
                        child: Icon(Icons.location_on_outlined, color: Colors.grey),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ],
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
                 controller.saveProvider();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE22424), // Red/Coral color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Icon(
                    controller.isEditing.value ? Icons.check : Icons.add,
                    color: Colors.white
                  )),
                  SizedBox(width: 8),
                  Obx(() => Text(
                    controller.isEditing.value ? 'Update' : 'Save',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }
}
