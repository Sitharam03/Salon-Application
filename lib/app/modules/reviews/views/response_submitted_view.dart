import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/admin_dashboard/controllers/admin_dashboard_controller.dart';

class ResponseSubmittedView extends StatelessWidget {
  const ResponseSubmittedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Response Submitted',
          style: TextStyle(
            color: Color(0xFF1E232C),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E232C)),
          onPressed: () {
            // Go back two steps to Shop Reviews list, skipping Respond view
            Get.close(2); 
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFE22424).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE22424).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.check_circle, size: 40, color: Color(0xFFE22424)),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'Response Submitted!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E232C),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Your response to the review is now live and the customer has been notified.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 64),
            
            // Buttons
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Get.close(2); // Back to reviews list
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE22424),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back to Reviews',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextButton(
              onPressed: () {
                // Return to dashboard
                 try {
                   final dashboardController = Get.find<AdminDashboardController>();
                   dashboardController.changeTabIndex(0);
                   Get.until((route) => route.settings.name == '/admin-dashboard');
                 } catch (e) {
                   Get.offAllNamed('/admin-dashboard');
                 }
              },
              child: Text(
                'Return to Dashboard',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
