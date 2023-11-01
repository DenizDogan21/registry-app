import 'package:flutter/material.dart';
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
                    Color(0XFFE57373),
                    Color(0XFFEF5350),
                    Color(0XFFF44336),
                    Color(0XFFF44336),
                    Color(0XFF753935),
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
    selectedItemColor: CustomColors.loginButtonTextColor,
    unselectedItemColor: CustomColors.loginButtonTextColor,
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
            child: Text(pageTitle, style: TextStyle(color: Colors.redAccent)),
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

