import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  void sendOtp(String phoneNumber) {
    isLoading.value = true;
    isLoading.value = false;
  }

  void verifyOtp(String otp) {
    isLoading.value = true;
    isLoggedIn.value = true;
    isLoading.value = false;
  }
}
