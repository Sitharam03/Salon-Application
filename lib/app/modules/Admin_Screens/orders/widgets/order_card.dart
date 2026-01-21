import 'package:flutter/material.dart';
import 'package:salon/app/data/models/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onChangeProvider;

  const OrderCard({
    super.key,
    required this.order,
    this.onAccept,
    this.onReject,
    this.onChangeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20), // Spacious padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // Softer corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), // Very subtle shadow
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Avatar | Name & Service | Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with Badge
              Stack(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.brown[200], // Placeholder color
                      borderRadius: BorderRadius.circular(16), // Rounded square
                      image: order.customerImage != null 
                        ? DecorationImage(image: AssetImage(order.customerImage!), fit: BoxFit.cover)
                        : const DecorationImage(
                            image: NetworkImage('https://ui-avatars.com/api/?name=User&background=D7CCC8&color=5D4037'),
                            fit: BoxFit.cover,
                          ),
                    ),
                  ),
                   if (order.status == OrderStatus.pending)
                   Positioned(
                     right: -4,
                     bottom: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.cut, size: 12, color: Color(0xFFE53935)),
                      ),
                   )
                ],
              ),
              const SizedBox(width: 16),
              
              // Name & Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E232C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          order.customerPhone,
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

              // Status Chip
              _buildStatusChip(order.status),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
          const SizedBox(height: 16),

          // 2. Details: Services
          _buildDetailRow(
            icon: Icons.spa_outlined,
            label: 'SERVICES',
            content: order.services.join(", "),
            contentStyle: const TextStyle(
              color: Color(0xFF1E232C),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 16),

          // 3. Details: Service Provider (Clickable)
          _buildDetailRow(
            icon: Icons.person_outline,
            label: 'SERVICE PROVIDER',
            customContent: GestureDetector(
               onTap: onChangeProvider,
               child: RichText(
                 text: TextSpan(
                   style: const TextStyle(fontSize: 14, color: Color(0xFF1E232C)),
                   children: [
                     TextSpan(text: '${order.serviceProviderRole}: ', style: const TextStyle(fontWeight: FontWeight.w500)),
                     TextSpan(
                       text: order.serviceProviderName, 
                       style: const TextStyle(
                         fontWeight: FontWeight.bold, 
                         color: Color(0xFFE53935), // Red highlighting as requested
                         decoration: TextDecoration.underline,
                         decorationColor: Color(0xFFE53935), 
                       )
                     ),
                   ],
                 ),
               ),
            ),
          ),

          const SizedBox(height: 16),

          // 4. Details: Date & Time
          Row(
            children: [
               const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF90A4AE)),
               const SizedBox(width: 12),
               Text(
                 _getRelativeDate(order.date),
                 style: const TextStyle(
                   fontWeight: FontWeight.bold,
                   color: Color(0xFF1E232C),
                   fontSize: 14,
                 ),
               ),
               
               const SizedBox(width: 24),
               
               const Icon(Icons.access_time, size: 16, color: Color(0xFF90A4AE)),
               const SizedBox(width: 12),
               Text(
                 order.time, // e.g. "10:30 AM"
                 style: const TextStyle(
                   fontWeight: FontWeight.bold,
                   color: Color(0xFF1E232C),
                   fontSize: 14,
                 ),
               ),
            ],
          ),

          const SizedBox(height: 24),

          // 5. Action Buttons / Status Bar
          if (order.status == OrderStatus.pending)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF90A4AE),
                      side: BorderSide(color: Colors.grey.shade200),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('REJECT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935), // Red
                      elevation: 4,
                      shadowColor: const Color(0xFFE53935).withOpacity(0.4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('ACCEPT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ),
                ),
              ],
            )
          else if (order.status == OrderStatus.accepted)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFDCFCE7)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF00C569), size: 18),
                  SizedBox(width: 8),
                  Text('CONFIRMED', style: TextStyle(color: Color(0xFF00C569), fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                ],
              ),
            )
          else 
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFEE2E2)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cancel, color: Color(0xFFEF4444), size: 18),
                  SizedBox(width: 8),
                  Text('REJECTED', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case OrderStatus.accepted:
        bg = const Color(0xFFE8FDF3);
        text = const Color(0xFF00C569);
        label = 'ACCEPTED';
        break;
      case OrderStatus.rejected:
        bg = const Color(0xFFFFEBEE);
        text = const Color(0xFFE53935);
        label = 'REJECTED';
        break;
      case OrderStatus.pending:
      default:
        bg = const Color(0xFFFFF8E1);
        text = const Color(0xFFFFB300);
        label = 'PENDING';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String label, String? content, Widget? customContent, TextStyle? contentStyle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF90A4AE)), // Icon color
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF90A4AE),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              customContent ?? Text(
                content ?? '',
                style: contentStyle ?? const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E232C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final inputDate = DateTime(date.year, date.month, date.day);

    if (inputDate == today) return "Today";
    if (inputDate == tomorrow) return "Tomorrow";
    
    // Fallback format
     final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${months[date.month - 1]} ${date.day}";
  }
}
