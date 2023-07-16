import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turboapp/frontEnd/form/input.dart';
import 'package:turboapp/service/auth_service.dart';
import 'package:turboapp/frontEnd/utils/customColors.dart';
import 'package:turboapp/frontEnd/utils/customTextStyle.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String email, fullname, username, password;
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    String topImage = "assets/images/topImage.png";
    return Scaffold(
      body: Stack(children:[
        background(context),
        appBody(height, topImage),
      ]
      ),
    );
  }

  SingleChildScrollView appBody(double height, String topImage) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topImageContainer(height, topImage),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleText(),
                    customSizedBox(),
                    emailTextField(),
                    customSizedBox(),
                    fullNameTextField(),
                    customSizedBox(),
                    usernameTextField(),
                    customSizedBox(),
                    passwordTextField(),
                    customSizedBox(),
                    signUpButton(),
                    customSizedBox(),
                    backToLoginPage()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Text titleText() {
    return Text(
      "Merhaba, \nHoşgeldin",
      style: CustomTextStyle.titleTextStyle,
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        } else {}
      },
      onSaved: (value) {
        email = value!;
      },
      style: TextStyle(color: Colors.white),
      decoration: customInputDecoration("Email"),
    );
  }

  TextFormField fullNameTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        } else {}
      },
      onSaved: (value) {
        fullname = value!;
      },
      style: TextStyle(color: Colors.white),
      decoration: customInputDecoration("Ad Soyad"),
    );
  }

  TextFormField usernameTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        } else {}
      },
      onSaved: (value) {
        username = value!;
      },
      style: TextStyle(color: Colors.white),
      decoration: customInputDecoration("Kullanıcı Adı"),
    );
  }

  TextFormField passwordTextField() {
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
      style: TextStyle(color: Colors.white),
      decoration: customInputDecoration("Şifre"),
    );
  }

  Center signUpButton() {
    return Center(
      child: TextButton(
        onPressed: signUp,
        child: Container(
          height: 50,
          width: 150,
          margin: EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xff31274F)),
          child: Center(
            child: customText("Hesap Oluştur", CustomColors.loginButtonTextColor),
          ),
        ),
      ),
    );
  }


  Center backToLoginPage() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, "/loginPage"),
        child: customText(
          "Giriş Sayfasına Geri Dön",
          CustomColors.pinkColor,
        ),
      ),
    );
  }

  Container topImageContainer(double height, String topImage) {
    return Container(
      height: height * .25,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(topImage),
        ),
      ),
    );
  }

  Widget customSizedBox() => SizedBox(
    height: 20,
  );

  Widget customText(String text, Color color) => Text(
    text,
    style: TextStyle(color: color),
  );

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
  }

  void signUp() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      final result =
      await authService.signUp(email, fullname, password);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => InputPage()),
              (route) => false);
    } else {}
  }
}