import 'package:flutter/material.dart';
import 'package:turboapp/frontEnd/utils/customTextStyle.dart';
import 'package:turboapp/frontEnd/formPages/showForms.dart';
import 'package:get/get.dart';
import 'package:turboapp/frontEnd/formPages/stepsWOF/first.dart';

class BottomNavigationController extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
    switch (index) {
      case 0:
        Get.offAll(() => FirstStepPage(formData: {})); // Get.offAll() removes all the previous routes
        break;
      case 1:
        Get.offAll(() => ShowFormsPage());
        break;
    // Add more cases for other tabs if you have more than two
    }
  }
}



Widget background(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.9],
            colors: [
              Colors.grey.shade800,
              Colors.black87,
            ],
          ),
        ),
      ),
    ),
  );
}


PreferredSizeWidget? appBar(BuildContext context, String pageTitle) {
  return AppBar(
    backgroundColor: Colors.grey.shade900,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Assuming you have an asset image for the logo
        Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          height: 22,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            pageTitle,
            style: CustomTextStyle.appBarTextStyle,
          ),
        ),
      ],
    ),
  );
}

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Color textColor;
  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.textColor = Colors.cyanAccent,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(color: textColor),
      ),
    );
  }
}


Widget bottomNav() {
  final BottomNavigationController navigationController = Get.find<BottomNavigationController>();

  return Obx(() => BottomNavigationBar(
    backgroundColor: Colors.grey.shade900,
    selectedItemColor: Colors.cyanAccent,
    unselectedItemColor: Colors.grey.shade600,
    currentIndex: navigationController.currentIndex.value,
    onTap: navigationController.changeIndex,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.handyman),
        label: "Ekle",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.remove_red_eye),
        label: "Göster",
      ),
    ],
  ));
}

