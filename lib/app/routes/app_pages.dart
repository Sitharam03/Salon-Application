import 'package:get/get.dart';
import 'package:salon/app/modules/Admin_Screens/services/bindings/services_binding.dart';
import 'package:salon/app/modules/Admin_Screens/services/views/services_view.dart';
import 'package:salon/app/modules/Admin_Screens/services/views/add_service_view.dart';
import 'package:salon/app/modules/Admin_Screens/admin_auth/bindings/admin_binding.dart';
import 'package:salon/app/modules/Admin_Screens/admin_auth/bindings/admin_signup_binding.dart';
import 'package:salon/app/modules/Admin_Screens/admin_auth/views/admin_login_view.dart';
import 'package:salon/app/modules/Admin_Screens/admin_auth/views/admin_signup_view.dart';
import 'package:salon/app/modules/Admin_Screens/admin_auth/views/admin_otp_view.dart';
import 'package:salon/app/modules/Admin_Screens/admin_auth/views/forgot_password_view.dart';
import 'package:salon/app/modules/Admin_Screens/admin_auth/views/forgot_password_verification_view.dart';
import 'package:salon/app/modules/Admin_Screens/admin_auth/views/reset_password_view.dart';
import 'package:salon/app/modules/Admin_Screens/admin_auth/bindings/forgot_password_binding.dart';
import 'package:salon/app/modules/Admin_Screens/admin_auth/views/success_view.dart';
import 'package:salon/app/modules/User_Screens/user_auth/bindings/auth_binding.dart';
import 'package:salon/app/modules/User_Screens/user_auth/views/login_view.dart';
import 'package:salon/app/modules/User_Screens/user_auth/views/otp_view.dart';
import 'package:salon/app/modules/User_Screens/home/bindings/home_binding.dart';
import 'package:salon/app/modules/User_Screens/complete_profile/bindings/complete_profile_binding.dart';
import 'package:salon/app/modules/User_Screens/complete_profile/views/complete_profile_view.dart';
import 'package:salon/app/modules/User_Screens/dashboard/bindings/user_dashboard_binding.dart';
import 'package:salon/app/modules/User_Screens/dashboard/views/user_dashboard_view.dart';
import 'package:salon/app/modules/User_Screens/home/views/home_view.dart';
import 'package:salon/app/modules/maps/bindings/maps_binding.dart';
import 'package:salon/app/modules/maps/views/location_view.dart';
import 'package:salon/app/modules/Admin_Screens/profile/bindings/profile_binding.dart';
import 'package:salon/app/modules/Admin_Screens/profile/views/profile_view.dart';
import 'package:salon/app/modules/Admin_Screens/shop_details/bindings/shop_details_binding.dart';
import 'package:salon/app/modules/Admin_Screens/shop_details/views/shop_details_view.dart';
import 'package:salon/app/modules/Admin_Screens/admin_dashboard/bindings/admin_dashboard_binding.dart';
import 'package:salon/app/modules/Admin_Screens/admin_dashboard/views/admin_dashboard_view.dart';
import 'package:salon/app/modules/Admin_Screens/service_providers/bindings/service_providers_binding.dart';
import 'package:salon/app/modules/Admin_Screens/service_providers/views/add_service_provider_view.dart';
import 'package:salon/app/modules/Admin_Screens/settings/bindings/settings_binding.dart';
import 'package:salon/app/modules/Admin_Screens/settings/views/settings_view.dart';
import 'package:salon/app/modules/Admin_Screens/settings/views/change_password_view.dart';
import 'package:salon/app/modules/Admin_Screens/settings/views/password_updated_view.dart';
import 'package:salon/app/modules/Admin_Screens/reviews/bindings/reviews_binding.dart';
import 'package:salon/app/modules/Admin_Screens/reviews/views/shop_reviews_view.dart';
import 'package:salon/app/modules/Admin_Screens/notifications/bindings/notifications_binding.dart';
import 'package:salon/app/modules/Admin_Screens/notifications/views/notifications_view.dart';
import 'package:salon/app/modules/User_Screens/my_bookings/bindings/my_bookings_binding.dart';
import 'package:salon/app/modules/User_Screens/notifications/bindings/user_notifications_binding.dart';
import 'package:salon/app/modules/User_Screens/notifications/views/user_notifications_view.dart';
import 'package:salon/app/modules/User_Screens/my_bookings/views/my_bookings_view.dart';
import 'package:salon/app/modules/User_Screens/booking_details/bindings/booking_details_binding.dart';
import 'package:salon/app/modules/User_Screens/booking_details/views/booking_details_view.dart';
import 'package:salon/app/modules/User_Screens/feedback/bindings/feedback_binding.dart';
import 'package:salon/app/modules/User_Screens/feedback/views/feedback_view.dart';
import 'package:salon/app/modules/User_Screens/feedback/views/feedback_success_view.dart';
import 'package:salon/app/modules/User_Screens/favorites/bindings/favorites_binding.dart';
import 'package:salon/app/modules/User_Screens/favorites/views/favorites_view.dart';
import 'package:salon/app/modules/User_Screens/profile/bindings/user_profile_binding.dart';
import 'package:salon/app/modules/User_Screens/profile/views/user_profile_view.dart';
import 'package:salon/app/modules/User_Screens/user_settings/bindings/user_settings_binding.dart';
import 'package:salon/app/modules/User_Screens/user_settings/views/user_settings_view.dart';
import 'package:salon/app/modules/User_Screens/user_settings/views/delete_account_success_view.dart';

import 'package:salon/app/routes/app_routes.dart';
import 'package:salon/app/modules/User_Screens/booking/bindings/booking_binding.dart';
import 'package:salon/app/modules/User_Screens/booking/views/salon_details_view.dart';
import 'package:salon/app/modules/User_Screens/booking/views/booking_slot_view.dart';
import 'package:salon/app/modules/User_Screens/booking/views/booking_success_view.dart';

class AppPages {
  AppPages._();

  static const INITIAL = AppRoutes.HOME;

  static final routes = [
    GetPage(
      name: AppRoutes.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: AppRoutes.USER_NOTIFICATIONS,
      page: () => const UserNotificationsView(),
      binding: UserNotificationsBinding(),
    ),
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
    GetPage(
      name: AppRoutes.COMPLETE_PROFILE,
      page: () => const CompleteProfileView(),
      binding: CompleteProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.SALON_DETAILS,
      page: () => const SalonDetailsView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: AppRoutes.BOOKING_SLOT,
      page: () => const BookingSlotView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: AppRoutes.BOOKING_SUCCESS,
      page: () => const BookingSuccessView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: AppRoutes.FAVORITES,
      page: () => const FavoritesView(),
      binding: FavoritesBinding(),
    ),
    GetPage(
      name: AppRoutes.USER_PROFILE,
      page: () => const UserProfileView(),
      binding: UserProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.USER_SETTINGS,
      page: () => const UserSettingsView(),
      binding: UserSettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.DELETE_ACCOUNT_SUCCESS,
      page: () => const DeleteAccountSuccessView(),
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
      page: () => const UserDashboardView(),
      binding: UserDashboardBinding(),
    ),

    // Profile Route (Admin)
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
    GetPage(
      name: AppRoutes.MY_BOOKINGS,
      page: () => const MyBookingsView(),
      binding: MyBookingsBinding(),
    ),
    GetPage(
      name: AppRoutes.BOOKING_DETAILS,
      page: () => const BookingDetailsView(),
      binding: BookingDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.FEEDBACK,
      page: () => const FeedbackView(),
      binding: FeedbackBinding(),
    ),
    GetPage(
      name: AppRoutes.FEEDBACK_SUCCESS,
      page: () => const FeedbackSuccessView(),
    ),
  ];
}
