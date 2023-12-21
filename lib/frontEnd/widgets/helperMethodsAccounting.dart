import 'package:flutter/material.dart';
import 'package:turboapp/frontEnd/utils/customTextStyle.dart';
import 'package:get/get.dart';
import 'package:turboapp/frontEnd/accountingPages/accountingAddShow.dart';
import 'package:turboapp/frontEnd/accountingPages/accountingDownload.dart';

import '../formPages/showForms.dart';


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
          image: DecorationImage(
            image: AssetImage("assets/images/finance_pattern.avif"),
            fit: BoxFit.cover,
            opacity: 0.2, // Adjust opacity for a subtle appearance
          ),
        ),
      ),
    ),
  );
}




PreferredSizeWidget? appBar(BuildContext context, String pageTitle) {
  return AppBar(
    backgroundColor: Colors.grey.shade700,
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



class BottomNavigationControllerAcc extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
    switch (index) {
      case 0:
        Get.offAll(() => AccountingAddShowPage()); // Get.offAll() removes all the previous routes
        break;
      case 1:
        Get.offAll(() => AccountingDownloadPage());
        break;
    }
  }
}

Widget bottomNavAcc() {
  final BottomNavigationControllerAcc navigationController = Get.find<BottomNavigationControllerAcc>();

  return Obx(() => BottomNavigationBar(
    backgroundColor: Colors.grey.shade800,
    selectedItemColor: Colors.cyanAccent,
    unselectedItemColor: Colors.white,
    currentIndex: navigationController.currentIndex.value,
    onTap: navigationController.changeIndex,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.attach_money),
        label: "Ekle/Göster",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.cloud_download),
        label: "İndir",
      ),
    ],
  ));
}
