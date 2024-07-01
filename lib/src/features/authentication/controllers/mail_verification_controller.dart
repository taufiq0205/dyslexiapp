import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:dyslexiapp/src/constants/text_strings.dart';
import 'package:dyslexiapp/src/repository/authentication_repository/authentication_repository.dart';
import 'package:dyslexiapp/src/utils/helper/helper_controller.dart';

class MailVerificationController extends GetxController {
  // ignore: unused_field
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    sendVerificationEmail();
    setTimerForAutoRedirect();
  }

  /// -- Send OR Resend Email Verification
  Future<void> sendVerificationEmail() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
    } catch (e) {
      Helper.errorSnackBar(title: tOhSnap, message: e.toString());
    }
  }

  /// -- Set Timer to check if Verification Completed then Redirect
  void setTimerForAutoRedirect() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user!.emailVerified) {
        timer.cancel();
        AuthenticationRepository.instance.setInitialScreen(user);
      }
    });
  }

  /// -- Manually Check if Verification Completed then Redirect
  void manuallyCheckEmailVerificationStatus() {
    FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user!.emailVerified) {
      AuthenticationRepository.instance.setInitialScreen(user);
    }
  }
}
