import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';
import 'package:turboapp/frontEnd/formPages/inputIPF.dart';
import 'package:turboapp/frontEnd/widgets/helpMethodsNavBar.dart';
import 'package:turboapp/frontEnd/formPages/stepsWOF/first.dart';


class AddFormPage extends StatefulWidget {
  AddFormPage({Key? key}) : super(key: key);

  @override
  _AddFormPageState createState() => _AddFormPageState();
}

class _AddFormPageState extends State<AddFormPage> {
  @override
  void initState() {
    super.initState();
    Get.put(BottomNavigationController());
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "   FORM EKLE"),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black54],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(context, "İş Emri Formu Ekle",FirstStepPage(formData: {})),
            SizedBox(height: 40,),
        //    buildButton(context, "Süreç Formu Ekle", const InputIPFPage()),
          ],
        ),
      ),
      bottomNavigationBar: bottomNav(),
    );
  }
}
