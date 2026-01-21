import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/data/models/order_model.dart';

// --- Accept Order Dialog ---
class AcceptOrderDialog extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onConfirm;

  const AcceptOrderDialog({super.key, required this.order, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE), // Light Pink bg
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Color(0xFFE53935), size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'Accept Request?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 12),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
                children: [
                  const TextSpan(text: 'Are you sure you want to accept '),
                  TextSpan(text: "${order.customerName}'s", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  const TextSpan(text: ' request for a '),
                  TextSpan(text: order.services.isNotEmpty ? order.services.first : 'Service', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  const TextSpan(text: ' on '),
                  TextSpan(text: _formatDate(order.date), style: const TextStyle(color: Colors.black)), // Date
                  const TextSpan(text: ' at '),
                  TextSpan(text: order.time, style: const TextStyle(color: Colors.black)),
                  const TextSpan(text: '?'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Accept & Notify', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
             const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Cancel', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
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

// --- Reject Order Dialog ---
class RejectOrderDialog extends StatefulWidget {
  final OrderModel order;
  final Function(String reason) onConfirm;

  const RejectOrderDialog({super.key, required this.order, required this.onConfirm});

  @override
  State<RejectOrderDialog> createState() => _RejectOrderDialogState();
}

class _RejectOrderDialogState extends State<RejectOrderDialog> {
  String selectedReason = 'Slot already booked';
  final TextEditingController commentController = TextEditingController();

  final List<String> reasons = [
    'Slot already booked',
    'Salon closed for holiday',
    'Stylist unavailable',
    'Other (Enter manually)',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        shape: BoxShape.circle,
                      ),
                       child: const Icon(Icons.close, color: Color(0xFFE53935), size: 32),
                    ),
                    const SizedBox(height: 16),
                    const Text('Reject Request?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                      'This action will notify the client that their booking cannot be accepted.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('SELECT REASON', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.0)),
                    ),
                    const SizedBox(height: 10),
                    ...reasons.map((reason) => _buildRadioItem(reason)),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('ADDITIONAL COMMENTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.0)),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Write a short note to the client (optional)...',
                         hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                           Get.back();
                           String finalReason = selectedReason == 'Other (Enter manually)' ? commentController.text : selectedReason;
                           if (finalReason.isEmpty) finalReason = "Booking Rejected";
                           widget.onConfirm(finalReason);
                        },
                         style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935), // Red
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Confirm Rejection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                     const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
        ),
    );
  }

  Widget _buildRadioItem(String reason) {
    bool isSelected = selectedReason == reason;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedReason = reason;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(child: Text(reason, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFFE53935) : Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}

// --- Change Provider Dialog ---
class ChangeProviderDialog extends StatefulWidget {
  final OrderModel order;
  final Function(String provider, String role) onConfirm;

  const ChangeProviderDialog({super.key, required this.order, required this.onConfirm});

  @override
  State<ChangeProviderDialog> createState() => _ChangeProviderDialogState();
}

class _ChangeProviderDialogState extends State<ChangeProviderDialog> {
   String selectedProviderId = '1'; 

   final List<Map<String, String>> providers = [
     {'id': '1', 'name': 'Anita Rao', 'role': 'Senior Stylist', 'image': 'https://ui-avatars.com/api/?name=Anita+Rao'},
     {'id': '2', 'name': 'John Doe', 'role': 'Color Specialist', 'image': 'https://ui-avatars.com/api/?name=John+Doe'},
     {'id': '3', 'name': 'Sarah Jenkins', 'role': 'Master Barber', 'image': 'https://ui-avatars.com/api/?name=Sarah+Jenkins'},
     {'id': '4', 'name': 'Michelle Wong', 'role': 'Junior Stylist', 'image': 'https://ui-avatars.com/api/?name=Michelle+Wong'},
     {'id': '0', 'name': 'Any Stylist', 'role': 'Available staff', 'image': ''},
   ];
   
   @override
   void initState() {
    super.initState();
    // Try to find current provider to select it
    final current = providers.firstWhereOrNull((p) => p['name'] == widget.order.serviceProviderName);
    if(current != null) {
      selectedProviderId = current['id']!;
    } else if (widget.order.serviceProviderName == "Any Stylist") {
      selectedProviderId = '0';
    }
   }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
       child: Padding(
         padding: const EdgeInsets.all(20),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFFFEBEE), shape: BoxShape.circle),
                child: const Icon(Icons.person_search, color: Color(0xFFE53935), size: 24),
              ),
              const SizedBox(height: 12),
              const Text('Change Service Provider', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
               Align(
                  alignment: Alignment.centerLeft,
                  child: Text('SELECT STYLIST', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.0)),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: providers.map((provider) => _buildProviderItem(provider)).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
               SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                     Get.back();
                     final selected = providers.firstWhere((p) => p['id'] == selectedProviderId);
                     widget.onConfirm(selected['name']!, selected['role']!);
                  },
                   style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935), // Red
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Update Provider', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
               const SizedBox(height: 12),
               TextButton(onPressed: () => Get.back(), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
           ],
         ),
       ),
    );
  }

  Widget _buildProviderItem(Map<String, String> provider) {
    bool isSelected = selectedProviderId == provider['id'];
    bool isAny = provider['id'] == '0';

    return GestureDetector(
      onTap: () => setState(() => selectedProviderId = provider['id']!),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? const Color(0xFFE53935) : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
             Icon(
                 isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                 color: isSelected ? const Color(0xFFE53935) : Colors.grey[300],
             ),
             const SizedBox(width: 12),
             CircleAvatar(
               radius: 20,
               backgroundColor: Colors.grey[200],
               backgroundImage: !isAny && provider['image'] != '' ? NetworkImage(provider['image']!) : null,
               child: isAny ? const Icon(Icons.store, color: Colors.grey, size: 20) : null,
             ),
             const SizedBox(width: 12),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(provider['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                 Text(provider['role']!, style: TextStyle(color: isSelected ? const Color(0xFFE53935) : Colors.grey, fontSize: 12)),
               ],
             )
          ],
        ),
      ),
    );
  }
}
