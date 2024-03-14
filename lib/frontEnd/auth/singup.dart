import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turboapp/service/auth_service.dart';
import 'package:turboapp/frontEnd/utils/customColors.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';

import '../utils/customInputDecoration.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String email, fullname, role = "Teknik", password;
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String logo = "assets/images/logo.png";
    return Scaffold(
      body: Stack(
        children: [
          background(context),
          appBody(height, width, logo),
        ],
      ),
    );
  }

  SingleChildScrollView appBody(double height, double width, String logo) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            logoContainer(height, width, logo),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.075),
                    emailTextField(width),
                    customSizedBox(height),
                    fullNameTextField(width),
                    customSizedBox(height),
                    roleDropdownField(width),
                    customSizedBox(height),
                    passwordTextField(width),
                    customSizedBox(height),
                    signUpButton(width,height),
                    customSizedBox(height),
                    backToLoginPage(width),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextFormField emailTextField(double width) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        } else {}
      },
      onSaved: (value) {
        email = value!;
      },
      style: TextStyle(color: Colors.white, fontSize: width * 0.04),
      decoration: customInputDecoration("Email"),
    );
  }

  TextFormField fullNameTextField(double width) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        } else {}
      },
      onSaved: (value) {
        fullname = value!;
      },
      style: TextStyle(color: Colors.white, fontSize: width * 0.04),
      decoration: customInputDecoration("Ad Soyad"),
    );
  }

  DropdownButtonFormField<String> roleDropdownField(double width) {
    return DropdownButtonFormField<String>(
      value: role, // Make sure 'role' is initialized properly
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        }
        return null;
      },
      onChanged: (String? newValue) {
        setState(() {
          role = newValue!;
        });
      },
      style: TextStyle(color: Colors.white, fontSize: width * 0.04),
      decoration: customDropdownDecoration("Görev"),
      dropdownColor: Colors.grey[800],
      items: <String>['Muhasebe', 'Teknik']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(color: Colors.white, fontSize: width * 0.04)),
        );
      }).toList(),
    );
  }

  TextFormField passwordTextField(double width) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        } else {}
      },
      onSaved: (value) {
        password = value!;
      },
      obscureText: true,
      style: TextStyle(color: Colors.white, fontSize: width * 0.04),
      decoration: customInputDecoration("Şifre"),
    );
  }

  Center signUpButton(double width, double height) {
    return Center(
      child: TextButton(
        onPressed: signUp,
        child: Container(
          height: height * 0.08,
          width: width * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Color(0xff31274F),
          ),
          child: Center(
            child: customText("Hesap Oluştur", CustomColors.loginButtonTextColor, fontSize: width * 0.04),
          ),
        ),
      ),
    );
  }

  Center backToLoginPage(double width) {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, "/login"),
        child: customText(
          "Giriş Sayfasına Geri Dön",
          CustomColors.pinkColor,
          fontSize: width * 0.04,
        ),
      ),
    );
  }

  Container logoContainer(double height, double width, String logo) {
    return Container(
      height: height * .25,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(logo),
        ),
      ),
    );
  }

  Widget customSizedBox(double height) => SizedBox(height: height * 0.04);

  Widget customText(String text, Color color, {double fontSize = 16}) => Text(
    text,
    style: TextStyle(color: color, fontSize: fontSize),
  );

  void signUp() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();

      if (email.endsWith("@egeturbo.com")) {
        try {
          await authService.signUp(email, fullname, role, password);

          // Send email verification link
          User? user = firebaseAuth.currentUser;
          await user?.sendEmailVerification();

          // Show a message to the user
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Doğrulama Maili Gönderildi'),
                content: Text(
                  'Doğrulama maili $email adresine yollandı. Posta kutunuzu kontrol edin ve bağlantıdaki linke tıklayarak mailinizi doğrulayın.',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );

          // Redirect to a page that informs the user to check their email
        } catch (error) {
          // Handle any errors that occur during signup
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Signup Error'),
                content: Text('An error occurred during signup. Please try again later.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Invalid email address, show an error or alert the user
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Kaydolma Başarısız'),
              content: Text('Sadece Ege Turbo çalışanları kayıt olabilir.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}