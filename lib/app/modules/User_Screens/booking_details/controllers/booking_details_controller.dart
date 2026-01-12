import 'package:get/get.dart';
import 'package:salon/app/routes/app_routes.dart';

class BookingDetailsController extends GetxController {
  final booking = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      booking.value = Get.arguments;
    }
  }

  void onReschedule() {
    // We need to pass the salon data back to the booking slot view, and ideally the parsed date.
    // Since our date is a string "OCT 10", we'll parse it for demo purposes to current year.
    DateTime? initialDate;
    try {
      final dateStr = booking['date'] as String; // "OCT 10"
      final parts = dateStr.split(' ');
      final months = {'JAN': 1, 'FEB': 2, 'MAR': 3, 'APR': 4, 'MAY': 5, 'JUN': 6, 'JUL': 7, 'AUG': 8, 'SEP': 9, 'OCT': 10, 'NOV': 11, 'DEC': 12};
      if (parts.length == 2 && months.containsKey(parts[0].toUpperCase())) {
         final month = months[parts[0].toUpperCase()]!;
         final day = int.parse(parts[1]);
         final now = DateTime.now();
         initialDate = DateTime(now.year, month, day);
      }
    } catch(e) {
      // fallback
    }

    Get.toNamed(AppRoutes.BOOKING_SLOT, arguments: {
      ...booking, // Pass all salon info
      'rescheduleDate': initialDate ?? DateTime.now(), // Pass parsed date or today
    });
  }
  
  void onRebook() {
     Get.toNamed(AppRoutes.SALON_DETAILS, arguments: booking);
  }
  
  void onFeedback() {
    Get.toNamed(AppRoutes.FEEDBACK, arguments: booking);
  }

  void onCancel() {
     Get.defaultDialog(
      title: "Cancel Booking",
      middleText: "Are you sure you want to cancel this booking?",
      textConfirm: "Yes, Cancel",
      textCancel: "No",
      confirmTextColor: Get.theme.canvasColor,
      onConfirm: () {
        Get.back();
        Get.back(); // Go back to list
        Get.snackbar('Cancelled', 'Booking has been cancelled');
      }
    );
  }

  void onGetDirections() {
     Get.snackbar('Directions', 'Opening maps...');
  }
}
