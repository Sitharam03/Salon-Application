import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemoveFavoriteDialog extends StatelessWidget {
  final String salonName;
  final VoidCallback onRemove;
  final VoidCallback onCancel;

  const RemoveFavoriteDialog({
    super.key,
    required this.salonName,
    required this.onRemove,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F0), // Light red background
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite, // Using favorite but will style it as broken via design or just red heart. 
                // Since Material doesn't have a perfect "heart crack" that matches the image exactly, 
                // we can use heart_broken if available in newer flutter, or simulate.
                // Image shows a heart with a crack.
                color: Color(0xFFE22424),
                size: 32,
              ),
            ),
            // Or better, use Icons.heart_broken_sharp if available, or just heart_broken
            // Trying Icons.heart_broken which is available in newer Flutter SDKs.
            
            const SizedBox(height: 16),
            
            // Title
            const Text(
              'Remove from Favourites?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Subtitle
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'Are you sure you want to remove '),
                  TextSpan(
                    text: salonName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const TextSpan(text: ' from your favourites list?'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Remove Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRemove,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE22424),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Remove',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1F2937),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
