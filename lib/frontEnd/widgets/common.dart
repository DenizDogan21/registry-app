import 'package:flutter/material.dart';
import '../formPages/inputIPF.dart';
import '../formPages/outputIPF.dart';
import '../utils/customColors.dart';
import 'package:turboapp/frontEnd/formPages/addForm.dart';
import 'package:turboapp/frontEnd/formPages/showForms.dart';


Widget background(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0XFFB0BEC5),
                    Color(0XFF78909C),
                    Color(0XFF455A64),
                    Color(0XFF455A64),
                    Color(0XFF263238),
                  ]),
            ),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget bottomNav(BuildContext context) {
  return BottomNavigationBar(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.deepPurple,
    unselectedItemColor: Colors.deepPurple,
    showUnselectedLabels: false,
    showSelectedLabels: false,

    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.handyman),
        label: "",

      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.remove_red_eye),
        label: "",
      ),
    ],
    onTap: (int index) {
      // Handle navigation based on the tapped item
      switch (index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddFormPage()),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ShowFormsPage()),);
          break;
        case 2:
          break;
      }
    },
  );
}


PreferredSizeWidget? appBar(BuildContext context, String pageTitle) {
  return PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: AppBar(
      backgroundColor: Colors.black,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            height: 22,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(pageTitle),
          ),
        ],
      ),
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
    this.textColor = CustomColors.pinkColor,
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

