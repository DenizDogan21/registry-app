import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:turboapp/BackEnd/Repositories/workOrderForm_repo.dart';
import 'package:turboapp/frontEnd/auth/login.dart';
import 'package:turboapp/BackEnd/Repositories/inProgressForm_repo.dart';
import 'package:turboapp/frontEnd/auth/singup.dart';


import 'backEnd/controllers/navigationController.dart';
import 'frontEnd/widgets/common.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Register the InProgressFormRepo and WorkOrderFormRepo instances
  Get.put(InProgressFormRepo());
  Get.put(WorkOrderFormRepo());
  Get.put(NavigationController());
  Get.put(BottomNavigationController());

  // Run the application
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Your App Name',
      initialRoute: Routes.login,
      getPages: [
        GetPage(name: Routes.login, page: () => LoginPage()),
        GetPage(name: Routes.signup, page: () => SignUp()),
        // ... and so on for each route
      ],
      // ...
    );
  }
}
