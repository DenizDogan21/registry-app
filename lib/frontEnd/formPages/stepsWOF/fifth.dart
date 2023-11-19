import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../BackEnd/Models/workOrderForm_model.dart';
import '../../../BackEnd/Repositories/workOrderForm_repo.dart';
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
  final _workOrderFormRepo = WorkOrderFormRepo.instance;

  bool _isSubmitted = false;

  final List<String> deliveryOptions = ['atölyemiz teslim', 'kurye', 'kargo', 'elden'];
  final List<String> shippingOptions = ['MNG', 'Aras', 'Yurtiçi', 'Sürat', 'Ptt', 'Diğer'];


  String? turboNo;
  DateTime? tarihWOF;
  String? aracBilgileri;
  String? musteriAdi;
  int? musteriNumarasi;
  String? musteriSikayetleri;
  String? onTespit;
  double? tasimaUcreti;
  String? teslimAdresi;
  String? turboyuGetiren;
  String? shippingOption; // For the second dropdown


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Concatenate turboyuGetiren and shippingOption if turboyuGetiren is 'kargo'
      String finalTurboyuGetiren = turboyuGetiren ?? "";
      if (turboyuGetiren == 'kargo' && shippingOption != null) {
        finalTurboyuGetiren = "$turboyuGetiren, $shippingOption";
      }


      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {

        // Create an instance of workOrderFormModel with the entered data
        final workOrderForm = WorkOrderFormModel(
          turboNo: widget.formData['turboNo'] ?? "",
          tarihWOF: widget.formData['tarihWOF'] ?? DateTime.now(), // Assuming you store DateTime objects in formData
          aracBilgileri: widget.formData['aracBilgileri'] ?? "",
          musteriAdi: widget.formData['musteriAdi'] ?? "",
          musteriNumarasi: widget.formData['musteriNumarasi'] ?? 0, // Assuming it's an int
          musteriSikayetleri: widget.formData['musteriSikayetleri'] ?? "",
          onTespit: widget.formData['onTespit'] ?? "",
          turboyuGetiren: finalTurboyuGetiren,
          tasimaUcreti: tasimaUcreti ?? 0.0, // Assuming it's a double
          teslimAdresi: teslimAdresi ?? "",
          yanindaGelenler: widget.formData['yanindaGelenler'] ?? {},
        );

        // Create the form
        _workOrderFormRepo.createWorkOrderForm(workOrderForm);

        // Reset the form fields
        setState(() {
          _formKey.currentState!.reset();
          turboyuGetiren = null;
          shippingOption = null;
        });

      }
    }
  }





  Widget _buildDeliveryDropdown() {
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
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Lütfen bir değer seçin';
        return null;
      },
    );
  }

  Widget _buildShippingDropdown() {
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
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "  Teslim ve Taşıma"),
      bottomNavigationBar: bottomNav(),
      body: Stack(children: [
        background(context),
        SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildDeliveryDropdown(),
              SizedBox(height: 20,),
              _buildShippingDropdown(),
              SizedBox(height: 20,),
              buildTextFormField(
                labelText: 'Taşıma Ücreti',
                errorText: 'Lütfen taşıma ücreti girin',
                onSave: (value) => tasimaUcreti = double.tryParse(value!),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20,),
              buildTextFormField(
                labelText: 'Teslim Adresi',
                errorText: 'Lütfen teslim adresi girin',
                onSave: (value) => teslimAdresi = value,
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  'Gönder',
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