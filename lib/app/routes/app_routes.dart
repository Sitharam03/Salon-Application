// ignore_for_file: constant_identifier_names

class AppRoutes {
  // Prevent instantiation
  AppRoutes._();

  static const NOTIFICATIONS = '/notifications';
  static const USER_NOTIFICATIONS = '/user-notifications';

  // Customer Routes
  static const String LOGIN = '/login';
  static const String OTP = '/otp';
  static const String HOME = '/home';
  static const String PROFILE = '/profile';
  static const String COMPLETE_PROFILE = '/complete-profile';
  static const String MY_BOOKINGS = '/my-bookings';
  static const String BOOKING_DETAILS = '/booking-details';
  static const String FEEDBACK = '/feedback';
  static const String FEEDBACK_SUCCESS = '/feedback-success';
  static const SALON_DETAILS = '/salon-details';
  static const BOOKING_SLOT = '/booking-slot';
  static const BOOKING_SUCCESS = '/booking-success';
  static const FAVORITES = '/favorites';
  static const USER_PROFILE = '/user-profile';
  static const USER_SETTINGS = '/user-settings';
  static const DELETE_ACCOUNT_SUCCESS = '/delete-account-success';

  // Admin Routes
  static const String ADMIN_LOGIN = '/admin/login';
  static const String ADMIN_SIGNUP = '/admin/signup';
  static const String FORGOT_PASSWORD = '/admin/forgot-password';
  static const String FORGOT_PASSWORD_VERIFY = '/admin/forgot-password/verify';
  static const String RESET_PASSWORD = '/admin/reset-password';
  static const String ADMIN_OTP = '/admin/otp';
  static const String ADMIN_SUCCESS = '/admin/success';

  // Common Routes
  static const String MAPS = '/maps';
  static const String ONBOARDING = '/onboarding';
  static const SHOP_DETAILS = '/shop-details';
  static const ADMIN_DASHBOARD = '/admin-dashboard';
  static const SERVICES = '/services';
  static const ADD_SERVICE = '/add-service';
  static const SERVICE_PROVIDERS = '/service-providers';
  static const ADD_SERVICE_PROVIDER = '/add-service-provider';

  // Reviews Routes
  static const REVIEWS = '/reviews';

  // Settings Routes
  static const SETTINGS = '/settings';
  static const CHANGE_PASSWORD = '/change-password';
  static const PASSWORD_UPDATED = '/password-updated';
}
