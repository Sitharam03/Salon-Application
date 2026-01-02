import 'package:get/get.dart';
import 'package:salon/app/modules/shop_details/controllers/shop_details_controller.dart';

class ShopDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopDetailsController>(
      () => ShopDetailsController(),
    );
  }
}
