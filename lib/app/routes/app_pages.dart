import 'package:get/get.dart';
import 'package:salon/app/modules/admin/bindings/admin_binding.dart';
import 'package:salon/app/modules/admin/bindings/admin_signup_binding.dart';
import 'package:salon/app/modules/admin/views/admin_login_view.dart';
import 'package:salon/app/modules/admin/views/admin_signup_view.dart';
import 'package:salon/app/modules/admin/views/admin_otp_view.dart';
import 'package:salon/app/modules/admin/views/forgot_password_view.dart';
import 'package:salon/app/modules/admin/views/forgot_password_verification_view.dart';
import 'package:salon/app/modules/admin/views/reset_password_view.dart';
import 'package:salon/app/modules/admin/bindings/forgot_password_binding.dart';
import 'package:salon/app/modules/admin/views/success_view.dart';
import 'package:salon/app/modules/auth/bindings/auth_binding.dart';
import 'package:salon/app/modules/auth/views/login_view.dart';
import 'package:salon/app/modules/auth/views/otp_view.dart';
import 'package:salon/app/modules/home/bindings/home_binding.dart';
import 'package:salon/app/modules/home/views/home_view.dart';
import 'package:salon/app/modules/maps/bindings/maps_binding.dart';
import 'package:salon/app/modules/maps/views/location_view.dart';
import 'package:salon/app/modules/profile/bindings/profile_binding.dart';
import 'package:salon/app/modules/profile/views/profile_view.dart';
import 'package:salon/app/modules/shop_details/bindings/shop_details_binding.dart';
import 'package:salon/app/modules/shop_details/views/shop_details_view.dart';
import 'package:salon/app/modules/admin_dashboard/bindings/admin_dashboard_binding.dart';
import 'package:salon/app/modules/admin_dashboard/views/admin_dashboard_view.dart';
import 'package:salon/app/routes/app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = AppRoutes.LOGIN;

  static final routes = [
    // Customer Auth Routes
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.OTP,
      page: () => const OTPView(),
      binding: AuthBinding(),
    ),

    // Admin Routes
    GetPage(
      name: AppRoutes.ADMIN_LOGIN,
      page: () => const AdminLoginView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.ADMIN_SIGNUP,
      page: () => const AdminSignupView(),
      binding: AdminSignupBinding(),
    ),
    GetPage(
      name: AppRoutes.ADMIN_OTP,
      page: () => const AdminOTPView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.ADMIN_SUCCESS,
      page: () => const SuccessView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD_VERIFY,
      page: () => const ForgotPasswordVerificationView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ForgotPasswordBinding(),
    ),

    // Home Route
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

    // Profile Route
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),

    // Maps Route
    GetPage(
      name: AppRoutes.MAPS,
      page: () => const LocationView(),
      binding: MapsBinding(),
    ),
    GetPage(
      name: AppRoutes.SHOP_DETAILS,
      page: () => const ShopDetailsView(),
      binding: ShopDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
  ];
}
