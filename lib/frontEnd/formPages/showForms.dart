import 'package:flutter/material.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';
import 'package:turboapp/frontEnd/formPages/outputIPF.dart';
import 'package:turboapp/frontEnd/utils/customTextStyle.dart';
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
    // Initialize your NavigationController if it hasn't been initialized already
    Get.put(BottomNavigationController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "  KAYITLI FORMLAR"),
      bottomNavigationBar: bottomNav(),
      body: Stack(
        children: [
          background(context),
          SafeArea(
            child: Center(child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (
                            context) => const OutputWOFPage()),
                      );
                    },
                    child: Text("İş Emri Formlarını Göster",
                        style: CustomTextStyle.titleTextStyle),
                    style:
                    TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(width: 0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))
                    ),
                  ),
                ),
                SizedBox(width: 40), // Add a SizedBox with the desired width
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (
                            context) => const OutputIPFPage()),
                      );
                    },
                    child: Text("Süreç Formlarını Göster",
                        style: CustomTextStyle.titleTextStyle),
                    style:
                    TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(width: 0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))
                    ),
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

}