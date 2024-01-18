import 'package:flutter/material.dart';
import 'package:turboapp/service/auth_service.dart';
import 'package:turboapp/frontEnd/utils/customColors.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';
import 'package:turboapp/frontEnd/utils/customTextStyle.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final authService = AuthService();
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Şifre Sıfırlama"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Şifrenizi sıfırlamak için e-posta adresinizi girin", textAlign: TextAlign.center, style: CustomTextStyle.orangeTextStyle),
              SizedBox(height: 20),
              emailTextField(),
              SizedBox(height: 20),
              resetPasswordButton(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      onSaved: (value) => email = value!,
      validator: (value) {
        if (value == null || value.isEmpty || !value.contains('@')) {
          return 'Lütfen geçerli bir e-posta adresi girin';
        }
        return null;
      },
      decoration: customInputDecoration("E-posta"),
    );
  }

  ElevatedButton resetPasswordButton() {
    return ElevatedButton(
      onPressed: resetPassword,
      child: Text('Şifre Sıfırla'),
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
      ),
    );
  }

  void resetPassword() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // Call your AuthService to handle password reset.
      await authService.sendPasswordResetEmail(email);
      // Show a confirmation dialog/snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şifre sıfırlama bağlantısı e-postanıza gönderildi.')),
      );
    }
  }

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
