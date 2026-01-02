class Validators {
  // Prevent instantiation
  Validators._();

  /// Validates phone number
  /// Returns null if valid, error message if invalid
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter phone number';
    }

    if (value.length < 10) {
      return 'Please enter valid phone number';
    }

    return null;
  }

  /// Validates OTP
  /// Returns null if valid, error message if invalid
  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter OTP';
    }

    if (value.length < 4) {
      return 'Please enter complete OTP';
    }

    return null;
  }

  /// Check if phone number is valid (returns bool)
  static bool isPhoneNumberValid(String? value) {
    return value != null && value.isNotEmpty && value.length >= 10;
  }

  /// Check if OTP is complete
  static bool isOTPComplete(String? value) {
    return value != null && value.length == 4;
  }
}
