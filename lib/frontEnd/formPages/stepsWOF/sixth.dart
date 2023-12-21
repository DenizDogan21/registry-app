import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turboapp/backEnd/models/accountingForm_model.dart';
import 'package:turboapp/backEnd/repositories/accountingForm_repo.dart';
import '../../../backEnd/models/inProgressForm_model.dart';
import '../../../backEnd/repositories/workOrderForm_repo.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';
import 'package:turboapp/backEnd/repositories/inProgressForm_repo.dart';

import 'package:turboapp/backEnd/models/workOrderForm_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/helperMethodsInput.dart';

class SixthStepPage extends StatefulWidget {
  final Map<String, dynamic> formData; // To hold form data across steps

  const SixthStepPage({Key? key, required this.formData}) : super(key: key);

  @override
  _SixthStepPageState createState() => _SixthStepPageState();
}

class _SixthStepPageState extends State<SixthStepPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _workOrderFormRepo = WorkOrderFormRepo.instance;
  final _inProgressFormRepo = InProgressFormRepo.instance;
  final _accountingFormRepo = AccountingFormRepo.instance;


  final List<String> deliveryOptions = ['atölyemiz teslim', 'kurye', 'kargo', 'elden'];
  final List<String> shippingOptions = ['MNG', 'Aras', 'Yurtiçi', 'Sürat', 'Ptt', 'Diğer'];
  final List<String> kabulDurumuOptions = ['kabul edildi', 'bekliyor', 'reddedildi'];


  String? turboNo;
  DateTime? tarihWOF;
  String? aracBilgileri;
  int? aracKm;
  String? aracPlaka;
  String? musteriAdi;
  int? musteriNumarasi;
  String? musteriSikayetleri;
  String? onTespit;
  double? tasimaUcreti;
  String? teslimAdresi;
  String? turboyuGetiren;
  String? shippingOption; // For the second dropdown
  String? kabulDurumu;

  int currentStep = 5;
  final int totalSteps = 6;



  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final workOrderForm = WorkOrderFormModel(
        turboNo: widget.formData['turboNo'] ?? "",
        tarihWOF: widget.formData['tarihWOF'] ?? DateTime.now(),
        // Assuming you store DateTime objects in formData
        aracBilgileri: widget.formData['aracBilgileri'] ?? "",
        aracKm: widget.formData['aracKm'] ?? -1,
        aracPlaka: widget.formData['aracPlaka'] ??"",
        musteriAdi: widget.formData['musteriAdi'] ?? "",
        musteriNumarasi: widget.formData['musteriNumarasi'] ?? -1,
        // Assuming it's an int
        musteriSikayetleri: widget.formData['musteriSikayetleri'] ?? "",
        onTespit: widget.formData['onTespit'] ?? "",
        turboyuGetiren: widget.formData['turboyuGetiren'],
        tasimaUcreti: widget.formData['tasimaUcreti'] ?? -1,
        // Assuming it's a double
        teslimAdresi: widget.formData['teslimAdresi'] ?? "",
        yanindaGelenler: widget.formData['yanindaGelenler'] ?? {},
        kabulDurumu: kabulDurumu ?? "",
      );



      // Concatenate turboyuGetiren and shippingOption if turboyuGetiren is 'kargo'
      if (turboyuGetiren == 'kargo' && shippingOption != null) {
        turboyuGetiren = "$turboyuGetiren, $shippingOption";
      }


      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (kabulDurumu == 'kabul edildi') {
          int egeTurboNo = await getAndUpdateEgeTurboNo();
          // Create an instance for inProgressForms with data from workOrderForm
          final inProgressForm = InProgressFormModel(
            // Assigning values from workOrderForm to the corresponding fields in inProgressForm
            tarihIPF: DateTime.now(), // Assuming you want to set the current date for inProgressForm
            turboNo: workOrderForm.turboNo,
            egeTurboNo: egeTurboNo,
            tarihWOF: workOrderForm.tarihWOF, // Assuming you store DateTime objects in formData
            aracBilgileri: workOrderForm.aracBilgileri,
            aracKm: workOrderForm.aracKm,
            aracPlaka: workOrderForm.aracPlaka,
            musteriAdi: workOrderForm.musteriAdi,
            musteriNumarasi: workOrderForm.musteriNumarasi, // Assuming it's an int
            musteriSikayetleri: workOrderForm.musteriSikayetleri,
            onTespit: workOrderForm.onTespit,
            turboyuGetiren: workOrderForm.turboyuGetiren,
            tasimaUcreti: workOrderForm.tasimaUcreti, // Assuming it's a double
            teslimAdresi: workOrderForm.teslimAdresi,
            yanindaGelenler: workOrderForm.yanindaGelenler,
          );

          final accountingForm = AccountingFormModel(
            tarihIPF: inProgressForm.tarihIPF,
            turboNo: workOrderForm.turboNo,
            egeTurboNo: inProgressForm.egeTurboNo,
            tarihWOF: workOrderForm.tarihWOF, // Assuming you store DateTime objects in formData
            aracBilgileri: workOrderForm.aracBilgileri,
            aracKm: workOrderForm.aracKm,
            aracPlaka: workOrderForm.aracPlaka,
            musteriAdi: workOrderForm.musteriAdi,
            musteriNumarasi: workOrderForm.musteriNumarasi, // Assuming it's an int
            musteriSikayetleri: workOrderForm.musteriSikayetleri,
            onTespit: workOrderForm.onTespit,
            turboyuGetiren: workOrderForm.turboyuGetiren,
            tasimaUcreti: workOrderForm.tasimaUcreti, // Assuming it's a double
            teslimAdresi: workOrderForm.teslimAdresi,
            yanindaGelenler: workOrderForm.yanindaGelenler,
            kabulDurumu: workOrderForm.kabulDurumu,
          );

          // Save inProgressForm to your database or backend
          _accountingFormRepo.createAccountingForm(accountingForm);
          _inProgressFormRepo.createInProgressForm(inProgressForm);
        } else {
          // Create the form
          _workOrderFormRepo.createWorkOrderForm(workOrderForm);
        }


          // Reset the form fields
          setState(() {
            _formKey.currentState!.reset();
            kabulDurumu = null;
          });

      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "  Kabul Durumu"),
      bottomNavigationBar: bottomNav(),
      body: Stack(children: [
        background(context),
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalSteps, (index) =>
                        buildStepDot(isSelected: index == currentStep))),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: kabulDurumu,
                  onChanged: (newValue) {
                    setState(() {
                      kabulDurumu = newValue;
                    });
                  },
                  items: kabulDurumuOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Kabul Durumu',
                    border: OutlineInputBorder(),
                  ),
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