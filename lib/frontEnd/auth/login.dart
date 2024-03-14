import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:turboapp/frontEnd/accountingPages/accountingAddShow.dart';
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
    return SafeArea(child: Scaffold(
      body: Stack(
        children: [
          background(context),
          SingleChildScrollView( child:
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                // Use a different layout for larger screens (tablets)
                return _buildTabletLayout();
              } else {
                // Use the existing layout for smaller screens
                return _buildMobileLayout();
              }
            },
          ),)
        ],
      ),),
    );
  }

  Widget _buildTabletLayout() {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            SizedBox(height: 100),
            _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            SizedBox(height: 30),
            _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/logo.png"),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildForm() {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 40:20),
      child: Form(
        key: formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isTablet ? SizedBox(height: 40):SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Bilgileri Eksiksiz Doldurunuz";
                }
              },
              onSaved: (value) {
                email = value!;
              },
              style: TextStyle(color: Colors.white, fontSize: isTablet ? 30:15),
              decoration: InputDecoration(
                hintText: "Email",
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
              ),
            ),
            isTablet ? SizedBox(height: 40):SizedBox(height: 20),
            TextFormField(
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
              style: TextStyle(color: Colors.white, fontSize: isTablet ? 30:15),
              decoration: InputDecoration(
                hintText: "Şifre",
                hintStyle: TextStyle(color: Colors.grey, fontSize: isTablet ? 30:15),
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
              ),
            ),
            isTablet ? SizedBox(height: 40):SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      rememberMe = value!;
                    });
                  },
                ),
                Text(
                  "Beni hatırla",
                  style: TextStyle(color: Colors.white,fontSize: isTablet ? 30:15),
                ),
              ],
            ),
            isTablet ? SizedBox(height: 80):SizedBox(height: 40),
            TextButton(
              onPressed: () => signIn(),
              child: Container(
                height: isTablet ?100:50,
                width: isTablet ?300:150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xff31274F),
                ),
                child: Center(
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(color: Colors.white,fontSize: isTablet ? 30:15),
                  ),
                ),
              ),
            ),
            isTablet ? SizedBox(height: 40):SizedBox(height: 20),
            CustomTextButton(
              onPressed: () => Navigator.pushNamed(context, "/signUp"),
              buttonText: "Hesap Oluştur",
              context: context,

            ),
            isTablet ? SizedBox(height: 20):SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, "/forgotPassword"),
              child: Text(
                "Şifremi Unuttum",
                style: TextStyle(color: CustomColors.pinkColor,fontSize: isTablet ? 30:15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signIn() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();

      final result = await authService.signIn(email, password);

      if (result == "success") {
        // Fetch the user role
        final userRole = await authService.getUserRole(email);

        if (rememberMe) {
          await secureStorage.write(key: 'email', value: email);
          await secureStorage.write(key: 'password', value: password);
        }

        if (userRole == "muhasebe") {
          // Navigate to the specific UI for "muhasebe" role
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AccountingAddShowPage(), // Replace with your actual page for the "muhasebe" role
          ));
        } else {
          // Navigate to the standard UI
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => FirstStepPage(formData: {})),
                (route) => false,
          );
        }
      } else {
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