import 'package:flutter/material.dart';

class BookingStatusTimeline extends StatelessWidget {
  final String status;
  final String date;
  final String time;

  const BookingStatusTimeline({
    super.key,
    required this.status,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    bool isConfirmed = ['accepted', 'completed'].contains(status.toLowerCase());
    bool isCompleted = status.toLowerCase() == 'completed';
    bool isRejected = status.toLowerCase() == 'rejected';

    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BOOKING STATUS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9CA3AF),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          
          // Step 1: Booking Placed
          _buildStep(
            title: 'Booking Placed',
            subtitle: '$date • $time', // Ideally real request time
            isActive: true,
            isLast: false,
          ),

          // Step 2: Confirmed / Rejected
          if (isRejected)
             _buildStep(
              title: 'Booking Rejected',
              subtitle: 'Salon could not accommodate request',
              isActive: true, // It happened
              isLast: true,
              isError: true,
            )
          else
            _buildStep(
              title: 'Confirmed by Salon',
              subtitle: isConfirmed ? '$date • $time' : 'Awaiting confirmation',
              isActive: isConfirmed,
              isLast: false,
            ),

          // Step 3: Service Completion
          if (!isRejected)
            _buildStep(
              title: 'Service Completion',
              subtitle: isCompleted ? 'Completed' : 'Pending',
              isActive: isCompleted,
              isLast: true,
            ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isLast,
    bool isError = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isError 
                    ? const Color(0xFFEF4444) 
                    : (isActive ? const Color(0xFF10B981) : const Color(0xFFE5E7EB)),
                shape: BoxShape.circle,
                border: isActive || isError ? null : Border.all(color: Colors.grey[300]!, width: 2),
              ),
              child: isActive || isError
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isActive ? const Color(0xFF10B981).withOpacity(0.3) : const Color(0xFFE5E7EB),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isError ? const Color(0xFFEF4444) : (isActive ? Colors.black : Colors.grey),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
