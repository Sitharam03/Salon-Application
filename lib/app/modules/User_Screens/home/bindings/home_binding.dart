import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/home/controllers/home_controller.dart';
import 'package:salon/app/modules/User_Screens/favorites/controllers/favorites_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put(FavoritesController(), permanent: true); // Keep alive for app session
  }
}
