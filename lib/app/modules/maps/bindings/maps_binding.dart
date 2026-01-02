import 'package:get/get.dart';
import 'package:salon/app/modules/maps/controllers/location_controller.dart';

class MapsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationController>(() => LocationController());
  }
}
