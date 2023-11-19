import 'package:flutter/material.dart';
import '../../widgets/common.dart';
import 'fifth.dart'; // Ensure this import points to your fifth page
import 'package:turboapp/frontEnd/widgets/helperMethodsInput.dart';

class FourthStepPage extends StatefulWidget {
  final Map<String, dynamic> formData; // To hold form data across steps

  const FourthStepPage({Key? key, required this.formData}) : super(key: key);

  @override
  _FourthStepPageState createState() => _FourthStepPageState();
}

class _FourthStepPageState extends State<FourthStepPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? onTespit;

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.formData['onTespit'] = onTespit;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FifthStepPage(formData: widget.formData),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "  Ön Tespit"),
      body: Stack(children: [
        background(context),
        SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextFormField(
                labelText: 'Ön Tespit',
                errorText: 'Lütfen ön tespiti girin',
                onSave: (value) => onTespit = value,
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: _saveAndContinue,
                child: Text(
                  'Devam',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black), // Text styling
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyanAccent, // Button color
                  onPrimary: Colors.black, // Text color when button is pressed
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),]),
    );
  }
}