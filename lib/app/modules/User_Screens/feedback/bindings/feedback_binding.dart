import 'package:get/get.dart';
import 'package:salon/app/modules/User_Screens/feedback/controllers/feedback_controller.dart';

class FeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedbackController>(
      () => FeedbackController(),
    );
  }
}
