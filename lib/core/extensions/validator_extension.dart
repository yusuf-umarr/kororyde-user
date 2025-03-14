import 'package:flutter/material.dart';

extension ValidatorExtension on BuildContext {
  String? validateNotEmpty(String? value) =>
      (value ?? '').isEmpty ? 'Field cannot be empty' : null;

  String? validateNotNull(dynamic value) =>
      value == null ? 'Field cannot be empty' : null;

  String? validateLength(String? value, int length) {
    if (value != null && value.isEmpty) {
      return 'Field cannot be empty';
    } else if (value!.length < length) {
      return 'Field must be at least 3 characters long';
    } else {
      return null;
    }
  }

  String? validateFullName<T>(String? value) {
    if (value == null) return 'Field cannot be empty';

    if (value.isEmpty) return 'Field cannot be empty';

    // if (value.split(' ').length < 2) return 'Enter a valid Full Name';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter an email address';

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    return !emailValid ? 'Enter a Valid Email Address' : null;
  }

  String? validateNotNullEmail(String? value) {
    if (value == null) return 'Please enter an email address';

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    return value.isEmpty
        ? null
        : !emailValid
            ? 'Enter a Valid Email Address'
            : null;
  }

  String? validatePhoneNumber(String? value) =>
      value != null && value.length < 10 ? 'Enter a Valid Phone Number' : null;

  String? validatePassword(String? value) => value == null || value.length < 6
      ? 'Password should be more than 6 Characters'
      : null;


  String? validateOtp(String? value) =>
      value != null && value.length == 6 ? null : 'Enter valid OTP';
}
