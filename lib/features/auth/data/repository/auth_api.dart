import 'dart:developer' as dev;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../common/common.dart';
import '../../../../core/network/network.dart';

class AuthApi {
  Future getLanguagesApi() async {
    try {
      Response response = await DioProviderImpl().get(ApiEndpoints.countryList);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future verifyUserApi(
      {required String emailOrMobileNumber,
      required bool isLoginByEmail}) async {
    try {
      Response response = await DioProviderImpl().post(
        ApiEndpoints.verifyUser,
        body: isLoginByEmail
            ? FormData.fromMap({'email': emailOrMobileNumber})
            : FormData.fromMap({'mobile': emailOrMobileNumber}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future commonModuleCheckApi() async {
    try {
      Response response =
          await DioProviderImpl().get(ApiEndpoints.commonModule);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future sendMobileOtpApi(
      {required String mobileNumber, required String countryCode}) async {
    try {
      Response response = await DioProviderImpl().post(
        ApiEndpoints.sendMobileOtp,
        body: FormData.fromMap(
            {"mobile": mobileNumber, "country_code": countryCode}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future verifyMobileOtpApi(
      {required String mobileNumber, required String otp}) async {
    try {
      Response response = await DioProviderImpl().post(
        ApiEndpoints.verifyMobileOtp,
        body: FormData.fromMap({"mobile": mobileNumber, "otp": otp}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future sendEmailOtpApi({required String emailAddress}) async {
    try {
      Response response = await DioProviderImpl().post(
        ApiEndpoints.sendEmailOtp,
        body: FormData.fromMap({"email": emailAddress}), //send-mail-otp
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future verifyEmailOtpApi(
      {required String emailAddress, required String otp}) async {
    try {
      Response response = await DioProviderImpl().post(
        ApiEndpoints.verifyEmailOtp,
        body: FormData.fromMap(
            {"email": emailAddress, "otp": otp}), //validate-email-otp
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future userLoginApi(
      {required String emailOrMobile,
      required String otp,
      required String password,
      required bool isOtpLogin,
      required bool isLoginByEmail}) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.userLogin,
        body: !isOtpLogin
            ? FormData.fromMap({
                if (!isLoginByEmail) "mobile": emailOrMobile,
                if (isLoginByEmail) "email": emailOrMobile,
                'password': password,
                'device_token': fcmToken,
                "login_by": (Platform.isAndroid) ? 'android' : 'ios',
              })
            : (!isLoginByEmail)
                ? FormData.fromMap({
                    "mobile": emailOrMobile,
                    'device_token': fcmToken,
                    "login_by": (Platform.isAndroid) ? 'android' : 'ios',
                  })
                : FormData.fromMap({
                    "email": emailOrMobile,
                    "otp": otp,
                    'device_token': fcmToken,
                    "login_by": (Platform.isAndroid) ? 'android' : 'ios',
                  }),
      );
      // dev.log("userlogin res----:${response}");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future userRegisterApi(
      {required String userName,
      required String mobileNumber,
      required String emailAddress,
      required String password,
      required String countryCode,
      required String gender,
      required String profileImage}) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final choosenLanguage =
          await AppSharedPreference.getSelectedLanguageCode();

      final formData = FormData.fromMap({
        "name": userName,
        "mobile": mobileNumber,
        "email": emailAddress,
        "password": password,
        "device_token": fcmToken,
        "country": countryCode,
        "login_by": 'manual',
        "is_web": true,

        // "login_by": (Platform.isAndroid) ? 'android' : 'ios',
        'lang': choosenLanguage,
        'gender': 'others',
      });
      if (profileImage.isNotEmpty) {
        formData.files.add(MapEntry(
            'profile_picture', await MultipartFile.fromFile(profileImage)));
      }
      Response response = await DioProviderImpl().post(
        // 'https://Koro.gee.ng/api/v1/user/register',
        ApiEndpoints.registerUser,
        body: formData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updatePasswordApi(
      {required String emailOrMobile,
      required String password,
      required bool isLoginByEmail}) async {
    try {
      Response response = await DioProviderImpl().post(
        ApiEndpoints.updatePassword,
        body: isLoginByEmail
            ? FormData.fromMap({"email": emailOrMobile, "password": password})
            : FormData.fromMap({"mobile": emailOrMobile, "password": password}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future referralApi({required String referralCode}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        ApiEndpoints.referral,
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
        body: FormData.fromMap({"refferal_code": referralCode}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
