import 'package:flutter/material.dart';
import 'empty_form.dart';
import 'filled_forms.dart';


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
        // Navigate to "kampüs" page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EmptyFormPage()),
          );
          break;
        case 1:
        // Navigate to "kamera" page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FilledFormsPage()),);
          break;
        case 2:
          break;
      }
    },
  );
}