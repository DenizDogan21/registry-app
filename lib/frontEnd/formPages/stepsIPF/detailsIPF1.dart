import 'package:flutter/material.dart';
import 'package:turboapp/backEnd/models/inProgressForm_model.dart';
import 'package:turboapp/backEnd/repositories/accountingForm_repo.dart';
import 'package:turboapp/frontEnd/widgets/common.dart';
import 'package:turboapp/frontEnd/widgets/helperMethodsDetails.dart';
import 'package:turboapp/frontEnd/utils/customTextField.dart';

import '../../../backEnd/repositories/inProgressForm_repo.dart';
import 'detailsIPF2.dart';
import 'package:get/get.dart';

class DetailsIPF1 extends StatefulWidget {
  final InProgressFormModel formIPF;
  DetailsIPF1({required this.formIPF});

  @override
  _DetailsIPF1State createState() => _DetailsIPF1State();
}

class _DetailsIPF1State extends State<DetailsIPF1> {
  TextEditingController _controllerTarihWOF = TextEditingController();
  TextEditingController _controllerTarihIPF = TextEditingController();
  TextEditingController _controllerTurboNo = TextEditingController();
  TextEditingController _controllerYanindaGelenler = TextEditingController();
  TextEditingController _controllerAracBilgileri = TextEditingController();
  TextEditingController _controllerAracKm = TextEditingController();
  TextEditingController _controllerAracPlaka = TextEditingController();
  TextEditingController _controllerMusteriAdi = TextEditingController();
  TextEditingController _controllerMusteriNumarasi= TextEditingController();
  TextEditingController _controllerMusteriSikayetleri = TextEditingController();
  TextEditingController _controllerOnTespit = TextEditingController();
  TextEditingController _controllerTurboyuGetiren = TextEditingController();
  TextEditingController _controllerTasimaUcreti = TextEditingController();
  TextEditingController _controllerTeslimAdresi = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values from widget.formIPF
    _controllerTarihWOF.text = widget.formIPF.tarihWOF.toString();
    _controllerTarihIPF.text = widget.formIPF.tarihIPF.toString();
    _controllerTurboNo.text = widget.formIPF.turboNo;
    _controllerYanindaGelenler.text = getFriendlyTrueKeys(widget.formIPF.yanindaGelenler).join(', ');
    _controllerAracBilgileri.text = widget.formIPF.aracBilgileri;
    _controllerAracKm.text = widget.formIPF.aracKm.toString();
    _controllerAracPlaka.text = widget.formIPF.aracPlaka;
    _controllerMusteriAdi.text = widget.formIPF.musteriAdi;
    _controllerMusteriNumarasi.text = widget.formIPF.musteriNumarasi.toString();
    _controllerMusteriSikayetleri.text = widget.formIPF.musteriSikayetleri;
    _controllerOnTespit.text = widget.formIPF.onTespit;
    _controllerTurboyuGetiren.text = widget.formIPF.turboyuGetiren;
    _controllerTasimaUcreti.text = widget.formIPF.tasimaUcreti.toString();
    _controllerTeslimAdresi.text = widget.formIPF.teslimAdresi;
  }


  Map<String, bool> parseYanindaGelenlerForSave(String text) {
    Map<String, bool> result = {};
    var friendlyNamesList = text.split(', ');

    friendlyNames.forEach((key, friendlyName) {
      if (friendlyNamesList.contains(friendlyName)) {
        result[key] = true;
      } else {
        result[key] = false;
      }
    });

    return result;
  }

  List<String> getFriendlyTrueKeys(Map<String, bool> map) {
    return map.entries
        .where((entry) => entry.value)
        .map((entry) => friendlyNames[entry.key] ?? entry.key)
        .toList();
  }



  Future<void> _saveChanges() async {
    if (widget.formIPF.id == null) {
      Get.snackbar("Error", "Form numarası bulunamadı", backgroundColor: Colors.red);
      return;
    }
    widget.formIPF.tarihWOF = DateTime.parse(_controllerTarihWOF.text);
    widget.formIPF.tarihIPF = DateTime.parse(_controllerTarihIPF.text);
    widget.formIPF.turboNo = _controllerTurboNo.text;
    widget.formIPF.yanindaGelenler = parseYanindaGelenlerForSave(_controllerYanindaGelenler.text);
    widget.formIPF.aracBilgileri = _controllerAracBilgileri.text;
    widget.formIPF.aracKm = int.parse(_controllerAracKm.text);
    widget.formIPF.aracPlaka = _controllerAracPlaka.text;
    widget.formIPF.musteriAdi = _controllerMusteriAdi.text;
    widget.formIPF.musteriNumarasi = int.parse(_controllerMusteriNumarasi.text);
    widget.formIPF.musteriSikayetleri = _controllerMusteriSikayetleri.text;
    widget.formIPF.onTespit = _controllerOnTespit.text;
    widget.formIPF.turboyuGetiren = _controllerTurboyuGetiren.text;
    widget.formIPF.tasimaUcreti = double.parse(_controllerTasimaUcreti.text);
    widget.formIPF.teslimAdresi = _controllerTeslimAdresi.text;


    // Save the updated model to Firebase
    await InProgressFormRepo.instance.updateInProgressForm(widget.formIPF.id!, widget.formIPF);
    var accountingForm = await AccountingFormRepo.instance.getFormByEgeTurboNo(widget.formIPF.egeTurboNo);
    if (accountingForm != null) {
      accountingForm.tarihWOF = widget.formIPF.tarihWOF;
      accountingForm.aracBilgileri = widget.formIPF.aracBilgileri;
      accountingForm.aracKm = widget.formIPF.aracKm;
      accountingForm.aracPlaka = widget.formIPF.aracPlaka;
      accountingForm.musteriAdi = widget.formIPF.musteriAdi;
      accountingForm.musteriNumarasi = widget.formIPF.musteriNumarasi;
      accountingForm.musteriSikayetleri = widget.formIPF.musteriSikayetleri;
      accountingForm.onTespit = widget.formIPF.onTespit;
      accountingForm.turboyuGetiren = widget.formIPF.turboyuGetiren;
      accountingForm.tasimaUcreti = widget.formIPF.tasimaUcreti;
      accountingForm.teslimAdresi = widget.formIPF.teslimAdresi;
      accountingForm.turboNo = widget.formIPF.turboNo;
      accountingForm.yanindaGelenler = widget.formIPF.yanindaGelenler;
      accountingForm.tarihIPF = widget.formIPF.tarihIPF;


      // Save the updated accounting model to Firebase
      await AccountingFormRepo.instance.updateAccountingForm(accountingForm.id!, accountingForm);
    }


    // Navigate to the next page or go back
    // Logic to save changes to Firebase
    Navigator.of(context).pop(); // Close the dialog
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailsIPF2(formIPF: widget.formIPF)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Detaylar"),
      bottomNavigationBar: bottomNav(),
      body: SafeArea(
        child: Stack(
        children: [
          background(context),
          SingleChildScrollView( child:
          Column(
          children: [
            CustomTextField(
              controller: _controllerTarihWOF,
              label: 'Tarih WOF',
              keyboardType: TextInputType.datetime,
            ),
            CustomTextField(
              controller: _controllerTarihIPF,
              label: 'Tarih IPF',
              keyboardType: TextInputType.datetime,
            ),
            CustomTextField(
              controller: _controllerTurboNo,
              label: 'Turbo No',
            ),CustomTextField(
              controller: _controllerYanindaGelenler,
              label: 'Turboyla Gelenler'
              // ... other properties ...
            ),CustomTextField(
              controller: _controllerAracBilgileri,
              label: 'Araç Bilgileri',
              // ... other properties ...
            ),CustomTextField(
                controller: _controllerAracKm,
                label: 'Araç Km si'
              // ... other properties ...
            ),CustomTextField(
                controller: _controllerAracPlaka,
                label: 'Araç Plakası'
              // ... other properties ...
            ),CustomTextField(
              controller: _controllerMusteriAdi,
              label: 'Müşteri Adı',
              // ... other properties ...
            ),CustomTextField(
              controller: _controllerMusteriNumarasi,
              label: 'Müşteri Numarası'
              // ... other properties ...
            ),CustomTextField(
              controller: _controllerMusteriSikayetleri,
              label: 'Müşteri Şikayetleri',
              // ... other properties ...
            ),CustomTextField(
              controller: _controllerOnTespit,
              label: 'Ön Tespit',
              // ... other properties ...
            ),CustomTextField(
              controller: _controllerTurboyuGetiren,
              label: 'Turboyu Getiren',
            ),CustomTextField(
              controller: _controllerTasimaUcreti,
              label: 'Taşıma Ücreti',
              // ... other properties ...
            ),
            CustomTextField(
              controller: _controllerTeslimAdresi,
              label: 'Teslim Adresi',
              // ... other properties ...
            ),
            ElevatedButton(
              onPressed: () => showSaveAlertDialog(context, _saveChanges, DetailsIPF2(formIPF: widget.formIPF)),
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
        ),)])
      ),
    );
  }
}
