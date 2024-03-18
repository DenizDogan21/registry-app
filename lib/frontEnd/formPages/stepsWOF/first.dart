import 'package:flutter/material.dart';
import 'second.dart'; // Ensure this import points to your second page
import 'package:turboapp/frontEnd/widgets/helperMethodsInput.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';

class FirstStepPage extends StatefulWidget {
  final Map<String, dynamic> formData; // To hold form data across steps

  const FirstStepPage({Key? key, required this.formData}) : super(key: key);

  @override
  _FirstStepPageState createState() => _FirstStepPageState();
}

class _FirstStepPageState extends State<FirstStepPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? turboNo;
  DateTime? tarihWOF;
  String? aracBilgileri;
  int? aracKm;
  String? aracPlaka;

  int currentStep = 0;
  final int totalSteps = 6;

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      int? parsedValue = int.tryParse(aracKm.toString());
      if (parsedValue == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Uyarı'),
              content: Text('Araç kilometresi tam sayı olmalıdır.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Tamam'),
                ),
              ],
            );
          },
        );
      } else {
        // Add the values to formData map
        widget.formData['turboNo'] = turboNo;
        widget.formData['tarihWOF'] = tarihWOF;
        widget.formData['aracBilgileri'] = aracBilgileri;
        widget.formData['aracKm'] = aracKm;
        widget.formData['aracPlaka'] = aracPlaka;
        // Navigate to the second step
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SecondStepPage(formData: widget.formData),
        ));
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      appBar: appBar(context, "Araç ve Turbo Kaydı"),
      bottomNavigationBar: bottomNav(context),
      body: Stack(
        children: [
          background(context),
          SingleChildScrollView(
            padding: EdgeInsets.all(isTablet ? 100 : 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      totalSteps,
                          (index) => buildStepDot(isSelected: index == currentStep),
                    ),
                  ),
                  SizedBox(height: 20),
                  buildDatePickerFormField(
                    context: context,
                    labelText: 'İş Emri Tarihi',
                    errorText: 'Tarih girin',
                    onSave: (DateTime value) {
                      tarihWOF = value;
                    },
                    isTablet: isTablet,
                  ),
                  SizedBox(height: 20),
                  buildTextFormField(
                    labelText: 'Turbo No',
                    errorText: 'Lütfen turbo no girin',
                    onSave: (value) => turboNo = value,
                    isTablet: isTablet, // Pass the isTablet value
                  ),
                  SizedBox(height: 20),
                  buildTextFormField(
                    labelText: 'Araç Bilgileri',
                    errorText: 'Lütfen araç bilgisi girin',
                    onSave: (value) => aracBilgileri = value,
                    isTablet: isTablet, // Pass the isTablet value
                  ),
                  SizedBox(height: 20),
                  buildTextFormField(
                    labelText: 'Araç Km',
                    errorText: 'Lütfen araç km si girin',
                    onSave: (value) => aracKm = int.tryParse(value!),
                    keyboardType: TextInputType.number,
                    isTablet: isTablet, // Pass the isTablet value
                  ),
                  SizedBox(height: 20),
                  buildTextFormField(
                    labelText: 'Araç Plakası',
                    errorText: 'Lütfen araç plakası girin',
                    onSave: (value) => aracPlaka = value,
                    isTablet: isTablet, // Pass the isTablet value
                  ),
                  SizedBox(height: 20), // Spacing
                  Row(mainAxisAlignment:MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveAndContinue,
                          child: Text(
                            'Devam',
                            style: TextStyle(fontSize: isTablet ? 30 : 16, fontWeight: FontWeight.bold, color: Colors.black), // Text styling
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
                      ]
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}