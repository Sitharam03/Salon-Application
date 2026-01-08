import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/reviews/controllers/reviews_controller.dart';

class ReviewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewsController>(
      () => ReviewsController(),
    );
  }
}
