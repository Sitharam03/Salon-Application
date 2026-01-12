import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/my_bookings/controllers/my_bookings_controller.dart';

class MyBookingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyBookingsController>(
      () => MyBookingsController(),
    );
  }
}
