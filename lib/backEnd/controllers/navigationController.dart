import 'package:get/get.dart';

// Define your routes as constants to avoid typos when calling them
class Routes {
  static const login = '/login';
  static const forgotPassword = '/forgotPassword';
  static const signUp = '/signUp';
  static const detailsIPF = '/detailsIPF';
  static const detailsWOF = '/detailsWOF';
  static const outputIPF = '/outputIPF';
  static const outputWOF = '/outputWOF';
  static const showForms = '/showForms';
}

class NavigationController extends GetxController {
  void navigateToLogin() => Get.toNamed(Routes.login);
  void navigateToForgotPassword() => Get.toNamed(Routes.forgotPassword);
  void navigateToSignup() => Get.toNamed(Routes.signUp);
  void navigateToDetailsIPF() => Get.toNamed(Routes.detailsIPF);
  void navigateToDetailsWOF() => Get.toNamed(Routes.detailsWOF);
  void navigateToOutputIPF() => Get.toNamed(Routes.outputIPF);
  void navigateToOutputWOF() => Get.toNamed(Routes.outputWOF);
  void navigateToShowForms() => Get.toNamed(Routes.showForms);

// Add other navigation methods here
}


