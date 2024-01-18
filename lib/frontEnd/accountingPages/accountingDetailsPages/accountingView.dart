import 'package:flutter/material.dart';
import 'package:turboapp/backEnd/repositories/accountingForm_repo.dart';
import 'package:turboapp/backEnd/repositories/inProgressForm_repo.dart';
import 'package:turboapp/frontEnd/utils/customTextField.dart';
import 'package:turboapp/frontEnd/widgets/helperMethodsDetails.dart';

import '../../../backEnd/models/accountingForm_model.dart';
import '../../widgets/helperMethodsAccounting.dart';
import 'package:turboapp/frontEnd/accountingPages/accountingDetailsPages/accountingRating.dart';

class AccountingViewPage extends StatefulWidget {
  final AccountingFormModel formAF;

  AccountingViewPage({required this.formAF});

  @override
  _AccountingViewPageState createState() => _AccountingViewPageState();
}

class _AccountingViewPageState extends State<AccountingViewPage> {
  TextEditingController _controllerTarihWOF = TextEditingController();
  TextEditingController _controllerEgeTurboNo = TextEditingController();
  TextEditingController _controllerTurboNo = TextEditingController();
  TextEditingController _controllerAracBilgileri = TextEditingController();
  TextEditingController _controllerAracKm = TextEditingController();
  TextEditingController _controllerAracPlaka = TextEditingController();
  TextEditingController _controllerMusteriAdi = TextEditingController();
  TextEditingController _controllerMusteriNumarasi = TextEditingController();
  TextEditingController _controllerMusteriSikayetleri = TextEditingController();
  TextEditingController _controllerYanindaGelenler = TextEditingController();
  TextEditingController _controllerOnTespit = TextEditingController();
  TextEditingController _controllerTurboyuGetiren = TextEditingController();
  TextEditingController _controllerTasimaUcreti = TextEditingController();
  TextEditingController _controllerTeslimAdresi = TextEditingController();
  TextEditingController _controllerTarihIPF = TextEditingController();
  TextEditingController _controllerTespitEdilen = TextEditingController();
  TextEditingController _controllerYapilanIslemler = TextEditingController();

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with initial values from widget.formAF
    _controllerTarihWOF.text = widget.formAF.tarihWOF.toString();
    _controllerEgeTurboNo.text = widget.formAF.egeTurboNo.toString();
    _controllerTurboNo.text = widget.formAF.turboNo;
    _controllerAracBilgileri.text = widget.formAF.aracBilgileri;
    _controllerAracKm.text = widget.formAF.aracKm.toString();
    _controllerAracPlaka.text = widget.formAF.aracPlaka;
    _controllerMusteriAdi.text = widget.formAF.musteriAdi;
    _controllerMusteriNumarasi.text = widget.formAF.musteriNumarasi.toString();
    _controllerMusteriSikayetleri.text = widget.formAF.musteriSikayetleri;
    _controllerYanindaGelenler.text = getFriendlyTrueKeys(widget.formAF.yanindaGelenler).join(', ');
    _controllerOnTespit.text = widget.formAF.onTespit;
    _controllerTurboyuGetiren.text = widget.formAF.turboyuGetiren;
    _controllerTasimaUcreti.text = widget.formAF.tasimaUcreti.toString();
    _controllerTeslimAdresi.text = widget.formAF.teslimAdresi;
    _controllerTarihIPF.text = widget.formAF.tarihIPF.toString();
    _controllerTespitEdilen.text = widget.formAF.tespitEdilen;
    _controllerYapilanIslemler.text = widget.formAF.yapilanIslemler;

    // Listen to changes in text fields to determine if there are any modifications
    _controllerTarihWOF.addListener(_onTextChanged);
    _controllerEgeTurboNo.addListener(_onTextChanged);
    _controllerTurboNo.addListener(_onTextChanged);
    _controllerAracBilgileri.addListener(_onTextChanged);
    _controllerAracKm.addListener(_onTextChanged);
    _controllerAracPlaka.addListener(_onTextChanged);
    _controllerMusteriAdi.addListener(_onTextChanged);
    _controllerMusteriNumarasi.addListener(_onTextChanged);
    _controllerMusteriSikayetleri.addListener(_onTextChanged);
    _controllerYanindaGelenler.addListener(_onTextChanged);
    _controllerOnTespit.addListener(_onTextChanged);
    _controllerTurboyuGetiren.addListener(_onTextChanged);
    _controllerTasimaUcreti.addListener(_onTextChanged);
    _controllerTeslimAdresi.addListener(_onTextChanged);
    _controllerTarihIPF.addListener(_onTextChanged);
    _controllerTespitEdilen.addListener(_onTextChanged);
    _controllerYapilanIslemler.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // Check if the current values are different from the initial values
    bool hasChanges =
        _controllerTarihWOF.text != widget.formAF.tarihWOF.toString() ||
        _controllerEgeTurboNo.text != widget.formAF.egeTurboNo.toString() ||
        _controllerTurboNo.text != widget.formAF.turboNo ||
        _controllerAracBilgileri.text != widget.formAF.aracBilgileri ||
        _controllerAracKm.text != widget.formAF.aracKm.toString() ||
        _controllerAracPlaka.text != widget.formAF.aracPlaka ||
        _controllerMusteriAdi.text != widget.formAF.musteriAdi ||
        _controllerMusteriNumarasi.text != widget.formAF.musteriNumarasi.toString() ||
        _controllerMusteriSikayetleri.text != widget.formAF.musteriSikayetleri ||
        _controllerYanindaGelenler.text != widget.formAF.yanindaGelenler ||
        _controllerOnTespit.text != widget.formAF.onTespit ||
        _controllerTurboyuGetiren.text != widget.formAF.turboyuGetiren ||
        _controllerTasimaUcreti.text != widget.formAF.tasimaUcreti.toString() ||
        _controllerTeslimAdresi.text != widget.formAF.teslimAdresi ||
        _controllerTarihIPF.text != widget.formAF.tarihIPF.toString() ||
        _controllerTespitEdilen.text != widget.formAF.tespitEdilen ||
        _controllerYapilanIslemler.text != widget.formAF.yapilanIslemler;

    // Update the _hasChanges variable
    setState(() {
      _hasChanges = hasChanges;
    });
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
    // Check if there are any changes before saving
    if (_hasChanges) {
      widget.formAF.tarihWOF = DateTime.parse(_controllerTarihWOF.text);
      widget.formAF.turboNo = _controllerTurboNo.text;
      widget.formAF.aracBilgileri = _controllerAracBilgileri.text;
      widget.formAF.aracKm = int.parse(_controllerAracKm.text);
      widget.formAF.aracPlaka = _controllerAracPlaka.text;
      widget.formAF.musteriAdi = _controllerMusteriAdi.text;
      widget.formAF.musteriNumarasi = int.parse(_controllerMusteriNumarasi.text);
      widget.formAF.musteriSikayetleri = _controllerMusteriSikayetleri.text;
      widget.formAF.yanindaGelenler = parseYanindaGelenlerForSave(_controllerYanindaGelenler.text);
      widget.formAF.onTespit = _controllerOnTespit.text;
      widget.formAF.turboyuGetiren = _controllerTurboyuGetiren.text;
      widget.formAF.tasimaUcreti = double.parse(_controllerTasimaUcreti.text);
      widget.formAF.teslimAdresi = _controllerTeslimAdresi.text;
      widget.formAF.tarihIPF = DateTime.parse(_controllerTarihIPF.text);
      widget.formAF.tespitEdilen = _controllerTespitEdilen.text;
      widget.formAF.yapilanIslemler = _controllerYapilanIslemler.text;

      // Save the updated model to Firebase
      await AccountingFormRepo.instance.updateAccountingForm(widget.formAF.id!, widget.formAF);
      var inProgressForm = await InProgressFormRepo.instance.getFormByEgeTurboNo(widget.formAF.egeTurboNo);
      if (inProgressForm != null) {
        inProgressForm.tarihWOF = widget.formAF.tarihWOF;
        inProgressForm.turboNo = widget.formAF.turboNo;
        inProgressForm.aracBilgileri = widget.formAF.aracBilgileri;
        inProgressForm.aracKm = widget.formAF.aracKm;
        inProgressForm.aracPlaka = widget.formAF.aracPlaka;
        inProgressForm.musteriAdi = widget.formAF.musteriAdi;
        inProgressForm.musteriNumarasi = widget.formAF.musteriNumarasi;
        inProgressForm.musteriSikayetleri = widget.formAF.musteriSikayetleri;
        inProgressForm.yanindaGelenler = widget.formAF.yanindaGelenler;
        inProgressForm.onTespit = widget.formAF.onTespit;
        inProgressForm.turboyuGetiren = widget.formAF.turboyuGetiren;
        inProgressForm.tasimaUcreti = widget.formAF.tasimaUcreti;
        inProgressForm.teslimAdresi = widget.formAF.teslimAdresi;
        inProgressForm.tarihIPF = widget.formAF.tarihIPF;
        inProgressForm.tespitEdilen = widget.formAF.tespitEdilen;
        inProgressForm.yapilanIslemler = widget.formAF.yapilanIslemler;

        // Save the updated accounting model to Firebase
        await InProgressFormRepo.instance.updateInProgressForm(inProgressForm.id!, inProgressForm);
      }
    }

    Navigator.of(context).pop(); // Close the dialog
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountingRatingPage(formAF: widget.formAF,)));

  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: appBar(context, "Detaylar"),
      bottomNavigationBar: bottomNavAcc(),
      body: SafeArea(
        child: Stack(
          children: [
            background(context),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ... (existing code)


                  // Update other detailSections using CustomTextField
                  CustomTextField(
                    controller: _controllerTarihWOF,
                    label: 'Süreç Tarihi',
                  ),
                  CustomTextField(
                    controller: _controllerTurboNo,
                    label: 'Turbo No',
                  ),
                  CustomTextField(
                    controller: _controllerAracBilgileri,
                    label: 'Araç Bilgileri',
                  ),
                  CustomTextField(
                    controller: _controllerAracKm,
                    label: 'Araç Km',
                  ),
                  CustomTextField(
                    controller: _controllerAracPlaka,
                    label: 'Araç Plakası',
                  ),
                  CustomTextField(
                    controller: _controllerMusteriAdi,
                    label: 'Müşteri Ad Soyad',
                  ),
                  CustomTextField(
                    controller: _controllerMusteriNumarasi,
                    label: 'Müşteri Numarası',
                  ),
                  CustomTextField(
                    controller: _controllerMusteriSikayetleri,
                    label: 'Müşteri Şikayetleri',
                  ),
                  CustomTextField(
                    controller: _controllerYanindaGelenler,
                    label: 'Yanında Gelenler',
                  ),
                  CustomTextField(
                    controller: _controllerOnTespit,
                    label: 'Ön Tespit',
                  ),
                  CustomTextField(
                    controller: _controllerTurboyuGetiren,
                    label: 'Turboyu Getiren',
                  ),
                  CustomTextField(
                    controller: _controllerTasimaUcreti,
                    label: 'Taşıma Ücreti',
                  ),
                  CustomTextField(
                    controller: _controllerTeslimAdresi,
                    label: 'Teslim Adresi',
                  ),
                  CustomTextField(
                    controller: _controllerTarihIPF,
                    label: 'Süreç Tarihi',
                  ),
                  CustomTextField(
                    controller: _controllerTespitEdilen,
                    label: 'Tespit Edilen',
                  ),
                  CustomTextField(
                    controller: _controllerYapilanIslemler,
                    label: 'Yapılan İşlemler',
                  ),

                  ElevatedButton(
                    onPressed: () {
                      if (_hasChanges) {
                        showSaveAlertDialog(context, _saveChanges, AccountingRatingPage(formAF: widget.formAF));
                      } else {
                        // If no changes, navigate directly to the next page
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountingRatingPage(formAF: widget.formAF)));
                      }
                    },
                    child: Text(
                      'Devam',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.cyanAccent,
                      onPrimary: Colors.black,
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
          ],
        ),
      ),
    );
  }

}