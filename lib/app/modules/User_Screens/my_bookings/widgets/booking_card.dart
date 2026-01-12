import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback? onReschedule;
  final VoidCallback? onRebook;
  final VoidCallback? onFeedback;

  const BookingCard({
    super.key,
    required this.booking,
    this.onReschedule,
    this.onRebook,
    this.onFeedback,
  });

  @override
  Widget build(BuildContext context) {
    final status = booking['status'] as String;
    Color statusColor;
    Color statusBgColor;

    switch (status.toLowerCase()) {
      case 'accepted':
        statusColor = const Color(0xFF10B981); // Green
        statusBgColor = const Color(0xFFD1FAE5);
        break;
      case 'rejected':
        statusColor = const Color(0xFFEF4444); // Red
        statusBgColor = const Color(0xFFFEE2E2);
        break;
      case 'completed':
        statusColor = const Color(0xFF3B82F6); // Blue
        statusBgColor = const Color(0xFFDBEAFE); // Light Blue
        break;
      default: // Requested or Pending
        statusColor = const Color(0xFF6B7280); // Grey
        statusBgColor = const Color(0xFFF3F4F6);
    }

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.BOOKING_DETAILS, arguments: booking);
      },
      child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  booking['imageUrl'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(width: 80, height: 80, color: Colors.grey[200]),
                ),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            booking['salonName'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking['location'],
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEB),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, size: 12, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                "${booking['rating']}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB45309),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.calendar_today, size: 12, color: Colors.grey[400]),
                        const SizedBox(width: 4),
                        Text(
                          "${booking['date']} • ${booking['time']}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Action Buttons
          if (status.toLowerCase() != 'requested') ...[
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF3F4F6)), // Thin separator
            const SizedBox(height: 16),
            Row(
              children: [
                 if (status.toLowerCase() == 'accepted')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onReschedule,
                      icon: const Icon(Icons.schedule, size: 16, color: Colors.white),
                      label: const Text('Reschedule'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F2937),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),

                if (status.toLowerCase() == 'rejected')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onRebook,
                      icon: const Icon(Icons.refresh, size: 16, color: Colors.black),
                      label: const Text('Re-book'),
                       style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF3F4F6),
                        foregroundColor: Colors.black,
                        elevation: 0,
                         shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),

                 if (status.toLowerCase() == 'completed')
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onFeedback,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                         shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Feedback', style: TextStyle(color: Colors.black)),
                    ),
                  ),
              ],
            ),
          ]
        ],
      ),
      ),
    );
  }
}
