import 'package:flutter/material.dart';
import 'package:turboapp/frontEnd/formPages/stepsWOF/sixth.dart';
import '../../widgets/helperMethodsInput.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';

class FifthStepPage extends StatefulWidget {
  final Map<String, dynamic> formData; // To hold form data across steps

  const FifthStepPage({Key? key, required this.formData}) : super(key: key);

  @override
  _FifthStepPageState createState() => _FifthStepPageState();
}

class _FifthStepPageState extends State<FifthStepPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  final List<String> deliveryOptions = ['atölyemiz teslim', 'kurye', 'kargo', 'elden'];
  final List<String> shippingOptions = ['MNG', 'Aras', 'Yurtiçi', 'Sürat', 'Ptt', 'Diğer'];
  double? tasimaUcreti;
  String? teslimAdresi;
  String? turboyuGetiren;
  String? shippingOption; // For the second dropdown

  int currentStep = 4;
  final int totalSteps = 6;


  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {

      if (turboyuGetiren == 'kargo' && shippingOption != null) {
        turboyuGetiren = "$turboyuGetiren, $shippingOption";
      }


      _formKey.currentState!.save();
      widget.formData['turboyuGetiren'] = turboyuGetiren;
      widget.formData['tasimaUcreti'] = tasimaUcreti;
      widget.formData['teslimAdresi'] = teslimAdresi;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SixthStepPage(formData: widget.formData),
      ));
    }
  }


  Widget _buildDeliveryDropdown(bool isTablet) {
    return DropdownButtonFormField<String>(
      value: turboyuGetiren,
      onChanged: (newValue) {
        setState(() {
          turboyuGetiren = newValue;
          if (newValue != 'kargo') {
            shippingOption = null; // Reset shipping option if not 'kargo'
          }
        });
      },
      items: deliveryOptions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Turboyu Getiren',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: isTablet ? 20 : 10, // Adjust vertical padding based on tablet or not
        ),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Lütfen bir değer seçin';
        return null;
      },
    );
  }

  Widget _buildShippingDropdown(bool isTablet) {
    return Visibility(
      visible: turboyuGetiren == 'kargo',
      child: DropdownButtonFormField<String>(
        value: shippingOption,
        onChanged: (newValue) {
          setState(() {
            shippingOption = newValue;
          });
        },
        items: shippingOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: 'Kargo Şirketi',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: isTablet ? 20 : 10, // Adjust vertical padding based on tablet or not
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    return Scaffold(
      appBar: appBar(context, "Teslim ve Taşıma"),
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
              _buildDeliveryDropdown(isTablet),
              SizedBox(height: 20,),
              _buildShippingDropdown(isTablet),
              SizedBox(height: 20,),
              buildTextFormField(
                labelText: 'Taşıma Ücreti',
                errorText: 'Lütfen taşıma ücreti girin',
                onSave: (value) => tasimaUcreti = double.tryParse(value!),
                keyboardType: TextInputType.number,
                isTablet: isTablet,
              ),
              SizedBox(height: 20,),
              buildTextFormField(
                labelText: 'Teslim Adresi',
                errorText: 'Lütfen teslim adresi girin',
                onSave: (value) => teslimAdresi = value,
                isTablet: isTablet,
              ),
              SizedBox(height: 30,),
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
      ),]),
    );
  }
}