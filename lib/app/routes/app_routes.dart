// ignore_for_file: constant_identifier_names

class AppRoutes {
  // Prevent instantiation
  AppRoutes._();

  // Customer Routes
  static const String LOGIN = '/login';
  static const String OTP = '/otp';
  static const String HOME = '/home';
  static const String PROFILE = '/profile';

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
}
