import 'package:flutter/material.dart';
import 'package:salon/app/data/models/order_model.dart';
import 'dart:io';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const OrderCard({
    super.key,
    required this.order,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    bool isPending = order.status == OrderStatus.pending;
    
    // Status Logic
    Color statusColor;
    String statusText;
    IconData? statusIcon;
    
    switch (order.status) {
      case OrderStatus.accepted:
        statusColor = const Color(0xFF00C569); // Green
        statusText = 'ACCEPTED';
        statusIcon = Icons.check_circle;
        break;
      case OrderStatus.rejected:
         statusColor = const Color(0xFFF75555); // Red
        statusText = 'REJECTED';
        statusIcon = Icons.cancel;
        break;
      case OrderStatus.pending:
      default:
         statusColor = const Color(0xFFFFC107); // Amber (for chip)
        statusText = 'PENDING';
        statusIcon = null;
    }

    // Border line color (Left side)
    Color borderColor = order.status == OrderStatus.pending 
        ? const Color(0xFFE22424) 
        : const Color(0xFF00C569); 

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Colored Bar
              if (order.status == OrderStatus.pending || order.status == OrderStatus.accepted)
              Container(
                width: 6,
                color: order.status == OrderStatus.pending ? const Color(0xFFE22424) : const Color(0xFF00C569),
              ),
              
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Header: Image + Name + Phone + Status Chip
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: order.customerImage != null 
                                  ? AssetImage(order.customerImage!) as ImageProvider
                                  : null,
                                child: order.customerImage == null 
                                  ? const Icon(Icons.person, color: Colors.grey)
                                  : null,
                              ),
                              if (order.status == OrderStatus.pending)
                              const Positioned(
                                right: 0,
                                bottom: 0,
                                child: Icon(Icons.star, color: Colors.amber, size: 16),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.customerName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E232C),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      order.customerPhone,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (order.status == OrderStatus.pending)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEBEB), // Light Red/Pink
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'PENDING',
                              style: const TextStyle(
                                color: Color(0xFFE22424),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Time Info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.access_time, size: 20, color: Colors.grey),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_formatDate(order.date)} ${order.time}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1E232C),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                order.status == OrderStatus.pending ? "Timing Requested" : "Appointment Time",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Services Info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.cut_outlined, size: 20, color: Colors.grey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.services.join(", "),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF1E232C),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "Services",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      
                      // Action Buttons for Pending
                      if (isPending)
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: onAccept,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00C569), // Green
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check, size: 18, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Accept',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: onReject,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFE22424),
                                  side: const BorderSide(color: Color(0xFFE22424)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.close, size: 18, color: Color(0xFFE22424)),
                                    SizedBox(width: 8),
                                    Text(
                                      'Reject',
                                      style: TextStyle(
                                        color: Color(0xFFE22424),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      else if (order.status == OrderStatus.accepted)
                         Container(
                          width: double.infinity,
                           padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:  const Color(0xFFE8FDF3), // Light Green
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF00C569))
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, size: 18, color: Color(0xFF00C569)),
                                SizedBox(width: 8),
                                Text(
                                  'ACCEPTED',
                                  style: TextStyle(
                                    color: Color(0xFF00C569),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                         )
                      else
                        Container(
                          width: double.infinity,
                           padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:  const Color(0xFFFFF0F0), // Light Red
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFC62828).withOpacity(0.3))
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cancel, size: 18, color: Color(0xFFC62828)),
                                SizedBox(width: 8),
                                Text(
                                  'REJECTED',
                                  style: TextStyle(
                                    color: Color(0xFFC62828),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                         ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Simple formatter. For prod use intl package
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return "${months[date.month - 1]} ${date.day}, ${weekDays[date.weekday - 1]}";
  }
}
