import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/booking/controllers/booking_controller.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingController>(
      () => BookingController(),
    );
  }
}
