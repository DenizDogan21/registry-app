import 'package:get/get.dart';

// Define your routes as constants to avoid typos when calling them
class Routes {
  static const login = '/login';
  static const signUp = '/signUp';
  static const addForm = '/addForm';
  static const detailsIPF = '/detailsIPF';
  static const detailsWOF = '/detailsWOF';
  static const inputIPF = '/inputIPF';
  static const inputWOF = '/inputWOF';
  static const outputIPF = '/outputIPF';
  static const outputWOF = '/outputWOF';
  static const showForms = '/showForms';
}

class NavigationController extends GetxController {
  void navigateToLogin() => Get.toNamed(Routes.login);
  void navigateToSignup() => Get.toNamed(Routes.signUp);
  void navigateToAddForm() => Get.toNamed(Routes.addForm);
  void navigateToDetailsPF() => Get.toNamed(Routes.detailsIPF);
  void navigateToDetailsWOF() => Get.toNamed(Routes.detailsWOF);
  void navigateToInputPF() => Get.toNamed(Routes.inputIPF);
  void navigateToInputWOF() => Get.toNamed(Routes.inputWOF);
  void navigateToOutputPF() => Get.toNamed(Routes.outputIPF);
  void navigateToOutputWOF() => Get.toNamed(Routes.outputWOF);
  void navigateToShowForms() => Get.toNamed(Routes.showForms);

// Add other navigation methods here
}


