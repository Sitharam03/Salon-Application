import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/app/routes/app_pages.dart';
import 'package:salon/app/routes/app_routes.dart';
import 'package:salon/app/services/notification_service.dart';
import 'package:salon/app/services/mock_data_service.dart';
import 'package:salon/app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  Get.put(MockDataService());
  await Get.putAsync(() => AuthService().init());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    
    // Determine Initial Route
    String initialRoute = AppRoutes.LOGIN;
    if (authService.isLoggedIn.value) {
      if (authService.userType.value == 'admin') {
        initialRoute = AppRoutes.ADMIN_DASHBOARD;
      } else {
        initialRoute = AppRoutes.HOME;
      }
    }

    return GetMaterialApp(
      title: 'Salon Application',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    );
  }
}
