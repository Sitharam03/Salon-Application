import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/shop_details/controllers/shop_details_controller.dart';
import 'package:salon/app/modules/Admin_Screens/shop_details/widgets/shop_timings_widget.dart';

class ShopTimingsView extends GetView<ShopDetailsController> {
  const ShopTimingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Shop Timings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Shop Timings Widget
                      Expanded(
                        child: ShopTimingsWidget(
                          controller: controller,
                          isEditable: true,
                          onApplyToAllDays: controller.applyToAllDays,
                        ),
                      ),

                      // Save Button
                      Padding(
                        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                        child: GetBuilder<ShopDetailsController>(
                          builder: (_) => Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : _saveShopTimings,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE22424),
                                  disabledBackgroundColor: Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Save Changes',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }



  void _saveShopTimings() {
    controller.isLoading.value = true;

    // Mock API call
    Future.delayed(const Duration(seconds: 2), () {
      controller.isLoading.value = false;

      Get.back();
      Get.snackbar(
        'Success',
        'Shop timings updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    });
  }
}
