import 'package:get/get.dart';
import 'package:salon/app/modules/services/bindings/services_binding.dart';
import 'package:salon/app/modules/services/views/services_view.dart';
import 'package:salon/app/modules/services/views/add_service_view.dart';
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
import 'package:salon/app/modules/service_providers/bindings/service_providers_binding.dart';
import 'package:salon/app/modules/service_providers/views/add_service_provider_view.dart';
import 'package:salon/app/modules/settings/bindings/settings_binding.dart';
import 'package:salon/app/modules/settings/views/settings_view.dart';
import 'package:salon/app/modules/settings/views/change_password_view.dart';
import 'package:salon/app/modules/settings/views/password_updated_view.dart';
import 'package:salon/app/modules/reviews/bindings/reviews_binding.dart';
import 'package:salon/app/modules/reviews/views/shop_reviews_view.dart';
import 'package:salon/app/modules/notifications/bindings/notifications_binding.dart';
import 'package:salon/app/modules/notifications/views/notifications_view.dart';
import 'package:salon/app/routes/app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = AppRoutes.LOGIN;

  static final routes = [
    GetPage(
      name: AppRoutes.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    // ... existing routes
    GetPage(
      name: AppRoutes.REVIEWS,
      page: () => const ShopReviewsView(),
      binding: ReviewsBinding(),
    ),
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
    GetPage(
      name: AppRoutes.SERVICES,
      page: () => const ServicesView(),
      binding: ServicesBinding(),
    ),
    GetPage(
      name: AppRoutes.ADD_SERVICE,
      page: () => const AddServiceView(),
      binding: ServicesBinding(),
    ),
    GetPage(
      name: AppRoutes.ADD_SERVICE_PROVIDER,
      page: () => const AddServiceProviderView(),
      binding: ServiceProvidersBinding(),
    ),
    
    // Settings Routes
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.PASSWORD_UPDATED,
      page: () => const PasswordUpdatedView(),
    ),
  ];
}
