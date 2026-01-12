import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
