import 'package:flutter/material.dart';
import 'FrontEnd/Forms/empty_form.dart';
import 'FrontEnd/Forms/filled_forms.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Form App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => EmptyFormPage(),
        '/filled_forms': (context) => FilledFormsPage(),
      },
    );
  }
}
