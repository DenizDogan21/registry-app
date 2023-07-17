import 'package:flutter/material.dart';
import '../form/input.dart';
import '../form/output.dart';
import '../utils/customColors.dart';


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
                    Color(0XFF263238),
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
        icon: Icon(Icons.car_crash),
        label: "",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.car_repair),
        label: "",
      ),
    ],
    onTap: (int index) {
      // Handle navigation based on the tapped item
      switch (index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => InputPage()),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OutputPage()),);
          break;
        case 2:
          break;
      }
    },
  );
}


PreferredSizeWidget? appBar(BuildContext context, String pageTitle, {List<Widget>? actions}) {
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
            height: 32,
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

