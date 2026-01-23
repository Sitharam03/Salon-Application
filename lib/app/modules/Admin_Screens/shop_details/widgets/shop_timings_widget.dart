import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/shop_details/controllers/shop_details_controller.dart';

class ShopTimingsWidget extends StatelessWidget {
  final ShopDetailsController controller;
  final bool isEditable;
  final VoidCallback? onApplyToAllDays;

  const ShopTimingsWidget({
    super.key,
    required this.controller,
    this.isEditable = true,
    this.onApplyToAllDays,
  });

  @override
  Widget build(BuildContext context) {
    // Get responsive dimensions
    final isMobile = MediaQuery.of(context).size.width < 600;
    final padding = isMobile ? 16.0 : 24.0;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            if (isEditable)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE22424).withOpacity(0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFFE22424),
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Set your salon\'s weekly schedule. Customers will only be able to book during these hours.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1E232C),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (isEditable) const SizedBox(height: 24),

            // Timings List
            Obx(
              () => Column(
                children: controller.shopTimings.asMap().entries.map<Widget>((
                  entry,
                ) {
                  return _buildTimingRow(
                    context,
                    index: entry.key,
                    timing: entry.value,
                    isEditable: isEditable,
                  );
                }).toList(),
              ),
            ),

            // Apply to All Days Button
            if (isEditable && onApplyToAllDays != null) ...[
              const SizedBox(height: 24),
              GestureDetector(
                onTap: onApplyToAllDays,
                child: Row(
                  children: [
                    const Icon(
                      Icons.copy_all, // Or similar icon
                      color: Color(0xFFE22424),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'APPLY TO ALL DAYS',
                      style: const TextStyle(
                        color: Color(0xFFE22424),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimingRow(
    BuildContext context, {
    required int index,
    required ShopTiming timing,
    required bool isEditable,
  }) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header with Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timing.day,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E232C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timing.isOpen ? 'Open' : 'Closed',
                      style: TextStyle(
                        fontSize: 14,
                        color: timing.isOpen
                            ? const Color(0xFFE22424)
                            : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (isEditable)
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: timing.isOpen,
                    onChanged: (val) => controller.toggleShopOpen(index, val),
                    activeColor: const Color(0xFFE22424),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey[200],
                    trackOutlineColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.transparent,
                    ),
                  ),
                ),
            ],
          ),

          // Time Selectors
          if (timing.isOpen) ...[
            const SizedBox(height: 16),
            if (isMobile)
              // Mobile Layout: Side by side for compact view or Stacked?
              // Image shows side by side inputs
              Row(
                children: [
                  Expanded(
                    child: _buildTimeField(
                      context: context,
                      label: 'OPENING TIME',
                      time: timing.openingTime,
                      onTap: isEditable
                          ? () => controller.selectTime(context, index, true)
                          : null,
                      isEditable: isEditable,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTimeField(
                      context: context,
                      label: 'CLOSING TIME',
                      time: timing.closingTime,
                      onTap: isEditable
                          ? () => controller.selectTime(context, index, false)
                          : null,
                      isEditable: isEditable,
                    ),
                  ),
                ],
              )
            else
              // Tablet/Desktop Layout: Side by side
              Row(
                children: [
                  Expanded(
                    child: _buildTimeField(
                      context: context,
                      label: 'OPENING TIME',
                      time: timing.openingTime,
                      onTap: isEditable
                          ? () => controller.selectTime(context, index, true)
                          : null,
                      isEditable: isEditable,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTimeField(
                      context: context,
                      label: 'CLOSING TIME',
                      time: timing.closingTime,
                      onTap: isEditable
                          ? () => controller.selectTime(context, index, false)
                          : null,
                      isEditable: isEditable,
                    ),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeField({
    required BuildContext context,
    required String label,
    required String time,
    required VoidCallback? onTap,
    required bool isEditable,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8391A1), // Blue-ish grey
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: isEditable ? onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8F9), // Light grey background
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E232C),
                  ),
                ),
                if (isEditable)
                  const Icon(
                    Icons.access_time_filled, // Filled icon
                    size: 18,
                    color: Color(0xFF9095A1), // Grey icon
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
