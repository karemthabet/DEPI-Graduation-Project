
import 'package:whatsapp/core/validators/app_regx.dart';

/// 🔹 يحتوي على كل ال Form Validators الجاهزة للـ TextFormField
abstract class AppValidators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    } else if (!AppRegex.isUserNameValid(value.trim())) {
      return 'Enter a valid name (letters only, at least 3 characters)';
    }
    return null;
  }

  static String? validateArabicName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    } else if (!AppRegex.isArabicNameValid(value.trim())) {
      return 'Enter a valid Arabic name';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    } else if (!AppRegex.isValidEgyptianPhoneNumber(value.trim())) {
      return 'Enter a valid Egyptian phone number';
    }
    return null;
  }

  static String? validateGlobalPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    } else if (!AppRegex.isGlobalPhoneNumberValid(value.trim())) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    } else if (!AppRegex.isEmailValid(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    } else if (!AppRegex.isPasswordValid(value.trim())) {
      return 'Password must be at least 8 characters,\ncontain at least one letter and one number';
    }
    return null;
  }

  static String? validateConfirmPassword(String? confirm, String original) {
    if (confirm == null || confirm.trim().isEmpty) {
      return 'Please confirm your password';
    } else if (confirm != original) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateNumber(String? value, {int? min, int? max}) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    } else if (!AppRegex.isNumeric(value)) {
      return 'Only numbers are allowed';
    } else {
      final num number = num.parse(value);
      if (min != null && number < min) return 'Number must be at least $min';
      if (max != null && number > max) return 'Number must be at most $max';
    }
    return null;
  }

  static String? validateNotEmpty(
    String? value, [
    String message = 'This field is required',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }
}

/// 🧪 أمثلة استخدام داخل TextFormField
///
/// ```dart
/// TextFormField(
///   decoration: const InputDecoration(labelText: "Email"),
///   validator: AppValidators.validateEmail,
/// ),
///
/// TextFormField(
///   decoration: const InputDecoration(labelText: "Password"),
///   obscureText: true,
///   validator: AppValidators.validatePassword,
/// ),
///
/// TextFormField(
///   decoration: const InputDecoration(labelText: "Phone"),
///   validator: AppValidators.validatePhone,
/// ),
/// ```
