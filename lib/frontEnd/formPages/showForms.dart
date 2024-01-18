import 'package:flutter/material.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';
import 'package:turboapp/frontEnd/formPages/outputIPF.dart';
import 'package:turboapp/frontEnd/widgets/helpMethodsNavBar.dart';
import 'package:turboapp/frontEnd/formPages/outputWOF.dart';
import 'package:get/get.dart';


class ShowFormsPage extends StatefulWidget {
  ShowFormsPage({Key? key}) : super(key: key);

  @override
  _ShowFormsPageState createState() => _ShowFormsPageState();
}

class _ShowFormsPageState extends State<ShowFormsPage> {
  @override
  void initState() {
    super.initState();
    Get.put(BottomNavigationController());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "FORM GÖSTER"),
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
                  buildButton(context, "İş Emri Formları", const OutputWOFPage()),
                  SizedBox(height: 40,),
                  buildButton(context, "Süreç Formları", const OutputIPFPage()),
                ],
              ),
            ),
      bottomNavigationBar: bottomNav(),
    );
  }

}
