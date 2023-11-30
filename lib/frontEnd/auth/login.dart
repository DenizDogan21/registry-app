import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:turboapp/service/auth_service.dart';
import 'package:turboapp/frontEnd/utils/customColors.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';

import '../formPages/stepsWOF/first.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '', password = '';
  bool rememberMe = false;
  final formkey = GlobalKey<FormState>();
  final authService = AuthService();
  final secureStorage = FlutterSecureStorage();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Widget rememberMeCheckbox() {
    return Padding(padding: EdgeInsets.only(left: 115), child:
    Row(
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: (bool? value) {
            setState(() {
              rememberMe = value!;
            });
          },
        ),
        Text("Beni hatırla", style: TextStyle(color: Colors.white)),
      ],
    )
    );
  }



  @override
  void initState() {
    super.initState();
    autoFillCredentials();
  }

  void autoFillCredentials() async {
    String? savedEmail = await secureStorage.read(key: 'email');
    String? savedPassword = await secureStorage.read(key: 'password');

    if (savedEmail != null && savedPassword != null) {
      setState(() {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
        rememberMe = true;
      });
    }
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    String logo = "assets/images/logo.png";
    return Scaffold(
      body: Stack(
        children: [
          background(context),
          appBody(height, logo),
        ],
      ),
    );
  }

  SingleChildScrollView appBody(double height, String logo) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            logoContainer(height, logo),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 75,),
                    emailTextField(),
                    customSizedBox(),
                    passwordTextField(),
                    customSizedBox(),
                    customSizedBox(),
                    forgotPasswordButton(),
                    rememberMeCheckbox(),
                    customSizedBox(),
                    signInButton(),
                    customSizedBox(),
                    CustomTextButton(
                      onPressed: () => Navigator.pushNamed(context, "/signUp"),
                      buttonText: "Hesap Oluştur",
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  TextFormField emailTextField() {
    return TextFormField(
      controller: emailController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        }
      },
      onSaved: (value) {
        email = value!;
      },
      style: TextStyle(color: Colors.white),
      decoration: customInputDecoration("Email"),
    );
  }

  TextFormField passwordTextField() {
    return TextFormField(
      controller: passwordController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        }
      },
      onSaved: (value) {
        password = value!;
      },
      obscureText: true,
      style: TextStyle(color: Colors.white),
      decoration: customInputDecoration("Şifre"),
    );
  }

  Center forgotPasswordButton() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, "/forgotPassword"),
        child: customText(
          "Şifremi Unuttum",
          CustomColors.pinkColor,
        ),
      ),
    );
  }


  Center signInButton() {
    return Center(
      child: TextButton(
        onPressed: signIn,
        child: Container(
          height: 50,
          width: 150,
          margin: EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Color(0xff31274F),
          ),
          child: Center(
            child: customText(
              "Giriş Yap",
              CustomColors.loginButtonTextColor,
            ),
          ),
        ),
      ),
    );
  }

  Center signUpButton() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, "/signUp"),
        child: customText(
          "Hesap Oluştur",
          CustomColors.pinkColor,
        ),
      ),
    );
  }

  Container logoContainer(double height, String logo) {
    return Container(
      height: height * .25,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(logo),
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



  void signIn() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();

      final result = await authService.signIn(email, password);

      if (result == "success") {
        if (rememberMe) {
          await secureStorage.write(key: 'email', value: email);
          await secureStorage.write(key: 'password', value: password);
        }

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => FirstStepPage(formData: {})),
              (route) => false,
        );
      }else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Hata"),
              content: Text(result!),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Geri Dön"),
                )
              ],
            );
          },
        );
      }
    }
  }
}
