import 'package:flutter/material.dart';
import 'third.dart'; // Ensure this import points to your third page
import 'package:turboapp/frontEnd/widgets/helperMethodsInput.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';

class SecondStepPage extends StatefulWidget {
  final Map<String, dynamic> formData; // To hold form data across steps

  const SecondStepPage({Key? key, required this.formData}) : super(key: key);

  @override
  _SecondStepPageState createState() => _SecondStepPageState();
}

class _SecondStepPageState extends State<SecondStepPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? musteriAdi;
  int? musteriNumarasi;
  String? musteriSikayetleri;

  int currentStep = 1;
  final int totalSteps = 6;

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Add the values to formData map
      widget.formData['musteriAdi'] = musteriAdi;
      widget.formData['musteriNumarasi'] = musteriNumarasi;
      widget.formData['musteriSikayetleri'] = musteriSikayetleri;
      // Navigate to the third step
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ThirdStepPage(formData: widget.formData),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      appBar: appBar(context, "Müşteri Bilgileri"),
        bottomNavigationBar: bottomNav(context),
      body: Stack(children: [
        background(context),
        SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? 100 : 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(totalSteps, (index) =>
                      buildStepDot(isSelected: index == currentStep))),
              SizedBox(height: 20),
              buildTextFormField(
                labelText: 'Müşteri Ad Soyad',
                errorText: 'Lütfen müşteri adı girin',
                onSave: (value) => musteriAdi = value,
                isTablet: isTablet,
              ),
              SizedBox(height: 20,),
              buildTextFormField(
                labelText: 'Müşteri Numarası',
                errorText: 'Lütfen müşteri numarası girin',
                onSave: (value) => musteriNumarasi = int.tryParse(value!),
                keyboardType: TextInputType.number,
                maxLength: 11,
                isTablet: isTablet,
              ),
              SizedBox(height: 20,),
              buildTextFormField(
                labelText: 'Müşteri Şikayetleri',
                errorText: 'Lütfen müşteri şikayeti girin',
                onSave: (value) => musteriSikayetleri = value,
                isTablet: isTablet,
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: _saveAndContinue,
                child: Text(
                  'Devam',
                  style: TextStyle(fontSize: isTablet ? 30 : 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyanAccent, // Button color
                  onPrimary: Colors.black, // Text color when button is pressed
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: isTablet ? 20 : 15),
                ),
              ),
            ],
          ),
        ),
      ),])
    );
  }
}