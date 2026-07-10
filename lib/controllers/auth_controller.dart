import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_guide_app/core/services/auth_service.dart';
import 'package:my_guide_app/repositories/abstract/i_user_repository.dart';
import 'package:my_guide_app/models/user_model.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find();
  final IUserRepository _userRepository = Get.find();

  final RxBool isLoading = false.obs;
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final RxString verificationId = ''.obs;
  final RxString phoneNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _authService.userChanges.listen((user) {
      firebaseUser.value = user;
      if (user != null) {
        _handleUserLogin(user);
      } else {
        Get.offAllNamed('/login');
      }
    });
  }

  Future<void> sendOtp(String phone) async {
    isLoading.value = true;
    try {
      phoneNumber.value = phone;
      await _authService.sendOtp(phone, (vid) {
        verificationId.value = vid;
        Get.toNamed('/otp');
      });
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String smsCode) async {
    isLoading.value = true;
    try {
      await _authService.verifyOtp(verificationId.value, smsCode);
    } catch (e) {
      Get.snackbar('خطأ', 'الرمز غير صحيح');
    } finally {
      isLoading.value = false;
    }
  }

  void _handleUserLogin(User user) async {
    final userDoc = await _userRepository.getUser(user.uid);
    if (userDoc == null) {
      final newUser = UserModel(
        id: user.uid,
        name: user.displayName ?? 'مستخدم',
        phone: user.phoneNumber ?? '',
        photo: user.photoURL ?? '',
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
        isActive: true,
      );
      await _userRepository.createUser(newUser);
    } else {
      await _userRepository.updateLastLogin(user.uid);
    }
    Get.offAllNamed('/home');
  }

  void logout() async {
    await _authService.signOut();
    Get.offAllNamed('/login');
  }

  bool get isLoggedIn => firebaseUser.value != null;
}
