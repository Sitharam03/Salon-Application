import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/booking_details/controllers/booking_details_controller.dart';

class BookingDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingDetailsController>(
      () => BookingDetailsController(),
    );
  }
}
