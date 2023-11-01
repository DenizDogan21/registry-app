import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:turboapp/BackEnd/Repositories/workOrderForm_repo.dart';
import 'package:turboapp/frontEnd/auth/login.dart';
import 'BackEnd/Repositories/inProgressForm_repo.dart';
import 'frontEnd/auth/singup.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Register the InProgressFormRepo instance
  Get.put(InProgressFormRepo());
  Get.put(WorkOrderFormRepo());
  

  // Run the application
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ege Turbo',
      routes: {
        "/loginPage": (context) => LoginPage(),
        "/signUp": (context) => SignUp(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: LoginPage(),
    );
  }
}