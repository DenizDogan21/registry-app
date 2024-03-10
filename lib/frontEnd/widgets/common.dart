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
              Colors.grey.shade600,
              Colors.grey.shade800,
            ],
          ),
        ),
      ),
    ),
  );
}

PreferredSizeWidget? appBar(BuildContext context, String pageTitle) {
  final isTablet = MediaQuery.of(context).size.width > 600;
  return AppBar(
    backgroundColor: Colors.grey.shade900,
    toolbarHeight: isTablet ? 110 : null, // Adjust toolbar height conditionally
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          height: isTablet ? 44 : 22,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            pageTitle,
            style: CustomTextStyle.appBarTextStyle.copyWith(fontSize: isTablet ? 40 : 20),
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
  final BuildContext context; // Added context parameter
  const CustomTextButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.textColor = Colors.cyanAccent,
    required this.context, // Added context parameter
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return TextButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(color: textColor, fontSize: isTablet ? 20 : 16),
      ),
    );
  }
}

Widget bottomNav(BuildContext context) {
  final BottomNavigationController navigationController = Get.find<BottomNavigationController>();
  final isTablet = MediaQuery.of(context).size.width > 600;

  return Obx(() => BottomNavigationBar(
    backgroundColor: Colors.grey.shade900,
    selectedItemColor: Colors.cyanAccent,
    unselectedItemColor: Colors.grey.shade600,
    currentIndex: navigationController.currentIndex.value,
    onTap: navigationController.changeIndex,
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.handyman),
        label: "Ekle",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.remove_red_eye),
        label: "Göster",
      ),
    ],
    selectedFontSize: isTablet ? 30 : 15, // Adjust font size conditionally
    unselectedFontSize: isTablet ? 24 : 12, // Adjust font size conditionally
    iconSize: isTablet ? 50 : 25, // Adjust icon size conditionally
  ));
}



